# Tests ops/db-roles/create-roles.sh in a throwaway PostgreSQL container.
# Runs on the Windows development computer (ADR 0015). Never touches the
# project containers (expathio-postgres, expathio-postgres-dev) or the phone.
#
# Run from the repository root:
#   powershell -ExecutionPolicy Bypass -File .\ops\db-roles\test-roles.ps1
#   powershell -ExecutionPolicy Bypass -File .\ops\db-roles\test-roles.ps1 -Image postgres:18.6
#
# Passwords are random, live only in this process and are thrown away with the container.
# Prints one line per check. Exit code = number of failed checks.

param([string]$Image = 'postgres:18.6')

# 'Continue': in Windows PowerShell 5.1 a native command writing to stderr would
# otherwise stop the script, and some checks expect an error on purpose.
# Failures are detected through $LASTEXITCODE instead.
$ErrorActionPreference = 'Continue'
$container = 'expathio-roles-test'
$db = 'expathio_roles_test'
$script = Join-Path $PSScriptRoot 'create-roles.sh'

function New-Secret { -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object { [char]$_ }) }
$superPw = New-Secret; $ownerPw = New-Secret; $appPw = New-Secret

$failures = 0
function Check($name, $ok, $detail) {
    Write-Output ("[{0}] {1} - {2}" -f $(if ($ok) { 'OK  ' } else { 'FAIL' }), $name, $detail)
    if (-not $ok) { $script:failures++ }
}

# Runs SQL as a role over TCP inside the container, so the password is really checked.
# The image trusts 127.0.0.1 without a password, so the container's network
# address is used instead ($script:pgHost, set after start-up).
function Invoke-As($role, $password, $sql) {
    $env:PGPASSWORD = $password
    $out = & docker exec -e PGPASSWORD $container psql -X -q -t -A -v ON_ERROR_STOP=1 -h $script:pgHost -U $role -d $db -c $sql 2>&1
    $code = $LASTEXITCODE
    Remove-Item Env:PGPASSWORD
    return @{ Code = $code; Out = (($out | ForEach-Object { "$_" }) -join "`n").Trim() }
}

function Invoke-CreateRoles {
    $env:EXPATHIO_DB = $db; $env:EXPATHIO_OWNER_PASSWORD = $ownerPw; $env:EXPATHIO_APP_PASSWORD = $appPw
    $out = & docker exec -e EXPATHIO_DB -e EXPATHIO_OWNER_PASSWORD -e EXPATHIO_APP_PASSWORD -u postgres $container sh /tmp/create-roles.sh 2>&1
    $code = $LASTEXITCODE
    Remove-Item Env:EXPATHIO_DB, Env:EXPATHIO_OWNER_PASSWORD, Env:EXPATHIO_APP_PASSWORD
    return @{ Code = $code; Out = (($out | ForEach-Object { "$_" }) -join "`n") }
}

if (& docker ps -a --filter "name=^$container$" --format '{{.Names}}') {
    Write-Output "ERROR: a container named $container already exists. Remove it first: docker rm -f $container"
    exit 99
}

