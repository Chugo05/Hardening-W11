# ==============================================================================
# WIN11 HARDENING TOOLKIT - Menú Principal
# ==============================================================================

# Comprobación de privilegios de Administrador al inicio
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "######################################################" -ForegroundColor Red
    Write-Host " ERROR: DEBES EJECUTAR ESTE TOOLKIT COMO ADMINISTRADOR" -ForegroundColor Red
    Write-Host "######################################################" -ForegroundColor Red
    Pause
    Exit
}

function Mostrar-Banner {
    Clear-Host
    Write-Host "  __      __.__        ________  ____" -ForegroundColor Cyan
    Write-Host " /  \    /  \__| ____ /_   __  \/_   |" -ForegroundColor Cyan
    Write-Host " \   \/\/   /  |/    \ |   __  / |   |" -ForegroundColor Cyan
    Write-Host "  \        /|  |   |  \|   | \ \ |   |" -ForegroundColor Cyan
    Write-Host "   \__/\  / |__|___|  /|___|  \/ |___|" -ForegroundColor Cyan
    Write-Host "        \/          \/ Hardening Toolkit" -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Gray
    Write-Host " Creado por: Chugo_05" -ForegroundColor Gray
    Write-Host "======================================================"
}

while ($true) {
    Mostrar-Banner
    Write-Host " Selecciona un modulo de bastionado:"
    Write-Host ""
    Write-Host " [1] Escudo de Privacidad (Telemetria y Programas Basura)"
    Write-Host " [2] Fortificador de Windows Defender"
    Write-Host " [3] Auditoria de Procesos (Cazador de Stealth Malware)"
    Write-Host " [4] Gestion de Superficie de Red (SMB, RDP, LLMNR)"
    Write-Host " [5] Bloqueo de Puertos USB"
    Write-Host ""
    Write-Host " [S] Salir del Toolkit"
    Write-Host "------------------------------------------------------"
    
    $opcion = Read-Host "Opcion"

    switch ($opcion) {
        "1" { & ".\Escudo_Privacidad.ps1" }
        "2" { & ".\Apoyo_Defender.ps1" }
        "3" { & ".\Process_Hunter.ps1" }
        "4" { & ".\Gestor_de_Red.ps1" }
        "5" { & ".\Control_USB.ps1" }
        "s" { 
            Write-Host "Saliendo...¡Mantente seguro!" -ForegroundColor Cyan
            Start-Sleep -Seconds 1
            Exit 
        }
        default { 
            Write-Host "Opción no válida." -ForegroundColor Yellow
            Start-Sleep -Seconds 1 
        }
    }
}