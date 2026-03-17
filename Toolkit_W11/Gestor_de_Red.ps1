# ==============================================================================
# Herramienta 4: Gestor y Reductor de Superficie de Red
# ==============================================================================

# Comprobacion de privilegios
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { 
    Write-Warning "Ejecuta como Administrador."; pause; exit 
}

function Mostrar-MenuRed {
    Clear-Host
    Write-Host "======================================================" -ForegroundColor Cyan
    Write-Host "   GESTOR DE RED: REDUCCION DE SUPERFICIE DE ATAQUE" -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Cyan
    
    # 1. SMBv1
    $smb1 = (Get-SmbServerConfiguration).EnableSMB1Protocol
    $smbStatus = if ($smb1) { "PELIGRO (Activo)" } else { "SEGURO (OFF)" }
    $smbColor = if ($smb1) { "Red" } else { "Green" }
    Write-Host " [1] Protocolo SMBv1:       " -NoNewline; Write-Host $smbStatus -ForegroundColor $smbColor

    # 2. LLMNR
    $llmnrPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
    $llmnrVal = (Get-ItemProperty -Path $llmnrPath -Name "EnableMulticast" -ErrorAction SilentlyContinue).EnableMulticast
    $llmnrStatus = if ($llmnrVal -eq 0) { "SEGURO (OFF)" } else { "PELIGRO (Activo)" }
    $llmnrColor = if ($llmnrVal -eq 0) { "Green" } else { "Red" }
    Write-Host " [2] Protocolo LLMNR:       " -NoNewline; Write-Host $llmnrStatus -ForegroundColor $llmnrColor

    # 3. NetBIOS
    $netbiosActive = Get-WmiObject Win32_NetworkAdapterConfiguration -Filter "IpEnabled = True" | Where-Object { $_.TcpipNetbiosOptions -ne 2 }
    $nbStatus = if ($netbiosActive) { "PELIGRO (Activo)" } else { "SEGURO (OFF)" }
    $nbColor = if ($netbiosActive) { "Red" } else { "Green" }
    Write-Host " [3] NetBIOS sobre TCP/IP:  " -NoNewline; Write-Host $nbStatus -ForegroundColor $nbColor

    # 4. RDP
    $rdpVal = (Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -ErrorAction SilentlyContinue).fDenyTSConnections
    $rdpStatus = if ($rdpVal -eq 0) { "ABIERTO (Activo)" } else { "CERRADO (OFF)" }
    $rdpColor = if ($rdpVal -eq 0) { "Yellow" } else { "Green" }
    Write-Host " [4] Escritorio Remoto RDP: " -NoNewline; Write-Host $rdpStatus -ForegroundColor $rdpColor

    Write-Host ""
    Write-Host " [S] Volver al menu principal"
    Write-Host "======================================================"
}

while ($true) {
    Mostrar-MenuRed
    $opcionRed = Read-Host "Elige una opcion (1-4 o S)"

    switch ($opcionRed) {
        "1" { 
            $current = (Get-SmbServerConfiguration).EnableSMB1Protocol
            Set-SmbServerConfiguration -EnableSMB1Protocol (-not $current) -Force 
        }
        "2" {
            $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
            if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            $val = (Get-ItemProperty -Path $path -Name "EnableMulticast" -ErrorAction SilentlyContinue).EnableMulticast
            $new = if ($val -eq 0) { 1 } else { 0 }
            Set-ItemProperty -Path $path -Name "EnableMulticast" -Value $new -Type DWord -Force
        }
        "3" {
            $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration -Filter "IpEnabled = True"
            $isActive = $adapters | Where-Object { $_.TcpipNetbiosOptions -ne 2 }
            $newVal = if ($isActive) { 2 } else { 0 }
            $adapters | Invoke-WmiMethod -Name SetTcpipNetbios -ArgumentList $newVal | Out-Null
        }
        "4" {
            $path = "HKLM:\System\CurrentControlSet\Control\Terminal Server"
            $val = (Get-ItemProperty -Path $path -Name "fDenyTSConnections").fDenyTSConnections
            $new = if ($val -eq 0) { 1 } else { 0 }
            Set-ItemProperty -Path $path -Name "fDenyTSConnections" -Value $new -Type DWord -Force
        }
        "s" { return }
        default { Write-Host "Opcion no valida"; Start-Sleep -Seconds 1 }
    }
}