# Tests ops/deploy/deploy.ps1 and remote.sh against a local stand-in for the phone
# (ADR 0031: the deployment script is tested on a local target first).
# Runs on the Windows development computer. Never touches the phone or the project containers.
#
# Run from the repository root:
#   powershell -ExecutionPolicy Bypass -File .\ops\deploy\test\test-deploy.ps1
#
# What it does: builds a small Alpine edge image with SSH and Node.js, starts it on
# 127.0.0.1:2222 with a throwaway SSH key, then deploys versions of a fixture app:
#   v1 ok, v2 ok, v3 migration fails, v4 health check fails, then rolls back.
# Removes the container, the image and the key at the end.
# Prints one line per check. Exit code = number of failed checks.

$ErrorActionPreference = 'Continue'
$here = $PSScriptRoot
$deploy = Join-Path (Split-Path $here -Parent) 'deploy.ps1'
$image = 'expathio-deploy-target-test'
$container = 'expathio-deploy-target-test'
$port = 2222
$work = Join-Path ([IO.Path]::GetTempPath()) ("expathio-deploy-test-" + [guid]::NewGuid().ToString('N').Substring(0, 8))

$failures = 0
function Check($name, $ok, $detail) {
    Write-Output ("[{0}] {1} - {2}" -f $(if ($ok) { 'OK  ' } else { 'FAIL' }), $name, $detail)
    if (-not $ok) { $script:failures++ }
}

function On-Target($cmd) {
    $out = & docker exec -u deploy $container sh -c $cmd 2>&1
    return (($out | ForEach-Object { "$_" }) -join "`n").Trim()
}

function Invoke-Deploy([string[]]$extra) {
    $out = & powershell -NoProfile -ExecutionPolicy Bypass -File $deploy -TargetFile $targetFile @extra 2>&1
    $code = $LASTEXITCODE
    $text = ($out | ForEach-Object { "$_" }) -join "`n"
    Add-Content -Path (Join-Path $work 'deploy-output.log') -Value "### $($extra -join ' ') (exit $code)`n$text`n"
    return @{ Code = $code; Out = $text }
}

function New-Version($name, [string[]]$flags) {
    $dir = Join-Path $work $name
    Copy-Item -Recurse (Join-Path $here 'fixture-app') $dir
    Set-Content -Path (Join-Path $dir 'VERSION') -Value $name -NoNewline
    foreach ($f in $flags) { Set-Content -Path (Join-Path $dir $f) -Value 'test' }
    return $dir
}

if (& docker ps -a --filter "name=^$container$" --format '{{.Names}}') {
    Write-Output "ERROR: a container named $container already exists. Remove it first: docker rm -f $container"
    exit 99
}

