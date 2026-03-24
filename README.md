# 🛡️ Win11 Hardening Toolkit — by Chugo_05

Toolkit modular de bastionado para **Windows 11** escrito en PowerShell. Permite reforzar la seguridad del sistema operativo mediante un menú interactivo que agrupa distintas herramientas de hardening, cada una enfocada en un vector de ataque diferente.

---

## 📋 Descripción técnica

El toolkit está compuesto por un **script orquestador** (`Hardening_Hugo.ps1`) que actúa como menú principal, y varios **módulos independientes** invocados dinámicamente con `& ".\<script>.ps1"`. Cada módulo comprueba privilegios de administrador de forma autónoma antes de ejecutarse.

### Módulos incluidos

| Script | Módulo | Descripción |
|---|---|---|
| `Hardening_Hugo.ps1` | Menú Principal | Orquestador central con banner ASCII y navegación por menú |
| `Escudo_Privacidad.ps1` | Escudo de Privacidad | Desactiva la telemetría de Windows y elimina bloatware preinstalado |
| `Apoyo_Defender.ps1` | Fortificador de Windows Defender | Panel de control para ajustar políticas avanzadas de Defender vía `Set-MpPreference` |
| `Process_Hunter.ps1` | Cazador de Procesos Sospechosos | Auditoría de procesos en tiempo real: detecta procesos ocultos, rutas inusuales y ejecutables sin firma digital |
| `Gestor_de_Red.ps1` | Gestión de Superficie de Red | Control de protocolos de red peligrosos: SMBv1, RDP y LLMNR |
| `Control_USB.ps1` | Control de Puertos USB | Bloqueo/desbloqueo del driver `USBSTOR` mediante el registro de Windows |

### Detalles técnicos por módulo

**`Escudo_Privacidad.ps1`** — Actúa sobre dos vectores de privacidad:
- **Telemetría**: deshabilita el servicio `DiagTrack` y establece el nivel de diagnóstico al mínimo en `HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection → AllowTelemetry = 0`.
- **Bloatware**: desinstala aplicaciones preinstaladas mediante `Remove-AppxPackage` y `Get-AppxProvisionedPackage`.

**`Apoyo_Defender.ps1`** — Gestiona cuatro políticas de Defender con toggle ON/OFF en tiempo real:
- **Protección PUA** (`PUAProtection`): bloquea aplicaciones potencialmente no deseadas.
- **Nivel de nube** (`CloudBlockLevel`): eleva el bloqueo en la nube a nivel `High`.
- **Anti-Ransomware** (`EnableControlledFolderAccess`): protege carpetas del sistema contra modificaciones no autorizadas.
- **Protección de Red** (`EnableNetworkProtection`): bloquea conexiones a dominios maliciosos conocidos.

> ⚠️ **Compatibilidad:** Este módulo **no funcionará** si hay un antivirus de terceros instalado (Kaspersky, ESET, Avast, RAV Endpoint, Norton, etc.). Windows desactiva el servicio `WinDefend` automáticamente cuando detecta otro motor antivirus activo, lo que hace que `Get-MpPreference` y `Set-MpPreference` fallen con el error `HRESULT 0x800106ba`. Para usar este módulo es necesario desinstalar el antivirus de terceros y reiniciar el equipo, tras lo cual Defender se reactiva de forma automática.

**`Process_Hunter.ps1`** — Realiza tres capas de detección:
1. Cruza la lista de `Get-Process` con `Get-CimInstance Win32_Process` para identificar procesos que se ocultan del Task Manager.
2. Analiza la ruta del ejecutable en busca de ubicaciones de riesgo (`AppData`, `Temp`, `Downloads`, `Public`).
3. Verifica la firma digital con `Get-AuthenticodeSignature`. Los resultados se muestran en `Out-GridView` para terminar procesos de forma selectiva con `Stop-Process -Force`.

**`Gestor_de_Red.ps1`** — Controla tres protocolos de red con alto riesgo de explotación:
- **SMBv1**: deshabilita el protocolo mediante `Set-SmbServerConfiguration -EnableSMB1Protocol $false`, previniendo ataques tipo WannaCry.
- **RDP**: habilita o deshabilita el Escritorio Remoto vía `HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server → fDenyTSConnections`.
- **LLMNR**: desactiva el protocolo de resolución de nombres local susceptible a envenenamiento (Responder) en `HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient → EnableMulticast = 0`.

**`Control_USB.ps1`** — Modifica el valor `Start` del servicio `USBSTOR` en el registro (`HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR`):
- Valor `4` → driver **deshabilitado** (USB bloqueados).
- Valor `3` → driver **manual/activo** (USB desbloqueados).

---

## ⚙️ Instalación

### Requisitos previos
- Windows 11 (compatible con Windows 10 + PowerShell 5.1+)
- PowerShell 5.1 o superior
- Permisos de **Administrador**

### Pasos

**1. Clona el repositorio:**
```powershell
git clone https://github.com/TU_USUARIO/Win11-Hardening-Toolkit.git
cd Win11-Hardening-Toolkit
```

