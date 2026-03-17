# ==============================================================================
# Herramienta 2: Fortificador de Windows Defender
# ==============================================================================

# Comprobacion de privilegios
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) { Write-Warning "Ejecuta como Administrador."; pause; exit }

function Mostrar-Menu {
    $prefs = Get-MpPreference
    Clear-Host
    Write-Host "======================================================" -ForegroundColor Cyan
    Write-Host "   ESCUDO DEFENDER: GESTION DE SEGURIDAD" -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Cyan
    
    $puaStatus = if ($prefs.PUAProtection -eq 1) { "ACTIVADO" } else { "DESACTIVADO" }
    Write-Host " [1] Proteccion PUA:         $puaStatus"
    
    $cloudStatus = if ($prefs.CloudBlockLevel -ne 0) { "ALTO" } else { "NORMAL" }
    Write-Host " [2] Nivel Nube:             $cloudStatus"
    
    $ransomStatus = if ($prefs.EnableControlledFolderAccess -eq 1) { "ACTIVADO" } else { "DESACTIVADO" }
    Write-Host " [3] Anti-Ransomware:        $ransomStatus"
    
    $netStatus = if ($prefs.EnableNetworkProtection -eq 1) { "ACTIVADO" } else { "DESACTIVADO" }
    Write-Host " [4] Proteccion de Red:      $netStatus"

    Write-Host ""
    Write-Host " [S] Salir al menu principal"
    Write-Host "======================================================"
}

while ($true) {
    Mostrar-Menu
    $opcion = Read-Host "Elige una opcion"

    switch ($opcion) {
        "1" { 
            $curr = (Get-MpPreference).PUAProtection
            $val = if ($curr -eq 1) { 0 } else { 1 }
            Set-MpPreference -PUAProtection $val 
        }
        "2" { 
            $curr = (Get-MpPreference).CloudBlockLevel
            $val = if ($curr -eq 0) { "High" } else { "0" }
            Set-MpPreference -CloudBlockLevel $val 
        }
        "3" { 
            $curr = (Get-MpPreference).EnableControlledFolderAccess
            $val = if ($curr -eq 1) { 0 } else { 1 }
            Set-MpPreference -EnableControlledFolderAccess $val 
        }
        "4" { 
            $curr = (Get-MpPreference).EnableNetworkProtection
            $val = if ($curr -eq 1) { 0 } else { 1 }
            Set-MpPreference -EnableNetworkProtection $val 
        }
        "s" { return }
        default { Write-Host "Opcion no valida"; Start-Sleep -Seconds 1 }
    }
}