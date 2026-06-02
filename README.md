# SISVEC - Sistema de Seguridad Predictiva Vecinal

Plataforma web colaborativa donde vecinos, juntas vecinales y autoridades pueden reportar incidentes, visualizar riesgos en un mapa interactivo y anticipar delitos mediante analisis de datos con inteligencia artificial.

## Requisitos

- **Python 3.11+**
- **PostgreSQL 16+**

## Instalacion (local)

```powershell
cd sistema_seguridad2
pip install -r requirements.txt
```

**Crear base de datos** (si no existe):
```powershell
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -c "CREATE DATABASE seguridad_vecinal;"
```

**Opción A — Restaurar backup completo** (recomendado, trae datos de ejemplo):
```powershell
.\scripts\restore_db.ps1 -InputFile scripts\backup_seguridad_vecinal.sql
```

**Opción B — Schema limpio + datos de ejemplo** (BD vacía, luego correr seed):
```powershell
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d seguridad_vecinal -f scripts\schema_seguridad_vecinal.sql
python seed_data.py
```

**Ejecutar** (local):
```powershell
python run.py
# http://localhost:5000
```

> Ajustar `DATABASE_URL` en `.env` si tu usuario, password, puerto o host son distintos.
> Los scripts PowerShell (`backup_db.ps1`, `restore_db.ps1`) leen automáticamente los datos desde `.env`. El `.bat` tiene las variables al inicio del archivo para editar manualmente.

---

## Deploy en Render.com

[Render](https://render.com) hosting gratuito con PostgreSQL incluido.

### 1. Preparar el repo

Subir el proyecto a GitHub:
```powershell
git init
git add .
git commit -m "Inicial"
```

### 2. Crear PostgreSQL en Render

Desde el dashboard de Render:
- **New +** → PostgreSQL
- Name: `sisvec-db`
- Tier: **Free** ($0/mes)
- Anotar la **Internal Database URL** que te da Render

### 3. Crear Web Service en Render

- **New +** → Web Service
- Conectar repo de GitHub
- **Name:** `sisvec`
- **Runtime:** Python 3
- **Build Command:** `pip install -r requirements.txt`
- **Start Command:** `bash scripts/render_bootstrap.sh && gunicorn wsgi:app`
- **Tier:** **Free** (duerme a los 15 min de inactividad)

### 4. Variables de entorno en Render

| Variable | Valor |
|----------|-------|
| `DATABASE_URL` | Pegar la Internal Database URL del paso 2 |
| `FLASK_ENV` | `production` |
| `SECRET_KEY` | Una clave aleatoria segura |
| `APP_URL` | `https://seguridadvecinal.onrender.com` |
| `MAIL_SERVER` | `smtp.gmail.com` |
| `MAIL_USERNAME` | Tu correo Gmail |
| `MAIL_PASSWORD` | Contraseña de aplicación de Gmail |
| `MAIL_FROM` | Tu correo Gmail |
| `ADMIN_PASSWORD` | Contraseña para admin del sistema (default: admin123) |

### 5. Deploy

Render hace deploy automático al pushear a GitHub.
Usuario admin por defecto: `admin@sisvec.com` (pass: la de `ADMIN_PASSWORD`).

## Usuarios de prueba (seed_data.py)

| Usuario | Contrasena | Rol |
|---------|-----------|-----|
| admin@sisvec.com | admin123 | Administrador |
| junta@sisvec.com | junta123 | Junta Vecinal |
| vecino1@email.com | vecino123 | Vecino |
| vecino2@email.com | vecino123 | Vecino |

## Estructura del proyecto

```
sistema_seguridad2/
├── app/
│   ├── api/              # Endpoints REST (auth, incidentes, mapa, alertas, predicciones, usuarios)
│   ├── templates/        # Vistas HTML con Bootstrap 5 + Leaflet + Chart.js
│   ├── utils/            # Utilidades (seguridad, alertas, modelo ML)
│   ├── __init__.py       # Fabrica de la aplicacion Flask
│   ├── forms.py          # Formularios WTForms
│   ├── models.py         # 14 modelos SQLAlchemy: Usuario, Incidente, Prediccion, Alerta, etc.
│   └── routes.py         # Rutas principales (dashboard, reportes)
├── scripts/              # Backup y restauracion de BD
├── config.py             # Configuracion por entorno
├── run.py                # Punto de entrada (local)
├── wsgi.py               # Punto de entrada (produccion / gunicorn)
├── requirements.txt      # Dependencias Python
├── seed_data.py          # Datos de ejemplo (56 incidentes, 4 usuarios)
├── scripts/
│   ├── render_bootstrap.sh   # Migraciones + seed para Render
│   └── ...
└── README.md
```

## Funcionalidades

| Modulo | Descripcion |
|--------|-------------|
| **Dashboard** | Metricas en tiempo real: total incidentes, nivel de riesgo, zonas criticas, graficos de tendencia y tipos |
| **Mapa Predictivo** | 3 vistas: marcadores de incidentes, heatmap de zonas calientes, cuadricula de predicciones IA |
| **Reporte** | Formulario rapido con seleccion en mapa, GPS, subida de fotos como evidencia |
| **Alertas** | Automaticas por todos los incidentes segun nivel de riesgo (alto, medio, bajo) |
| **IA Predictiva** | Random Forest que analiza patrones historicos y predice zonas de riesgo por barrio |
| **Roles** | Vecino (reporta), Junta Vecinal (verifica incidentes + gestiona alertas), Admin (gestiona usuarios + entrena IA) |
| **Exportacion** | Descarga de datos en Excel (.xlsx), PDF y CSV con filtros por fecha, tipo y riesgo |
| **Perfil** | Edicion de datos personales, foto de perfil, historial de actividad |
| **Evidencias** | Subida de fotos como verificacion (sistema de confianza comunitaria) |

## Solucion de problemas

**Error: psycopg2.OperationalError**
- PostgreSQL no esta corriendo o la conexion es incorrecta. Verifica que el servicio de PostgreSQL este iniciado y que `.env` tenga la URI correcta con tu usuario y contrasena.

**Error: Could not build url for endpoint**
- El servidor se inicio antes de una actualizacion de codigo. Reinicia el servidor (`taskkill /f /im python.exe` + `python run.py`).

**El heatmap no se ve en el mapa**
- Asegurate de tener conexion a internet (las librerias Leaflet se cargan desde CDN).

**Limite de sesiones alcanzado**
- Si ya iniciaste sesion en 2 dispositivos, el sistema cierra automaticamente la sesion mas antigua cuando inicias en uno nuevo.
