# 🔒 Controles de Seguridad Implementados

Lista de controles aplicados por el **Win11 Hardening Toolkit**, organizados por dominio de seguridad.

---

## 1. 🦠 Protección contra Malware (`Apoyo_Defender.ps1`)

| # | Control | Descripción técnica | Cmdlet / Clave |
|---|---------|---------------------|----------------|
| 1.1 | **Protección PUA** | Bloquea la instalación de Aplicaciones Potencialmente No Deseadas (adware, toolbars, miners). | `Set-MpPreference -PUAProtection 1` |
| 1.2 | **Nivel de bloqueo en nube (HIGH)** | Eleva el umbral de análisis en la nube de Defender para bloquear amenazas zero-day con mayor agresividad. | `Set-MpPreference -CloudBlockLevel High` |
| 1.3 | **Acceso controlado a carpetas (Anti-Ransomware)** | Impide que procesos no autorizados modifiquen ficheros en carpetas protegidas (Documentos, Escritorio, etc.). | `Set-MpPreference -EnableControlledFolderAccess 1` |
| 1.4 | **Protección de Red** | Bloquea conexiones salientes a dominios e IPs maliciosas conocidas mediante SmartScreen a nivel de red. | `Set-MpPreference -EnableNetworkProtection 1` |

---

## 2. 🔍 Detección de Procesos Sospechosos (`Process_Hunter.ps1`)

| # | Control | Descripción técnica | Técnica |
|---|---------|---------------------|---------|
| 2.1 | **Detección de procesos ocultos** | Compara la lista de procesos de la API .NET (`Get-Process`) con la de WMI (`Win32_Process`). Los que solo aparecen en WMI están ocultos al Task Manager. | Cross-reference API vs WMI |
| 2.2 | **Detección por ruta inusual** | Marca como sospechosos los procesos ejecutándose desde rutas de alto riesgo: `AppData`, `Temp`, `Downloads`, `Public`. | Regex path matching |
| 2.3 | **Verificación de firma digital** | Comprueba que el ejecutable del proceso tenga una firma Authenticode válida. Sin firma válida = sospechoso. | `Get-AuthenticodeSignature` |
| 2.4 | **Terminación selectiva con GUI** | Permite al administrador seleccionar y matar procesos sospechosos desde una interfaz gráfica integrada sin instalar nada. | `Out-GridView -PassThru` + `Stop-Process -Force` |

---

## 3. 🌐 Reducción de Superficie de Red (`Gestor_de_Red.ps1`)

| # | Control | Descripción técnica | Protocolo / Clave |
|---|---------|---------------------|-------------------|
| 3.1 | **Desactivación de SMB v1** | Elimina el protocolo SMBv1, vector de ataques como WannaCry y NotPetya. | `Set-SmbServerConfiguration -EnableSMB1Protocol $false` |
| 3.2 | **Control de RDP** | Habilita o deshabilita el Escritorio Remoto para reducir la superficie de acceso remoto. | `Set-ItemProperty ... fDenyTSConnections` |
| 3.3 | **Desactivación de LLMNR** | Deshabilita el protocolo LLMNR, susceptible a ataques de envenenamiento (LLMNR Poisoning / Responder). | GPO vía registro: `DNSClient\EnableMulticast = 0` |

---

## 4. 🔌 Control de Dispositivos (`Control_USB.ps1`)

| # | Control | Descripción técnica | Clave de registro |
|---|---------|---------------------|-------------------|
| 4.1 | **Bloqueo de almacenamiento USB** | Deshabilita el driver `USBSTOR` impidiendo el montaje de cualquier unidad USB de almacenamiento. | `HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR\Start = 4` |
| 4.2 | **Desbloqueo de almacenamiento USB** | Restaura el driver `USBSTOR` a su estado operativo cuando se necesita acceso autorizado. | `HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR\Start = 3` |

---

## 5. 🕵️ Privacidad y Eliminación de Telemetría (`Escudo_Privacidad.ps1`)

| # | Control | Descripción técnica |
|---|---------|---------------------|
| 5.1 | **Desactivación de telemetría** | Reduce o elimina el envío de datos diagnósticos a Microsoft. |
| 5.2 | **Eliminación de bloatware** | Desinstala aplicaciones preinstaladas innecesarias que pueden suponer riesgo o consumo de recursos. |

---

## 📊 Resumen por Categoría

| Dominio | Nº de controles |
|---------|-----------------|
| Protección contra Malware | 4 |
| Detección de Procesos | 4 |
| Superficie de Red | 3 |
| Control de Dispositivos | 2 |
| Privacidad / Telemetría | 2 |
| **TOTAL** | **15** |

---

> **Nota:** Todos los controles requieren ejecución con privilegios de **Administrador local**. Algunos cambios (USBSTOR, LLMNR) requieren reinicio del sistema para aplicarse completamente.
