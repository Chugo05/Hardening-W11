# ==============================================================================
# Herramienta 5: Control de Dispositivos de Almacenamiento USB
# ==============================================================================

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { 
    Write-Warning "Ejecuta como Administrador."; pause; exit 
}

function Mostrar-MenuUSB {
    $usbRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR"
    $currentStart = (Get-ItemProperty -Path $usbRegistryPath).Start

    Clear-Host
    Write-Host "======================================================" -ForegroundColor Cyan
    Write-Host "   CONTROL DE PUERTOS USB (ALMACENAMIENTO)" -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Cyan
    
    $statusText = if ($currentStart -eq 3) { "DESBLOQUEADOS" } else { "BLOQUEADOS" }
    $statusColor = if ($currentStart -eq 3) { "Yellow" } else { "Green" }
    
    Write-Host " Estado actual: " -NoNewline; Write-Host $statusText -ForegroundColor $statusColor
    Write-Host ""
    Write-Host " [1] BLOQUEAR puertos USB"
    Write-Host " [2] DESBLOQUEAR puertos USB"
    Write-Host ""
    Write-Host " [S] Volver al menu principal"
    Write-Host "======================================================"
}

while ($true) {
    Mostrar-MenuUSB
    $opcion = Read-Host "Selecciona una accion"

    switch ($opcion) {
        "1" { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 4 }
        "2" { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 3 }
        "s" { return } # Esto te devuelve al Toolkit.ps1
        default { Write-Host "Opcion no valida"; Start-Sleep -Seconds 1 }
    }
}