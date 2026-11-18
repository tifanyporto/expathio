# Expathio deployment script (ADR 0016). Runs on the Windows development computer.
# It sends one version to a target over SSH and runs ops/deploy/remote.sh there.
#
#   Deploy:   .\ops\deploy\deploy.ps1 -Target phone -TestsPassed
#   Rollback: .\ops\deploy\deploy.ps1 -Target phone -Action Rollback [-Release <id>]
#   Status:   .\ops\deploy\deploy.ps1 -Target phone -Action Status
#
# -Target <name> reads ops/deploy/targets/<name>.target (git-ignored; see phone.target.example).
# -TargetFile <path> reads any target file instead (used by the local test).
# -SourceDir <path> deploys a folder instead of the current Git commit (used by the local test).
#
# Stops at the first failure and returns a non-zero exit code. Never prints secrets.

param(
    [ValidateSet('Deploy', 'Rollback', 'Status')] [string]$Action = 'Deploy',
    [string]$Target,
    [string]$TargetFile,
    [string]$SourceDir,
    [string]$Release,
    [switch]$TestsPassed
)

$ErrorActionPreference = 'Continue'   # native tools report through $LASTEXITCODE
function Stop-Deploy($message) { Write-Output "[deploy] STOPPED: $message"; exit 1 }

# --- 1. Read the target file --------------------------------------------------
if (-not $TargetFile) {
    if (-not $Target) { Stop-Deploy 'give -Target <name> or -TargetFile <path>' }
    $TargetFile = Join-Path $PSScriptRoot "targets\$Target.target"
}
if (-not (Test-Path $TargetFile)) { Stop-Deploy "target file not found: $TargetFile (copy targets\phone.target.example)" }

$settings = @{}
$confLines = New-Object System.Collections.Generic.List[string]
foreach ($line in Get-Content $TargetFile) {
    if ($line -match '^\s*([A-Z_][A-Z0-9_]*)=(.*)$') {
        $key = $Matches[1]; $value = $Matches[2].Trim()
        if ($value -match "^'(.*)'$" -or $value -match '^"(.*)"$') { $value = $Matches[1] }
        $settings[$key] = $value
        # SSH settings stay on this computer; everything else is sent to the target.
        if (-not $key.StartsWith('SSH_')) { $confLines.Add($line) }
    }
}
foreach ($required in 'SSH_HOST', 'SSH_USER', 'BASE_DIR', 'HEALTH_URL') {
    if (-not $settings[$required]) { Stop-Deploy "$required is missing in $TargetFile" }
}

$sshArgs = @()
$scpArgs = @()
if ($settings['SSH_PORT']) { $sshArgs += @('-p', $settings['SSH_PORT']); $scpArgs += @('-P', $settings['SSH_PORT']) }
if ($settings['SSH_KEY'])  { $sshArgs += @('-i', $settings['SSH_KEY']);  $scpArgs += @('-i', $settings['SSH_KEY']) }
if ($settings['SSH_OPTIONS']) {
    foreach ($opt in ($settings['SSH_OPTIONS'] -split '\s+' | Where-Object { $_ })) { $sshArgs += @('-o', $opt); $scpArgs += @('-o', $opt) }
}
$remote = "$($settings['SSH_USER'])@$($settings['SSH_HOST'])"

# --- 2. Prepare the files to send ---------------------------------------------
$stamp = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssfffZ')
$work = Join-Path ([IO.Path]::GetTempPath()) "expathio-deploy-$stamp"
New-Item -ItemType Directory -Path $work | Out-Null

try {
    if ($Action -eq 'Deploy') {
        if (-not $TestsPassed) {
            Stop-Deploy 'run the full test suite first (ADR 0016, step 1), then pass -TestsPassed'
        }
        if ($SourceDir) {
            if (-not (Test-Path $SourceDir)) { Stop-Deploy "source folder not found: $SourceDir" }
            $label = 'dir'
        } else {
            $repoRoot = (& git -C $PSScriptRoot rev-parse --show-toplevel).Trim()
            if (& git -C $repoRoot status --porcelain) { Stop-Deploy 'the working tree has uncommitted changes; commit or discard them first' }
            $label = (& git -C $repoRoot rev-parse --short HEAD).Trim()
        }
        $upload = "$stamp-$label"
        $package = Join-Path $work "expathio-$upload.tar.gz"
        if ($SourceDir) {
            & tar -czf $package -C $SourceDir .
        } else {
            # Only files tracked by Git: ignored files such as .env never leave the computer.
            & git -C $repoRoot archive --format=tar.gz -o $package HEAD
        }
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $package)) { Stop-Deploy 'could not build the package' }
        Write-Output "[deploy] release $upload, package $([math]::Round((Get-Item $package).Length / 1KB)) KB"
    } else {
        $upload = "$stamp-$($Action.ToLower())"
    }

    # Target settings and the remote script, with Linux line endings.
    $conf = Join-Path $work "expathio-$upload.conf"
    [IO.File]::WriteAllText($conf, (($confLines -join "`n") + "`n"))
    $remoteScript = Join-Path $work "expathio-$upload-remote.sh"
    [IO.File]::WriteAllText($remoteScript, ((Get-Content -Raw (Join-Path $PSScriptRoot 'remote.sh')) -replace "`r", ''))

    # --- 3. Send (one password prompt if the target uses a password) ----------
    $files = @(Get-ChildItem $work | ForEach-Object { $_.FullName })
    Write-Output "[deploy] sending $($files.Count) file(s) to the target"
    & scp -q @scpArgs @files "${remote}:/tmp/"
    if ($LASTEXITCODE -ne 0) { Stop-Deploy 'could not copy files to the target (network, SSH access or password)' }

    # --- 4. Run on the target (second password prompt if a password is used) --
    $remoteArgs = @('sh', "/tmp/expathio-$upload-remote.sh", $Action.ToLower(), $upload)
    if ($Action -eq 'Rollback' -and $Release) { $remoteArgs += $Release }
    & ssh @sshArgs $remote @remoteArgs
    $code = $LASTEXITCODE
    if ($code -ne 0) { Write-Output "[deploy] FAILED on the target (exit $code). See ops/deploy/README.md."; exit $code }
    Write-Output "[deploy] done: $Action"
    exit 0
}
finally {
    Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
}
