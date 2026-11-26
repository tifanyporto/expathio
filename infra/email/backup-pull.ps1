<#
.SYNOPSIS
Pulls a backup of the mail server to this computer over SSH.

.DESCRIPTION
Runs expathio-mail-backup on the host through SSH, saves the archive in the
destination folder as mail-<date>-<time>.tar.gz, checks that it can be read,
and then deletes the oldest archives beyond the number to keep. Every run adds
a line to backup.log in the destination folder.

The SSH connection must work without questions: key authentication without a
passphrase prompt, the host already in known_hosts, and sudo on the host
without a password for expathio-mail-backup.

Works with Windows PowerShell 5.1 and the ssh.exe and tar.exe that ship with
Windows.

.EXAMPLE
.\backup-pull.ps1 -Server user@host -Destination D:\backups\mail

.EXAMPLE
.\backup-pull.ps1 -Server user@host -Destination D:\backups\mail -Keep 60
#>
param(
    [Parameter(Mandatory = $true)][string]$Server,
    [Parameter(Mandatory = $true)][string]$Destination,
    [int]$Keep = 30,
    [int]$Attempts = 3
)

$ErrorActionPreference = 'Stop'
if ($Keep -lt 1) { throw 'Keep must be at least 1.' }

New-Item -ItemType Directory -Force -Path $Destination | Out-Null
$log = Join-Path $Destination 'backup.log'
function Write-Log([string]$text) {
    $line = '{0} {1}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $text
    Add-Content -Path $log -Value $line -Encoding ascii
    Write-Output $line
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$final = Join-Path $Destination "mail-$stamp.tar.gz"
$part = "$final.part"
$errors = Join-Path $Destination 'last-error.txt'
$reason = 'no attempt was made'
$done = $false

for ($i = 1; $i -le $Attempts -and -not $done; $i++) {
    if ($i -gt 1) { Start-Sleep -Seconds 30 }
    # Start-Process connects the file to the program's output directly, so the
    # archive is not altered on the way (a PowerShell pipeline would alter it).
    $ssh = Start-Process -FilePath 'ssh.exe' -NoNewWindow -Wait -PassThru `
        -ArgumentList @('-o', 'BatchMode=yes', '-o', 'ConnectTimeout=30', $Server, 'sudo -n expathio-mail-backup') `
        -RedirectStandardOutput $part -RedirectStandardError $errors
    if ($ssh.ExitCode -ne 0) {
        $reason = "ssh or the backup command failed with exit code $($ssh.ExitCode) (see last-error.txt)"
        continue
    }
    $entries = @(& tar.exe -tzf $part 2>$null)
    if ($LASTEXITCODE -ne 0) { $reason = 'the archive cannot be read'; continue }
    if ($entries -notcontains 'etc/dovecot/users') { $reason = 'the archive does not contain the account file'; continue }
    $done = $true
}

if (-not $done) {
    Remove-Item -Path $part -ErrorAction SilentlyContinue
    Write-Log "FAILED after $Attempts attempts: $reason"
    exit 1
}

Move-Item -Path $part -Destination $final
Remove-Item -Path $errors -ErrorAction SilentlyContinue
$size = (Get-Item $final).Length
Write-Log "ok $(Split-Path $final -Leaf) $size bytes, $($entries.Count) entries"

# Only after a good new archive: delete the oldest ones beyond the limit.
$old = Get-ChildItem -Path $Destination -Filter 'mail-*.tar.gz' | Sort-Object Name -Descending | Select-Object -Skip $Keep
foreach ($file in $old) {
    Remove-Item -Path $file.FullName
    Write-Log "removed $($file.Name)"
}
exit 0