New-Item -ItemType Directory -Path $work | Out-Null
try {
    # Throwaway SSH key, valid only for this container.
    $key = Join-Path $work 'id_ed25519'
    & cmd /c "ssh-keygen -q -t ed25519 -N `"`" -C expathio-deploy-test -f `"$key`"" | Out-Null
    if (-not (Test-Path $key)) { throw 'could not create the test SSH key' }
    $pub = (Get-Content "$key.pub" -Raw).Trim()

    Write-Output 'Building the test target image (Alpine edge, SSH, Node.js)...'
    & docker build -q -t $image $here | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'docker build failed' }
    $env:AUTHORIZED_KEY = $pub
    & docker run -d --name $container -p "127.0.0.1:${port}:22" -e AUTHORIZED_KEY $image | Out-Null
    Remove-Item Env:AUTHORIZED_KEY
    if ($LASTEXITCODE -ne 0) { throw 'docker run failed' }
    Start-Sleep -Seconds 2
    Write-Output ("Target: Alpine {0}, Node {1}" -f (On-Target 'cat /etc/alpine-release'), (On-Target 'node --version'))
    Write-Output ''

    $targetFile = Join-Path $work 'local-test.target'
    @(
        "SSH_HOST='127.0.0.1'",
        "SSH_USER='deploy'",
        "SSH_PORT='$port'",
        "SSH_KEY='$key'",
        "SSH_OPTIONS='StrictHostKeyChecking=no UserKnownHostsFile=NUL LogLevel=ERROR BatchMode=yes'",
        "BASE_DIR='/home/deploy/expathio'",
        "HEALTH_URL='http://127.0.0.1:3000/health'",
        "HEALTH_TIMEOUT='8'",
        "KEEP_RELEASES='3'",
        "INSTALL_CMD='test -f server.js'",
        "PRE_MIGRATION_BACKUP_CMD='echo backup-of-database > `"`$BACKUP_FILE`"'",
        "MIGRATE_CMD='sh migrate.sh'",
        "RESTART_CMD='sh restart.sh'"
    ) | Set-Content -Path $targetFile

    $live = { (On-Target 'basename $(readlink /home/deploy/expathio/current)') }
    $health = { (On-Target 'wget -q -O - http://127.0.0.1:3000/health 2>&1 || echo unhealthy') }

    # 0. Refuses to deploy without the tests confirmation
    $r = Invoke-Deploy @('-SourceDir', (New-Version 'v0'))
    Check 'Refuses without -TestsPassed' ($r.Code -ne 0 -and $r.Out -match 'TestsPassed') 'stopped before sending anything'

    # 1. First deployment
    $r = Invoke-Deploy @('-SourceDir', (New-Version 'v1'), '-TestsPassed')
    Check 'Deploy v1' ($r.Code -eq 0) "exit $($r.Code)"
    $h = & $health
    Check 'v1 healthy' ($h -match '"version":"v1"') $h
    $release1 = & $live

    # 2. Second deployment keeps the previous one
    $r = Invoke-Deploy @('-SourceDir', (New-Version 'v2'), '-TestsPassed')
    Check 'Deploy v2' ($r.Code -eq 0) "exit $($r.Code)"
    $h = & $health
    Check 'v2 healthy' ($h -match '"version":"v2"') $h
    $release2 = & $live
    $prev = On-Target 'cat /home/deploy/expathio/previous'
    Check 'Previous version kept' ($prev -eq $release1 -and (On-Target "test -d /home/deploy/expathio/releases/$release1 && echo yes") -eq 'yes') "previous = $prev"
    $backup = On-Target "cat /home/deploy/expathio/backups/pre-$release2.dump"
    Check 'Backup taken before migration' ($backup -eq 'backup-of-database') "backups/pre-$release2.dump"

    # 3. Migration fails: the live version must not change
    $r = Invoke-Deploy @('-SourceDir', (New-Version 'v3' @('MIGRATE_FAIL')), '-TestsPassed')
    Check 'Failed migration stops the deploy' ($r.Code -ne 0 -and $r.Out -match 'FAILED: migration') "exit $($r.Code)"
    Check 'Live version unchanged after failed migration' ((& $live) -eq $release2 -and (& $health) -match '"version":"v2"') (& $live)

    # 4. Health check fails: the deploy reports it and stops
    $r = Invoke-Deploy @('-SourceDir', (New-Version 'v4' @('BROKEN')), '-TestsPassed')
    Check 'Failed health check stops the deploy' ($r.Code -ne 0 -and $r.Out -match 'FAILED: health check') "exit $($r.Code)"
    $h = & $health
    Check 'Broken v4 is reported unhealthy' ($h -notmatch '"status":"ok"') $h

    # 5. Rollback to the previous version
    $r = Invoke-Deploy @('-Action', 'Rollback')
    Check 'Rollback' ($r.Code -eq 0) "exit $($r.Code)"
    $h = & $health
    Check 'v2 healthy after rollback' ((& $live) -eq $release2 -and $h -match '"version":"v2"') $h

    # 6. Status, and no leftover upload files on the target
    $r = Invoke-Deploy @('-Action', 'Status')
    Check 'Status lists the live release' ($r.Code -eq 0 -and $r.Out -match [regex]::Escape("live: $release2")) "exit $($r.Code)"
    $left = On-Target 'ls /tmp/expathio-* 2>/dev/null | wc -l'
    Check 'Upload files cleaned up on the target' ($left -eq '0') "files left in /tmp: $left"

    # 7. Only the configured number of releases is kept
    $count = On-Target 'ls /home/deploy/expathio/releases | wc -l'
    Check 'Old releases pruned (keep 3 + live + previous)' ([int]$count -le 5) "releases on target: $count"
}
catch {
    Check 'Test run' $false "$_"
}
finally {
    & docker rm -f $container 2>$null | Out-Null
    & docker rmi $image 2>$null | Out-Null
    $leftContainer = & docker ps -a --filter "name=^$container$" --format '{{.Names}}'
    Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
    Write-Output ''
    Write-Output $(if ($leftContainer) { "WARNING: container $container was not removed." } else { 'Test container, image and key removed.' })
}

Write-Output $(if ($failures -eq 0) { 'Summary: all checks passed.' } else { "Summary: $failures check(s) failed." })
exit $failures
