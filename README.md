🛡️ Win11 Hardening Toolkit
Este proyecto es una suite de herramientas de bastionado (hardening) desarrollada en PowerShell para Windows 11. Está diseñada para administradores de sistemas y profesionales de ciberseguridad que necesitan reducir la superficie de ataque de un equipo de forma rápida, interactiva y reversible.

⚙️ Descripción Técnica
El toolkit opera mediante la manipulación directa de configuraciones de bajo nivel del sistema operativo, agrupadas en cinco vectores críticos:

Privacidad y Telemetría (Escudo_Privacidad.ps1): Modifica objetos del Registro de Windows (HKLM) para desactivar el flujo de datos hacia servidores de Microsoft y utiliza el módulo Appx para la purga forzada de software preinstalado (bloatware).

Protección Proactiva (Apoyo_Defender.ps1): Interactúa con el motor de Windows Defender mediante el comando Set-MpPreference, habilitando niveles de protección en la nube (Cloud Block Level) y protección contra aplicaciones potencialmente no deseadas (PUA) que no vienen activas por defecto.

Auditoría Forense de Procesos (Process_Hunter.ps1): Implementa un análisis comparativo entre la lista de procesos estándar y consultas CIM/WMI (Win32_Process). Esto permite detectar procesos que se ocultan de las APIs de usuario y verificar la integridad de los binarios mediante firmas digitales (Get-AuthenticodeSignature).

Gestión de Superficie de Red (Gestor_de_Red.ps1): Administra protocolos heredados vulnerables como SMBv1, LLMNR y NetBIOS, además de controlar el estado del servicio de Escritorio Remoto (RDP).

Control de Hardware (Control_USB.ps1): Manipula el estado de inicio del driver USBSTOR en el registro del sistema, permitiendo bloquear el almacenamiento masivo USB sin afectar a periféricos como teclados o ratones.

📥 Instalación
Clonar el repositorio:

Bash
git clone https://github.com/TU_USUARIO/Win11-Hardening-Toolkit.git
Ubicación: Asegúrate de mantener todos los archivos .ps1 en la misma carpeta para que el script principal pueda invocarlos correctamente.

🚀 Uso
El toolkit requiere privilegios de Administrador para modificar registros y servicios del sistema.

Abre PowerShell como Administrador.

(Opcional) Si las políticas de Windows bloquean el script, ejecuta:

PowerShell
Set-ExecutionPolicy Bypass -Scope Process
Lanza el menú principal:

PowerShell
.\Hardening_Hugo.ps1
📝 Ejemplo Real de Ejecución
Imagina que necesitas securizar un equipo que se va a conectar a una red pública o desconocida:

Reducción de red: Ejecutas la opción [4], entras al "Gestor de Red" y desactivas LLMNR y NetBIOS. Esto evita que atacantes en la misma red puedan robar tus credenciales mediante técnicas de poisoning.

Blindaje de hardware: Seleccionas la opción [5] para bloquear los puertos USB. Si alguien intenta conectar un pendrive malicioso con un payload, el sistema simplemente no cargará el dispositivo.

Escaneo de seguridad: Finalmente, lanzas la opción [3] (Cazador de Procesos). El script detecta un proceso ejecutándose desde la carpeta Temp y sin firma digital; lo seleccionas en la ventana emergente y lo finalizas de inmediato.
