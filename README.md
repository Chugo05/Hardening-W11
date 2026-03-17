# 🛡️ Win11 Hardening Toolkit

![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)
![Windows 11](https://img.shields.io/badge/Windows%2011-%230079d5.svg?style=for-the-badge&logo=Windows%2011&logoColor=white)

Este es un toolkit integral de bastionado (hardening) para sistemas Windows 11, desarrollado en PowerShell. El objetivo es reducir la superficie de ataque del sistema operativo mediante la automatización de políticas de seguridad, limpieza de telemetría y auditoría de bajo nivel.

## 🚀 Módulos Principales

1.  **Escudo de Privacidad**: Desactivación de telemetría, ID de publicidad y purga profunda de bloatware de Microsoft.
2.  **Fortificador de Defender**: Configuración de protección contra aplicaciones potencialmente no deseadas (PUA), protección en la nube avanzada y anti-ransomware.
3.  **Process Hunter**: Análisis forense comparando la lista de procesos estándar contra consultas CIM/WMI para detectar procesos ocultos (stealth) y binarios sin firma digital.
4.  **Gestor de Red**: Control de protocolos heredados vulnerables (SMBv1, LLMNR, NetBIOS) y gestión de RDP.
5.  **Control de USB**: Bloqueo y desbloqueo selectivo de dispositivos de almacenamiento masivo a nivel de registro (`USBSTOR`).

## 🛠️ Instalación y Uso

### Requisitos previos
* Sistema Operativo: Windows 11 (preferiblemente).
* Privilegios: **Administrador**.

### Ejecución rápida
Para ejecutar el toolkit sin restricciones de política de ejecución, abre una terminal de PowerShell como administrador y lanza:

```powershell
Set-ExecutionPolicy Bypass -Scope Process; .\Hardening_Hugo.ps1
