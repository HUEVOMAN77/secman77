🔥 SECMAN77 - Ultimate Security & Networking Tool v8.0


<p align="center">
  <img src="https://img.shields.io/badge/SECMAN77-ULTIMATE_TOOL-ff69b4" alt="SECMAN77">
  <br>
  <strong>All-in-one security testing & networking tool for Termux</strong>
  <br>
  <em>by HUEVOMAN77 - For authorized educational use only</em>
</p>

---

📋 ÍNDICE

· ✨ Características

· 🚀 Instalación Rápida

· 📱 Requisitos

· 🎮 Uso del Script

· 🔧 Funciones Principales

· 🌐 APNs Multipaís

· 🔐 Cuentas Gratuitas

· 📊 Ejemplos de Uso

· ⚠️ Advertencia Legal

· 📁 Estructura del Proyecto

· 🤝 Contribuciones

· 👤 Autor

· 📄 Licencia

---

✨ CARACTERÍSTICAS

🔍 Enumeración y Escaneo

· ✅ Enumeración avanzada de subdominios con detección Cloudflare

· ✅ Escaneo de puertos TCP/UDP con análisis de servicios

· ✅ Detección de vulnerabilidades comunes

· ✅ Búsqueda de subdominios ocultos con técnicas modernas

· ✅ Verificación HTTP/HTTPS con resaltado de estados 200 OK

🌐 Herramientas de Red

· ✅ Generador de APNs para 17 países de Centro y Suramérica

· ✅ Cuentas gratuitas (WebSocket, SSH, SSL, DNS) válidas por 7 días

· ✅ Análisis de servicios con sugerencias de inyección

· ✅ Pruebas de conectividad y velocidad de internet

· ✅ Escaneo de red local y dispositivos conectados

🛡️ Seguridad y Utilidades

· ✅ Interfaz numerada intuitiva (1-13 opciones)

· ✅ Configuración de alias personalizado

· ✅ Resultados guardados automáticamente

· ✅ Multi-hilo para escaneos rápidos

· ✅ Herramientas adicionales integradas

---

# 1. Clonar repositorio
git clone https://github.com/HUEVOMAN77/secman77.git

# 2. Entrar al directorio
cd secman77

# 3. Dar permisos de ejecución
chmod +x secman77.sh

# 4. Ejecutar script
./secman77.sh

Método 2: Instalación con Script de Ayuda

# Descargar e instalar automáticamente

curl -sL https://raw.githubusercontent.com/HUEVOMAN77/secman77/main/install.sh

----

Método 3: Instalación Manual en Termux

# Actualizar Termux
pkg update && pkg upgrade -y

# Instalar dependencias
pkg install -y curl wget git python python-pip

# Clonar repositorio
git clone https://github.com/HUEVOMAN77/secman77.git

-------

# Instalar dependencias Python

pip install requests dnspython

------

# Ejecutar

cd secman77

chmod +x secman77.sh

./secman77.sh

---

📱 REQUISITOS

· Sistema: Termux (Android)

· Versión: Termux v0.118 o superior

· Espacio: 50MB libre

· Internet: Conexión activa (para algunas funciones)

· Permisos: Almacenamiento (para guardar resultados)

---

🎮 USO DEL SCRIPT

Primera Ejecución

```bash
./secman77.sh
```

El script te pedirá:

1. Alias/Nickname - Para personalizar tu experiencia

2. Aceptación de términos - Uso educativo autorizado únicamente

3. Instalación de dependencias - Automática si es necesario

╔══════════════════════════════════════════════════════════╗
║            MENÚ PRINCIPAL - SECMAN77 v8.0               ║
╚══════════════════════════════════════════════════════════╝

[1]  Configurar objetivo

[2]  Enumeración avanzada de subdominios

[3]  Escaneo de puertos TCP

[4]  Escaneo UDP y DNS

[5]  Enumeración completa

[6]  Verificar subdominios 200 OK

[7]  Analizar servicios y vulnerabilidades

[8]  Configuración avanzada

[9]  Ver resultados guardados

[10] Instalar herramientas

[11] Generador de APNs Multipaís

[12] Generador de cuentas gratuitas (7 días)

[13] Herramientas adicionales

[0]  Salir

🔧 FUNCIONES PRINCIPALES

 Configurar Objetivo

Configura el dominio objetivo para escaneos
Ejemplo: ejemplo.com, google.com, etc.

