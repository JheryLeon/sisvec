# SISVEC - Sistema de Seguridad Predictiva Vecinal

Plataforma web colaborativa donde vecinos, juntas vecinales y autoridades pueden reportar incidentes, visualizar riesgos en un mapa interactivo y anticipar delitos mediante analisis de datos con inteligencia artificial.

## Requisitos

- **Python 3.11+**
- **PostgreSQL 16+**
- **Git** (para deploy en Render)

## Instalacion (local - Windows)

### 1. Clonar/descargar el proyecto
```powershell
cd sistema_seguridad2
```

### 2. Crear base de datos
```powershell
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -c "CREATE DATABASE seguridad_vecinal2;"
```
Ajusta la ruta si tenes otra version de PostgreSQL (17, 16, etc.).

### 3. Configurar `.env`
Copia y edita el archivo `.env` en la raiz del proyecto:
```ini
FLASK_APP=wsgi.py
FLASK_ENV=development
SECRET_KEY=clave-segura-cambiar-en-produccion-12345
DATABASE_URL=postgresql://postgres:1234@localhost:5432/seguridad_vecinal2
# ^ Cambiar '1234' por tu password de PostgreSQL

# Email (solo para entorno local, en Render se usa SendGrid)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=tu-email@gmail.com
MAIL_PASSWORD=tu-contrasena-de-aplicacion
MAIL_FROM=tu-email@gmail.com

APP_URL=http://localhost:5000
```

### 4. Restaurar base de datos

**Opcion A — Backup completo (recomendado, trae datos de ejemplo):**
```powershell
.\scripts\restore_db.ps1
```

**Opcion B — Schema limpio + seed (BD vacia):**
```powershell
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d seguridad_vecinal2 -f scripts\schema_seguridad_vecinal.sql
pip install -r requirements.txt
python seed_data.py
```

### 5. Instalar dependencias
```powershell
pip install -r requirements.txt
```

### 6. Ejecutar
```powershell
python run.py
# Abrir http://localhost:5000
```

---

## Migrar proyecto a otra maquina Windows

1. Copiar toda la carpeta del proyecto a la maquina destino
2. Instalar PostgreSQL 18+ en la maquina destino (con password que recuerdes)
3. Crear la BD:
   ```powershell
   & "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -c "CREATE DATABASE seguridad_vecinal2;"
   ```
4. Editar `.env` con tu usuario/password de PostgreSQL
5. Restaurar backup:
   ```powershell
   .\scripts\restore_db.bat
   ```
   O si preferis PowerShell:
   ```powershell
   .\scripts\restore_db.ps1
   ```
6. Instalar dependencias:
   ```powershell
   pip install -r requirements.txt
   ```
7. Ejecutar:
   ```powershell
   python run.py
   ```

**Nota:** El `.bat` tiene las variables editables al inicio. El `.ps1` lee automaticamente la configuracion desde `.env`. Ambos detectan automaticamente la version de PostgreSQL instalada.

---

## Deploy en Render.com

Render es un hosting gratuito que incluye PostgreSQL. El plan gratis suspende el servicio tras 15 minutos de inactividad.

### Requisitos previos

