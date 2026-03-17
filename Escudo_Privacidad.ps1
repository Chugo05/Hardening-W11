# ==============================================================================
# Herramienta 1: Escudo de Privacidad, Telemetría y Bloatware para Windows 11
# ==============================================================================

# 1. Comprobación de privilegios de Administrador
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Warning "⚠️ Esta herramienta necesita permisos de Administrador."
    Write-Host "Por favor, cierra este script, abre PowerShell como Administrador y vuelve a ejecutarlo." -ForegroundColor Yellow
    Pause
    Exit
}

Write-Host "✅ Permisos de administrador confirmados. Iniciando bastionado..." -ForegroundColor Green
Write-Host "------------------------------------------------------"

# 2. Desactivar Telemetría de Windows
Write-Host "[*] Desactivando Telemetría..."
$telemetryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
if (-not (Test-Path $telemetryPath)) { New-Item -Path $telemetryPath -Force | Out-Null }
Set-ItemProperty -Path $telemetryPath -Name "AllowTelemetry" -Value 0 -Type DWord -Force

# 3. Desactivar ID de Publicidad
Write-Host "[*] Desactivando ID de Publicidad..."
$adPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
if (-not (Test-Path $adPath)) { New-Item -Path $adPath -Force | Out-Null }
Set-ItemProperty -Path $adPath -Name "Enabled" -Value 0 -Type DWord -Force

# 4. Desactivar Cortana
Write-Host "[*] Desactivando Cortana..."
$cortanaPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (-not (Test-Path $cortanaPath)) { New-Item -Path $cortanaPath -Force | Out-Null }
Set-ItemProperty -Path $cortanaPath -Name "AllowCortana" -Value 0 -Type DWord -Force

# 5. Desinstalación de Bloatware (Aplicaciones basura)
Write-Host "[*] Iniciando purga de Bloatware..."
$bloatwareList = @(
    "*Microsoft.BingWeather*",
    "*Microsoft.GetHelp*",
    "*Microsoft.Getstarted*",
    "*Microsoft.Messaging*",
    "*Microsoft.Microsoft3DViewer*",
    "*Microsoft.MicrosoftSolitaireCollection*",
    "*Microsoft.NetworkSpeedTest*",
    "*Microsoft.News*",
    "*Microsoft.Office.OneNote*",
    "*Microsoft.SkypeApp*",
    "*Microsoft.WindowsMaps*",
    "*Microsoft.XboxApp*",
    "*Microsoft.XboxGamingOverlay*",
    "*Microsoft.ZuneMusic*",
    "*Microsoft.ZuneVideo*",
    "*Microsoft.Todos*"
)

foreach ($app in $bloatwareList) {
    Write-Host "    -> Buscando y eliminando: $app" -ForegroundColor DarkGray
    # Eliminamos la app para el usuario actual
    Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue
    
    # Eliminamos la app del sistema base para que no se reinstale al crear un usuario nuevo
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $app } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
}

Write-Host "------------------------------------------------------"
Write-Host "🎉 ¡Bastionado de privacidad y limpieza completado con éxito!" -ForegroundColor Cyan