2️⃣ Enumeración Avanzada de Subdominios

· Escaneo DNS con múltiples técnicas

· Detección de Cloudflare y CDNs

· Búsqueda de subdominios ocultos

· Verificación HTTP/HTTPS automática

3️⃣ Escaneo de Puertos TCP

```
Puertos comunes: 21,22,23,25,53,80,443,3306,3389,8080

Identificación automática de servicios
Sugerencias de vulnerabilidades por puerto
```

4️⃣ Escaneo UDP y DNS

· Escaneo de puertos UDP críticos
· Consultas DNS (A, AAAA, MX, TXT, NS, etc.)
· Detección de transferencia de zona

5️⃣ Enumeración Completa

----
Ejecuta automáticamente:

1. Enumeración de subdominios

2. Escaneo de puertos TCP

3. Escaneo UDP y DNS

4. Guarda todos los resultados

----+

6️⃣ Verificar Subdominios 200 OK

```
Muestra subdominios con respuesta HTTP 200K
Resaltado especial con colores
Fácil identificación de objetivos activos
```

7️⃣ Analizar Servicios y Vulnerabilidades

· Análisis detallado de servicios detectados
· Sugerencias de inyección por protocolo
· Recomendaciones de herramientas para testing

8️⃣ Configuración Avanzada

```
Ajustar número de hilos (10-100)

Cambiar puertos a escanear

Modificar timeout de conexión

Limpiar resultados anteriores
```

9️⃣ Ver Resultados Guardados

```
Muestra archivos de resultados anteriores
Permite ver contenido de cada archivo
Información de fecha y tamaño
```

🔟 Instalar Herramientas

```
Instalación de:
- Nmap (escaneo avanzado)

- Masscan (escaneo rápido)

- Herramientas Python adicionales

- Todas las herramientas necesarias
```

---

🌐 APNs MULTIPAÍS

Países Disponibles:

```
[1]  México          [7]  Panamá         [13] Chile
[2]  Guatemala       [8]  Colombia       [14] Argentina
[3]  El Salvador     [9]  Venezuela      [15] Uruguay
[4]  Honduras        [10] Ecuador        [16] Paraguay
[5]  Nicaragua       [11] Perú           [17] Brasil
[6]  Costa Rica      [12] Bolivia
```

Características:

· ✅ APNs para múltiples operadoras por país

· ✅ APNs alternativas para mejor conexión

· ✅ Guardado automático en archivo

· ✅ Fácil copia y pega para configuración

---

🔐 CUENTAS GRATUITAS

Tipos de Cuentas Disponibles:

```
[1] WebSocket + SSL (7 días)

[2] SSH (7 días)

[3] SSL/TLS (7 días)

[4] DNS (7 días)

```

Características:

· ✅ Válidas por 7 días - Renovables

· ✅ Configuración automática - Enlaces listos para usar

· ✅ Prueba de conexión - Verifica estado del servidor

· ✅ Gestión de cuentas - Ver, renovar, eliminar

-------

Ejemplo de Cuenta Generada:

[+] Cuenta WebSocket generada exitosamente!

═ INFORMACIÓN DE LA CUENTA ═

Usuario: huevoman77_abc123

Contraseña: XyZ!123$abc

Servidor: ws-us1.hostfree.com:443

Protocolo: WebSocket + TLS

Válido hasta: 2024-01-15

---------

═ ENLACE DE CONFIGURACIÓN ═
ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpYYVohMTIzJGFiY0B3cy11czEuaG9zdGZyZWUuY29tOjQ0Mw==#SECMAN77-huevoman77_abc123
```

---

📊 EJEMPLOS DE USO

Ejemplo 1: Escanear un dominio completo

```bash
./secman77.sh

# Selecciona: [1] Configurar objetivo
# Ingresa: ejemplo.com

# Selecciona: [5] Enumeración completa

# Espera resultados (5-10 minutos)

# Selecciona: [6] Ver subdominios 200 OK
```

Ejemplo 2: Obtener APN para México

```bash
./secman77.sh

# Selecciona: [11] Generador de APNs

# Ingresa: 1 (para México)

# Copia APN: internet.itelcel.com

# Configura en ajustes móviles
```

Ejemplo 3: Generar cuenta SSH gratuita

```bash
./secman77.sh

# Selecciona: [12] Cuentas gratuitas

# Selecciona: [2] Generar cuenta SSH

# Copia comando: ssh usuario@servidor -p puerto