**2. Desbloquea los scripts** (Windows bloquea scripts descargados de internet por defecto):
```powershell
Get-ChildItem -Path . -Filter *.ps1 | Unblock-File
```

**3. Ajusta la política de ejecución** si es necesario:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🚀 Uso

Abre **PowerShell como Administrador**, navega a la carpeta del toolkit y ejecuta el orquestador:

```powershell
.\Hardening_Hugo.ps1
```

El menú principal mostrará las opciones disponibles:

```
  __      __.__        ________  ____
 /  \    /  \__| ____ /_   __  \/_   |
 \   \/\/   /  |/    \ |   __  / |   |
  \        /|  |   |  \|   | \ \ |   |
   \__/\  / |__|___|  /|___|  \/ |___|
        \/          \/ Hardening Toolkit
======================================================
 Creado por: Chugo_05
======================================================

 Selecciona un modulo de bastionado:

 [1] Escudo de Privacidad (Telemetria y Programas Basura)
 [2] Fortificador de Windows Defender
 [3] Auditoria de Procesos (Cazador de Stealth Malware)
 [4] Gestion de Superficie de Red (SMB, RDP, LLMNR)
 [5] Bloqueo de Puertos USB

 [S] Salir del Toolkit
```

También puedes ejecutar cada módulo de forma independiente:

```powershell
.\Apoyo_Defender.ps1
.\Process_Hunter.ps1
.\Control_USB.ps1
```

---

## 🧪 Ejemplo real de ejecución

### Escenario: Equipo corporativo con sospecha de malware introducido por USB

**Paso 1 — Bloquear USBs mientras se investiga**

Seleccionar opción `[5]` → `[1] BLOQUEAR puertos USB`

```
 Estado actual: DESBLOQUEADOS

 [1] BLOQUEAR puertos USB
 [2] DESBLOQUEAR puertos USB

Selecciona una accion: 1

 Estado actual: BLOQUEADOS
```
El registro `USBSTOR\Start` pasa de `3` a `4`. Ningún dispositivo de almacenamiento USB puede montarse hasta que se revierta.

---

**Paso 2 — Auditar procesos en ejecución**

Seleccionar opción `[3]`:

```
Iniciando escaneo de seguridad...

ADVERTENCIA: Se han detectado 3 procesos sospechosos.
Selecciona en la lista los que quieras finalizar y pulsa Aceptar.

PID    Nombre          Motivo                   Ruta
----   ------          ------                   ----
4821   updater.exe     Ruta Inusual | Sin Firma  C:\Users\User\AppData\Roaming\updater.exe
6032   svchost32.exe   OCULTO | Sin Firma        C:\Windows\Temp\svchost32.exe
7741   chrome.exe      Sin Firma                 C:\Users\User\Downloads\chrome.exe
```

Se abre una ventana `Out-GridView`. El analista selecciona los dos primeros y pulsa **Aceptar**:

```
Proceso updater.exe (PID: 4821) finalizado.
Proceso svchost32.exe (PID: 6032) finalizado.
```

---

**Paso 3 — Reforzar Defender**

> ⚠️ Este paso requiere que **no haya antivirus de terceros instalado**. Si el equipo tiene Kaspersky, ESET, RAV Endpoint u otro producto similar, Windows Defender estará desactivado y este módulo devolverá un error. Ver nota de compatibilidad en la sección de descripción técnica.

Seleccionar opción `[2]` y activar todas las protecciones:

```
 [1] Proteccion PUA:         DESACTIVADO   →  pulsar 1 para activar
 [2] Nivel Nube:             NORMAL        →  pulsar 2 para subir a ALTO
 [3] Anti-Ransomware:        DESACTIVADO   →  pulsar 3 para activar
 [4] Proteccion de Red:      DESACTIVADO   →  pulsar 4 para activar
```

Con cuatro pulsaciones el equipo queda con Defender en máxima capacidad de detección.

---

## 📁 Estructura del repositorio

```
Win11-Hardening-Toolkit/
├── Hardening_Hugo.ps1       # Menú principal / orquestador
├── Apoyo_Defender.ps1       # Módulo: Windows Defender
├── Process_Hunter.ps1       # Módulo: Auditoría de procesos
├── Control_USB.ps1          # Módulo: Bloqueo USB
├── Escudo_Privacidad.ps1    # Módulo: Privacidad y telemetría (próximamente)
├── Gestor_de_Red.ps1        # Módulo: Superficie de red (próximamente)
└── README.md
```

---

## ⚠️ Aviso legal

Este toolkit está diseñado para uso en **entornos propios o con autorización explícita**. El autor no se hace responsable del uso indebido de estas herramientas. Algunas acciones (bloqueo de USB, modificación de políticas de Defender) son **reversibles**, pero pueden requerir reinicio de servicios o del sistema para aplicarse completamente.

---

## 👤 Autor

**Chugo_05** — Toolkit de bastionado personal para Windows 11.
