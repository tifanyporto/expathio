# Local development checks for Expathio (ops/local-setup.md, section 6).
# Runs on the Windows development computer only (ADR 0015).
# Prints one line per check and a summary. Never prints passwords.
#
# Run from the repository root:
#   powershell -ExecutionPolicy Bypass -File .\ops\check-local.ps1

$ErrorActionPreference = 'Continue'
$opsDir = $PSScriptRoot
$composeFile = Join-Path $opsDir 'docker-compose.yml'
$nvmrc = Join-Path $opsDir '.nvmrc'
$containerName = 'expathio-postgres-dev'
$hostPort = 5433

# Port from ops/.env when it is set, otherwise the default in the guide.
$envFile = Join-Path $opsDir '.env'
if (Test-Path $envFile) {
    $line = Select-String -Path $envFile -Pattern '^POSTGRES_HOST_PORT=(\d+)' | Select-Object -First 1
    if ($line) { $hostPort = [int]$line.Matches[0].Groups[1].Value }
}

$results = New-Object System.Collections.Generic.List[string]
$failures = 0

function Add-Result($name, $ok, $detail) {
    $script:results.Add(("[{0}] {1} - {2}" -f $(if ($ok) { 'OK  ' } else { 'FAIL' }), $name, $detail))
    if (-not $ok) { $script:failures++ }
}

# 1. Node.js major version must match ops/.nvmrc
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = (& node --version).Trim()
    $wanted = (Get-Content $nvmrc -TotalCount 1).Trim()
    $okNode = $nodeVersion.StartsWith("v$wanted.")
    Add-Result 'Node.js major version' $okNode "found $nodeVersion, expected major $wanted"
} else {
    Add-Result 'Node.js major version' $false 'node is not on the PATH'
}

# 2. Docker engine must answer
$dockerOk = $false
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $serverVersion = (& docker version --format '{{.Server.Version}}' 2>$null)
    if ($LASTEXITCODE -eq 0 -and $serverVersion) {
        $dockerOk = $true
        Add-Result 'Docker engine' $true "server version $serverVersion"
    } else {
        Add-Result 'Docker engine' $false 'docker is installed but the engine did not answer; open Docker Desktop and wait'
    }
} else {
    Add-Result 'Docker engine' $false 'docker is not installed (ops/local-setup.md, section 2)'
}

# 3. The Compose file must be valid. --quiet prints nothing, so no secret is shown.
if ($dockerOk) {
    & docker compose -f $composeFile config --quiet 2>$null
    if ($LASTEXITCODE -eq 0) {
        Add-Result 'Compose file' $true 'docker-compose.yml is valid (ops/.env is read)'
    } else {
        Add-Result 'Compose file' $false 'invalid, or ops/.env is missing POSTGRES_PASSWORD (ops/local-setup.md, section 3)'
    }
} else {
    Add-Result 'Compose file' $false 'skipped: Docker engine not available'
}

# 4. The database container must be healthy
if ($dockerOk) {
    $health = (& docker inspect -f '{{.State.Health.Status}}' $containerName 2>$null)
    if ($LASTEXITCODE -eq 0 -and $health) {
        Add-Result 'PostgreSQL container health' ($health -eq 'healthy') "container $containerName is $health"
    } else {
        Add-Result 'PostgreSQL container health' $false "container $containerName does not exist; run 'docker compose up -d' in ops/"
    }
} else {
    Add-Result 'PostgreSQL container health' $false 'skipped: Docker engine not available'
}

# 5. The database port must accept connections on this computer only
$portOpen = Test-NetConnection -ComputerName 127.0.0.1 -Port $hostPort -InformationLevel Quiet -WarningAction SilentlyContinue
Add-Result 'PostgreSQL port' ([bool]$portOpen) "127.0.0.1:$hostPort"

Write-Output ''
$results | ForEach-Object { Write-Output $_ }
Write-Output ''
if ($failures -eq 0) {
    Write-Output 'Summary: all checks passed.'
} else {
    Write-Output "Summary: $failures check(s) failed. See the lines above and ops/local-setup.md."
}
exit $failures