# Usa en Termux con la contraseña mostrada
```

Ejemplo 4: Ver vulnerabilidades detectadas

```bash
./secman77.sh

# Configura dominio: [1]

# Escaneo completo: [5]

# Análisis de servicios: [7]

# Revisa recomendaciones de seguridad
```

---

⚠️ ADVERTENCIA LEGAL

🚫 USO PROHIBIDO

· ❌ Sistemas sin autorización explícita

· ❌ Redes ajenas sin permiso

· ❌ Actividades maliciosas

· ❌ Violación de términos de servicio

✅ USO PERMITIDO

· ✅ Tus propios sistemas/servidores

· ✅ Laboratorios de práctica (HackTheBox, TryHackMe)

· ✅ Bug bounty programs autorizados

· ✅ Entornos educativos controlados

📝 RESPONSABILIDAD

El autor NO se responsabiliza por el uso indebido de esta herramienta.
El usuario es 100% responsable de sus acciones y debe cumplir con las leyes locales.

---

📁 ESTRUCTURA DEL PROYECTO

```
secman77/
├── secman77.sh              # Script principal
├── README.md                # Este archivo
├── LICENSE                  # Licencia MIT
├── CHANGELOG.md             # Historial de cambios
├── .gitignore               # Archivos ignorados
└── docs/                    # Documentación
    ├── images/              # Capturas de pantalla
    └── examples/            # Ejemplos de uso
```

Archivos Generados por el Script:

```
~/secman77_scans/            # Resultados de escaneos
~/.secman77_config           # Configuración de usuario
~/.secman77_accounts         # Base de datos de cuentas
~/account_*.txt              # Archivos de cuentas individuales
~/apns_*.txt                 # Archivos de APNs por país
```

---

🤝 CONTRIBUCIONES

¡Las contribuciones son bienvenidas! Para contribuir:

1. Fork el repositorio
2. Crea una rama para tu feature (git checkout -b feature/AmazingFeature)
3. Commit tus cambios (git commit -m 'Add some AmazingFeature')
4. Push a la rama (git push origin feature/AmazingFeature)
5. Abre un Pull Request

Reportar Bugs

Usa el sistema de Issues para:

· 🐛 Reportar bugs
· 💡 Sugerir mejoras
· ❓ Hacer preguntas

---

👤 AUTOR

HUEVOMAN77

· GitHub: @HUEVOMAN77
· Facebook: HUEVOMAN77
· Telegram: @Huevoman77
· Intereses: Seguridad informática, redes, desarrollo

Agradecimientos

· Comunidad de Termux
· Proyectos de código abierto
· Entusiastas de la seguridad ética

---

📄 LICENCIA

Este proyecto está bajo la Licencia MIT. Ver el archivo LICENSE para más detalles.

```
MIT License

Copyright (c) 2024 HUEVOMAN77

Se concede permiso, de forma gratuita, a cualquier persona que obtenga una copia
de este software y los archivos de documentación asociados (el "Software"), para tratar
en el Software sin restricción, incluidos, entre otros, los derechos
de uso, copia, modificación, fusión, publicación, distribución, sublicencia y/o venta
de copias del Software, y para permitir a las personas a las que se les proporcione el Software
hacerlo, sujeto a las siguientes condiciones:

El aviso de copyright anterior y este aviso de permiso se incluirán en todas
las copias o partes sustanciales del Software.
```

---

🌟 ESTRELLAS Y SEGUIDORES

Si este proyecto te resulta útil, por favor:

1. ⭐ Dale una estrella al repositorio
2. 🔔 Watch para recibir actualizaciones
3. 🍴 Fork para crear tu propia versión
4. 🐛 Reporta bugs para mejorar la herramienta

---

📞 CONTACTO Y SOPORTE

· Issues: GitHub Issues
· Discusión: Sección de Discussions
· Actualizaciones: Mira los Releases
· Facebook: HUEVOMAN77
· Telegram: @Huevoman77

---

<div align="center">

¡Gracias por usar SECMAN77! 🚀

Recuerda: Con grandes poderes vienen grandes responsabilidades

Úsalo sabiamente, úsalo legalmente, úsalo para aprender

</div>

---

<p align="center">
  <img src="https://img.shields.io/badge/Hecho%20con-❤️-red" alt="Hecho con amor">
  <br>
  <sub>© 2024 HUEVOMAN77 - Todos los derechos reservados</sub>
</p>