try {
    Write-Output "Starting throwaway container $container ($Image), no port published..."
    $env:POSTGRES_PASSWORD = $superPw
    & docker run -d --name $container -e POSTGRES_PASSWORD -e POSTGRES_DB=$db $Image | Out-Null
    Remove-Item Env:POSTGRES_PASSWORD
    if ($LASTEXITCODE -ne 0) { throw "docker run failed" }
    # Wait until the server accepts TCP connections (the image restarts once after init).
    $ready = $false
    for ($i = 0; $i -lt 60 -and -not $ready; $i++) {
        Start-Sleep -Seconds 1
        & docker exec $container pg_isready -h 127.0.0.1 -U postgres -d $db 2>$null | Out-Null
        $ready = ($LASTEXITCODE -eq 0)
    }
    if (-not $ready) { throw "server did not become ready" }
    $version = (& docker exec $container psql -X -t -A -U postgres -d $db -c 'SHOW server_version;').Trim()
    Write-Output "Server version: $version"
    $script:pgHost = ((& docker exec $container hostname -i) -split ' ')[0].Trim()
    Write-Output ''

    & docker cp $script "${container}:/tmp/create-roles.sh" | Out-Null

    # 1. Missing input stops without changes
    $r = & docker exec -u postgres $container sh /tmp/create-roles.sh 2>&1
    Check 'Missing input refused' ($LASTEXITCODE -eq 2) (($r | Select-Object -First 1) -as [string])

    # 2. First run
    $r = Invoke-CreateRoles
    Check 'First run' ($r.Code -eq 0) ("exit $($r.Code)")
    if ($r.Code -ne 0) { Write-Output $r.Out }

    # 3. Second run (idempotent)
    $r = Invoke-CreateRoles
    Check 'Second run (safe to repeat)' ($r.Code -eq 0) ("exit $($r.Code)")

    # 4. Role attributes
    $attrs = (& docker exec $container psql -X -t -A -U postgres -d $db -c "SELECT string_agg(rolname||':'||rolcanlogin::int||rolsuper::int||rolbypassrls::int||rolcreatedb::int||rolcreaterole::int, ',' ORDER BY rolname) FROM pg_roles WHERE rolname IN ('expathio_owner','expathio_app');").Trim()
    Check 'Role attributes' ($attrs -eq 'expathio_app:10000,expathio_owner:10000') "login=1, superuser/bypassrls/createdb/createrole=0: $attrs"

    $member = (& docker exec $container psql -X -t -A -U postgres -d $db -c "SELECT pg_has_role('expathio_app','expathio_owner','MEMBER');").Trim()
    Check 'App is not a member of owner' ($member -eq 'f') "pg_has_role = $member"

    # 5. Passwords work over TCP; a wrong password is refused
    $r = Invoke-As 'expathio_owner' $ownerPw 'SELECT current_user;'
    Check 'Owner logs in with its password' ($r.Code -eq 0 -and $r.Out -eq 'expathio_owner') $r.Out
    $r = Invoke-As 'expathio_app' $appPw 'SELECT current_user;'
    Check 'App logs in with its password' ($r.Code -eq 0 -and $r.Out -eq 'expathio_app') $r.Out
    $r = Invoke-As 'expathio_app' 'wrong-password' 'SELECT 1;'
    Check 'Wrong password refused' ($r.Code -ne 0) 'login failed as expected'

    # 6. Only the owner creates objects
    $r = Invoke-As 'expathio_app' $appPw 'CREATE TABLE app_should_not_create (id int);'
    Check 'App cannot create tables' ($r.Code -ne 0) 'permission denied as expected'

    # 7. Row-level security with these roles (a sample table, the way a migration would do it)
    $setup = @"
CREATE TABLE demo_items (organization_id uuid NOT NULL, label text NOT NULL);
ALTER TABLE demo_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE demo_items FORCE ROW LEVEL SECURITY;
CREATE POLICY demo_isolation ON demo_items
  USING (organization_id = nullif(current_setting('app.organization_id', true), '')::uuid)
  WITH CHECK (organization_id = nullif(current_setting('app.organization_id', true), '')::uuid);
GRANT SELECT, INSERT ON demo_items TO expathio_app;
"@
    $r = Invoke-As 'expathio_owner' $ownerPw $setup
    Check 'Owner creates a table with RLS' ($r.Code -eq 0) $(if ($r.Code -eq 0) { 'ok' } else { $r.Out })

    $orgA = '11111111-1111-1111-1111-111111111111'; $orgB = '22222222-2222-2222-2222-222222222222'
    $ins = "BEGIN; SELECT set_config('app.organization_id','$orgA',true); INSERT INTO demo_items VALUES ('$orgA','a'); COMMIT; BEGIN; SELECT set_config('app.organization_id','$orgB',true); INSERT INTO demo_items VALUES ('$orgB','b'); COMMIT;"
    $r = Invoke-As 'expathio_app' $appPw $ins
    Check 'App inserts within its organization' ($r.Code -eq 0) $(if ($r.Code -eq 0) { 'ok' } else { $r.Out })

    $r = Invoke-As 'expathio_app' $appPw 'SELECT count(*) FROM demo_items;'
    Check 'App without context sees nothing' ($r.Out -eq '0') "rows = $($r.Out)"

    $r = Invoke-As 'expathio_app' $appPw "BEGIN; SELECT set_config('app.organization_id','$orgA',true); SELECT string_agg(label, ',') FROM demo_items; COMMIT;"
    $last = ($r.Out -split "`n" | Select-Object -Last 1).Trim()
    Check 'App with context A sees only A' ($r.Code -eq 0 -and $last -eq 'a') "labels = $last"

    $r = Invoke-As 'expathio_app' $appPw "BEGIN; SELECT set_config('app.organization_id','$orgA',true); INSERT INTO demo_items VALUES ('$orgB','x'); COMMIT;"
    Check 'App cannot write into another organization' ($r.Code -ne 0) 'refused by policy as expected'

    $r = Invoke-As 'expathio_owner' $ownerPw 'SELECT count(*) FROM demo_items;'
    Check 'Owner is subject to RLS (FORCE)' ($r.Out -eq '0') "rows without context = $($r.Out)"
}
catch {
    Check 'Test run' $false "$_"
}
finally {
    & docker rm -f $container 2>$null | Out-Null
    $left = & docker ps -a --filter "name=^$container$" --format '{{.Names}}'
    Write-Output ''
    Write-Output $(if ($left) { "WARNING: container $container was not removed." } else { "Throwaway container removed." })
}

Write-Output $(if ($failures -eq 0) { 'Summary: all checks passed.' } else { "Summary: $failures check(s) failed." })
exit $failures
