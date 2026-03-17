
# ==============================================================================
# Herramienta 3: Cazador de Procesos Sospechosos
# ==============================================================================

# Comprobacion de privilegios
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { 
    Write-Warning "Ejecuta como Administrador."; pause; exit 
}

Write-Host "Iniciando escaneo de seguridad..." -ForegroundColor Cyan

# 1. Obtener listas para comparar
$standardList = Get-Process | Select-Object -ExpandProperty Id
$lowLevelList = Get-CimInstance Win32_Process | Select-Object -ExpandProperty ProcessId

# 2. Buscar procesos que se ocultan del Task Manager
$hiddenPIDs = Compare-Object -ReferenceObject $standardList -DifferenceObject $lowLevelList -PassThru | Where-Object { $_.SideIndicator -eq "=>" }

$suspiciousList = New-Object System.Collections.Generic.List[PSObject]
$allProcs = Get-CimInstance Win32_Process

foreach ($proc in $allProcs) {
    $isSuspicious = $false
    $reasons = @()
    
    # Deteccion de proceso oculto
    if ($hiddenPIDs -contains $proc.ProcessId) { 
        $isSuspicious = $true
        $reasons += "OCULTO" 
    }
    
    # Deteccion por ruta sospechosa
    $path = $proc.ExecutablePath
    if ($path -match "AppData|Temp|Downloads|Public") { 
        $isSuspicious = $true
        $reasons += "Ruta Inusual" 
    }
    
    # Deteccion por firma digital
    if ($null -ne $path -and (Test-Path $path)) {
        $sig = Get-AuthenticodeSignature -FilePath $path
        if ($sig.Status -ne "Valid") { 
            $isSuspicious = $true
            $reasons += "Sin Firma" 
        }
    }

    if ($isSuspicious) {
        $motivoFinal = $reasons -join " | "
        $obj = [PSCustomObject]@{
            PID    = $proc.ProcessId
            Nombre = $proc.Name
            Motivo = $motivoFinal
            Ruta   = $path
        }
        $suspiciousList.Add($obj)
    }
}

# 3. Mostrar resultados
if ($suspiciousList.Count -gt 0) {
    Write-Host "ADVERTENCIA: Se han detectado $($suspiciousList.Count) procesos sospechosos." -ForegroundColor Yellow
    Write-Host "Selecciona en la lista los que quieras finalizar y pulsa Aceptar."
    
    $toKill = $suspiciousList | Out-GridView -Title "Auditoria de Procesos" -PassThru
    
    if ($null -ne $toKill) {
        foreach ($p in $toKill) {
            Stop-Process -Id $p.PID -Force -ErrorAction SilentlyContinue
            Write-Host "Proceso $($p.Nombre) (PID: $($p.PID)) finalizado." -ForegroundColor Red
        }
    }
} else {
    Write-Host "No se detectaron procesos ocultos ni sospechosos." -ForegroundColor Green
}

Write-Host "------------------------------------------------------"
Write-Host "Presiona una tecla para volver al menu principal..."
$null = [System.Console]::ReadKey($true)
return