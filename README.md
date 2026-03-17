🛡️ Win11 Hardening Toolkit
Este proyecto es una suite interactiva de scripts en PowerShell diseñada para aplicar políticas de bastionado (hardening) en sistemas Windows 11. El objetivo es minimizar la superficie de ataque automatizando tareas complejas de seguridad y privacidad en una interfaz unificada.

⚙️ Descripción Técnica de las Herramientas
El toolkit se compone de un núcleo central (Hardening_Hugo.ps1) que orquestra cinco módulos especializados:

1. Escudo de Privacidad (Escudo_Privacidad.ps1)
Funcionamiento: Modifica claves del registro en HKLM para deshabilitar la telemetría (AllowTelemetry), el ID de publicidad y Cortana.

Limpieza: Ejecuta un barrido profundo de paquetes Appx para eliminar bloatware (software preinstalado innecesario) como Microsoft News, XboxApp y BingWeather.

2. Fortificador de Defender (Apoyo_Defender.ps1)
Funcionamiento: Utiliza el cmdlet Set-MpPreference para forzar configuraciones de seguridad de nivel empresarial.

Protecciones: Activa el bloqueo de Aplicaciones Potencialmente No Deseadas (PUA), eleva el nivel de protección en la nube a "Alto" y habilita la protección de red y el acceso controlado a carpetas (Anti-Ransomware).

3. Auditoría de Procesos (Process_Hunter.ps1)
Funcionamiento: Realiza una comparación entre los procesos reportados por las APIs estándar y los reportados por CIM/WMI (Win32_Process) para detectar procesos ocultos (stealth).

Análisis: Evalúa rutas de ejecución sospechosas (AppData, Temp, Downloads) y verifica la validez de la firma digital de los binarios activos.

4. Gestión de Superficie de Red (Gestor_de_Red.ps1)
Funcionamiento: Desactiva protocolos heredados y vulnerables. Actúa sobre SMBv1, LLMNR y NetBIOS sobre TCP/IP.

RDP: Permite habilitar o deshabilitar el Escritorio Remoto modificando la clave fDenyTSConnections en el registro.

5. Bloqueo de Almacenamiento USB (Control_USB.ps1)
Funcionamiento: Controla el servicio USBSTOR modificando su valor de inicio en el registro.

Impacto: Al establecer el valor en 4, el sistema ignora memorias USB y discos externos de almacenamiento, manteniendo funcionales los periféricos de entrada como teclados y ratones.

📥 Instalación
Descarga o clona este repositorio en tu equipo.

Asegúrate de que todos los archivos .ps1 estén en la misma carpeta raíz.

Abre una terminal de PowerShell con privilegios de Administrador.

🚀 Uso General
Para ejecutar el toolkit, utiliza el siguiente comando en PowerShell:

PowerShell
Set-ExecutionPolicy Bypass -Scope Process; .\Hardening_Hugo.ps1
📝 Ejemplos de Ejecución Real
A continuación, se describen escenarios prácticos de uso para cada herramienta:

Escenario 1: Limpieza de sistema nuevo

Acción: Ejecutas la opción [1] Escudo de Privacidad.

Resultado: El script elimina automáticamente aplicaciones como Solitario, Skype y Xbox, mientras bloquea el envío de datos de telemetría a Microsoft, optimizando el rendimiento y la privacidad desde el primer minuto.

Escenario 2: Blindaje contra Malware y Ransomware

Acción: Accedes a la opción [2] Fortificador de Defender.

Resultado: Activas el "Anti-Ransomware" (Acceso controlado a carpetas). Si un programa no autorizado intenta cifrar tus documentos, Windows Defender bloqueará la acción inmediatamente.

Escenario 3: Investigación forense básica

Acción: Inicias la opción [3] Auditoría de Procesos.

Resultado: El script te muestra una lista de procesos sin firma digital o ejecutándose desde carpetas temporales. Seleccionas uno sospechoso en la interfaz y el script lo finaliza (Stop-Process) al instante.

Escenario 4: Securización de red en entornos locales

Acción: Entras en la opción [4] Gestión de Red.

Resultado: Desactivas SMBv1 y LLMNR. Esto evita que un atacante en tu misma red local pueda interceptar peticiones de nombre de red o explotar vulnerabilidades antiguas de compartición de archivos.

Escenario 5: Prevención de exfiltración de datos (DLP)

Acción: Utilizas la opción [5] Bloqueo de USB.

Resultado: Seleccionas "BLOQUEAR". Si alguien intenta conectar un pendrive para copiar información confidencial, Windows no reconocerá el dispositivo de almacenamiento, pero tu teclado y ratón seguirán funcionando.