- Repositorio en GitHub (rama `master`)
- Cuenta en [render.com](https://render.com) (conectar con GitHub)

### 1. Crear PostgreSQL en Render

- Dashboard de Render > **New +** > **PostgreSQL**
- **Name:** `sisvec-db` (o el que quieras)
- **Database:** `sisvec_db`
- **User:** `sisvec_db_user`
- **Tier:** **Free** ($0/mes)
- Una vez creado, copiar la **Internal Database URL** (seccion **Connections**)

### 2. Crear Web Service en Render

- **New +** > **Web Service**
- Conectar tu repositorio de GitHub
- **Name:** `sisvec`
- **Region:** La misma que la base de datos
- **Branch:** `master`
- **Runtime:** Python 3
- **Build Command:**
  ```
  pip install -r requirements.txt
  ```
- **Start Command:**
  ```
  bash scripts/render_bootstrap.sh && gunicorn wsgi:app
  ```
- **Tier:** **Free**

### 3. Variables de entorno en Render

| Variable | Valor |
|----------|-------|
| `DATABASE_URL` | Internal Database URL de tu PostgreSQL en Render |
| `FLASK_APP` | `wsgi.py` |
| `FLASK_ENV` | `production` |
| `SECRET_KEY` | Una clave aleatoria segura (ej: `python -c "import secrets; print(secrets.token_hex(24))"`) |
| `APP_URL` | `https://tu-app.onrender.com` (o tu dominio personalizado) |
| `ADMIN_PASSWORD` | Password para el admin del sistema (default en codigo: admin123) |
| `FLASK_DEBUG` | `0` |

**Email (usar SendGrid, porque Render free bloquea SMTP):**

| Variable | Valor |
|----------|-------|
| `SENDGRID_API_KEY` | Tu API Key de SendGrid (empieza con `SG.`) |
| `MAIL_FROM` | `tucorreo@gmail.com` (o el correo que verificaste en SendGrid) |

Las variables viejas de SMTP (`MAIL_PASSWORD`, `MAIL_USERNAME`, `MAIL_SERVER`, `MAIL_PORT`) ya no son necesarias si usas SendGrid.

### 4. Configurar SendGrid (para envio de emails)

1. Crear cuenta gratuita en [sendgrid.com](https://signup.sendgrid.com)
2. Verificar el email de registro
3. En Settings > API Keys > Create API Key (nombre: `sisvec`, permisos: Full Access)
4. Copiar la API Key (empieza con `SG.`)
5. En Settings > Sender Authentication > Single Sender Verification > Create New Sender:
   - From Name: `SISVEC`
   - From Email: el mismo que usas en `MAIL_FROM`
   - Verificar el link que llega al correo
6. Agregar `SENDGRID_API_KEY` en Render Dashboard > Environment
7. Hacer **Save, rebuild and deploy**

### 5. Verificar deploy

- Esperar a que Render termine el build (2-3 min, ver logs)
- Entrar a `https://tu-app.onrender.com`
- Login como admin: `admin@ejemplo.com` / password que pusiste en `ADMIN_PASSWORD`
- Probar email: `https://tu-app.onrender.com/auth/test-email`

---

## Usuarios de prueba (seed)

| Usuario | Contrasena | Rol |
|---------|-----------|-----|
| admin@ejemplo.com | admin123 | Administrador |
| junta@sisvec.com | junta123 | Junta Vecinal |
| vecino1@email.com | vecino123 | Vecino |
| vecino2@email.com | vecino123 | Vecino |

---

## Estructura del proyecto

```
sistema_seguridad2/
├── app/
│   ├── api/                  # Endpoints REST (auth, incidentes, mapa, alertas, predicciones, usuarios)
│   ├── templates/            # Vistas HTML con Bootstrap 5 + Leaflet + Chart.js
│   ├── utils/                # Utilidades
│   │   ├── tokens.py         # Generacion/verificacion de tokens (itsdangerous)
│   │   ├── email_sender.py   # Envio de emails (SMTP local, SendGrid en Render)
│   │   ├── sendgrid_sender.py# Cliente API SendGrid via HTTP
│   │   ├── alerts.py         # Logica de alertas automaticas
│   │   ├── ml_model.py       # Modelo predictivo Random Forest
│   │   └── security.py       # Decoradores de permisos
│   ├── __init__.py           # Fabrica de la aplicacion Flask
│   ├── forms.py              # Formularios WTForms (login, registro, olvido/reset password)
│   ├── models.py             # 14 modelos SQLAlchemy
│   └── routes.py             # Rutas principales (dashboard, reportes, perfil)
├── scripts/
│   ├── backup_db.ps1         # Backup de BD (PowerShell, lee .env)
│   ├── restore_db.ps1        # Restaurar BD (PowerShell, lee .env)
│   ├── restore_db.bat        # Restaurar BD (CMD, doble clic)
│   ├── render_bootstrap.sh   # Migraciones + seed para Render
│   ├── MIGRAR_A_OTRA_MAQUINA.md  # Guia de migracion offline
│   ├── backup_seguridad_vecinal.sql  # Backup completo con datos
│   └── schema_seguridad_vecinal.sql   # Solo esquema
├── config.py                 # Configuracion por entorno
├── wsgi.py                   # Entry point produccion (gunicorn)
├── run.py                    # Entry point local
├── requirements.txt          # Dependencias Python
├── seed_data.py              # Datos de ejemplo
└── README.md
```

---

## Funcionalidades

| Modulo | Descripcion |
|--------|-------------|
| **Dashboard** | Metricas en tiempo real: total incidentes, nivel de riesgo, zonas criticas, graficos de tendencia y tipos |
| **Mapa Predictivo** | 3 vistas: marcadores de incidentes, heatmap de zonas calientes, cuadricula de predicciones IA |
| **Reporte** | Formulario rapido con seleccion en mapa, GPS, subida de fotos como evidencia |
| **Alertas** | Automaticas por todos los incidentes (sin filtrar por barrio), segun prioridad del tipo de alerta |
| **IA Predictiva** | Random Forest que analiza patrones historicos (90 dias) y predice zonas de riesgo por barrio |
| **Roles** | Vecino (reporta), Junta Vecinal (verifica incidentes + gestiona), Admin (gestiona usuarios + entrena IA) |
| **Verificacion de email** | Obligatoria al registrarse; reenvio de link; recuperacion de contrasena |
| **Incidente resuelto** | Marcar/desmarcar incidentes como resueltos (reportante, junta, admin); filtros activos/resueltos/todos |
| **Filtro temporal en mapa** | Hoy (24h), 7 dias, 15 dias, 30 dias, 3 meses, 1 año, Todos |
| **Exportacion** | Descarga de datos en Excel (.xlsx), PDF y CSV con filtros por fecha, tipo y riesgo |
| **Perfil** | Edicion de datos personales, foto de perfil, historial de actividad |
| **Evidencias** | Subida de fotos como verificacion (sistema de confianza comunitaria) |
| **Sesiones** | Maximo 2 sesiones simultaneas; la mas antigua se elimina al iniciar nueva |

---

## Solucion de problemas

**Error: psycopg2.OperationalError**
- PostgreSQL no esta corriendo o la conexion es incorrecta. Verifica que el servicio de PostgreSQL este iniciado y que `.env` tenga la URI correcta con tu usuario y contrasena.

**Error: Could not build url for endpoint**
- El servidor se inicio antes de una actualizacion de codigo. Reinicia el servidor (`taskkill /f /im python.exe` + `python run.py`).

**Error 502 Bad Gateway (en Render)**
- El worker de gunicorn se colgo. Revisa los logs en Render Dashboard. Comunmente ocurre si SMTP no responde (solucion: usar SendGrid).

**Error: [Errno 101] Network is unreachable (en Render)**
- Render free tier bloquea conexiones SMTP salientes (puertos 587 y 465). Usar SendGrid como proveedor de email via HTTPS.

**No llegan los emails de verificacion**
- Local: verifica que `MAIL_*` en `.env` esten correctos y que uses una Contrasena de Aplicacion de Gmail (no la contrasena normal).
- Render: verifica que `SENDGRID_API_KEY` este configurada y el remitente verificado en SendGrid.

**El heatmap no se ve en el mapa**
- Asegurate de tener conexion a internet (las librerias Leaflet se cargan desde CDN).

**Limite de sesiones alcanzado**
- Si ya iniciaste sesion en 2 dispositivos, el sistema cierra automaticamente la sesion mas antigua cuando inicias en uno nuevo.

---

## Scripts de base de datos

| Script | Descripcion |
|--------|-------------|
| `scripts/backup_db.ps1` | Hace backup de la BD (lee config desde `.env`) |
| `scripts/restore_db.ps1` | Restaura backup en otra maquina (lee config desde `.env`) |
| `scripts/restore_db.bat` | Version para CMD (doble clic, variables editables al inicio) |
| `scripts/backup_seguridad_vecinal.sql` | Backup completo generado el 03/06/2026 (~167 KB) |
| `scripts/schema_seguridad_vecinal.sql` | Solo esquema de la BD (sin datos) |

### Generar backup actualizado
```powershell
.\scripts\backup_db.ps1
```
