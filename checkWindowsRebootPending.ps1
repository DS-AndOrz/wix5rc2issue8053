# Function to check if a registry value exists
function Test-RegistryValue {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    try {
        $null = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Function to get a registry value
function Get-RegistryValue {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    try {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Name -ErrorAction Stop
    }
    catch {
        return $null
    }
}

$rebootPending = $false

# Check if a Windows reboot registry value exists
$rebootSource = 'Key = HKLM:\SOFTWARE\Microsoft\ServerManager Value = CurrentRebootAttempts'
if (Test-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\ServerManager' -Name 'CurrentRebootAttempts') {
    $dword = Get-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\ServerManager' -Name 'CurrentRebootAttempts'
    "ReturnValue = $dword"
    $rebootPending = $dword -gt 0
    if ($rebootPending) {
        "$rebootSource requires a reboot."
    }

}

$rebootSource = 'Key = HKLM:\SOFTWARE\Microsoft\Updates Value = UpdateExeVolatile'
if (Test-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\Updates' -Name 'UpdateExeVolatile') {
    $dword = Get-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\Updates' -Name 'UpdateExeVolatile'
    "ReturnValue = $dword"
    $rebootPending = $dword -gt 0
    if ($rebootPending) {
        "$rebootSource requires a reboot."
    }
}

$rebootSource = 'Key = HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
$rebootPending = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
if ($rebootPending) {
    "$rebootSource requires a reboot."
}

$rebootSource = 'Key = HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootInProgress'
$rebootPending = Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootInProgress'
if ($rebootPending) {
    "$rebootSource requires a reboot."
}
$rebootPending = $false

$rebootSource = 'Key = HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update Value = AUState'
if (Test-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'AUState') {
    $dword = Get-RegistryValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'AUState'
    "ReturnValue = $dword"
    $rebootPending = $dword -eq 8
    if ($rebootPending) {
        "$rebootSource requires a reboot."
    }
}

$rebootSource = 'Key = HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager Value = PendingFileRenameOperations'
$rebootPending = Test-RegistryValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'PendingFileRenameOperations'
if ($rebootPending) {
    "$rebootSource requires a reboot."
}
$rebootPending = $false

$rebootSource = 'Key = HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager Value = PendingFileRenameOperations2'
$rebootPending = Test-RegistryValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'PendingFileRenameOperations2'
if ($rebootPending) {
    "$rebootSource requires a reboot."
}
$rebootPending = $false

$rebootSource = 'Key = HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\FileRenameOperations'
try {
    $test = @(Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\FileRenameOperations' | Select-Object -expandproperty Property)
    if ($test.Count -gt 0) {
        "$rebootSource requires a reboot."
    }
}
catch {}
