#!/bin/bash
# Render bootstrap: migraciones + seed de datos base
set -e

echo "[bootstrap] Iniciando..."

python << 'PYEOF'
import os, sys

# Forzar FLASK_ENV=production para que wsgi.py lo tome
os.environ.setdefault("FLASK_ENV", "production")
os.environ.setdefault("APP_URL", "https://sisvec.onrender.com")

# Importar app
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from wsgi import app

with app.app_context():
    from app import db
    from app.models import Rol, Barrio, Usuario, TipoIncidente, TipoAlerta

    # ── 1. Migraciones de columnas faltantes ──
    engine = db.engine
    inspector = db.inspect(engine)
    tables = inspector.get_table_names()

    migrations = [
        ("usuarios",       "email_verified",    "boolean DEFAULT false"),
        ("usuarios",       "verification_token", "varchar(200)"),
        ("tipo_incidente", "descripcion",        "text"),
        ("incidentes",     "resuelto",          "boolean DEFAULT false"),
        ("incidentes",     "resuelto_por",       "integer"),
        ("incidentes",     "fecha_resolucion",   "timestamptz"),
        ("alertas",        "tipo_alerta_id",     "integer"),
    ]

    for table, col, col_type in migrations:
        if table in tables and col not in [c["name"] for c in inspector.get_columns(table)]:
            sql = f'ALTER TABLE "{table}" ADD COLUMN "{col}" {col_type}'
            db.session.execute(db.text(sql))
            print(f"[bootstrap] Migracion: {table}.{col} agregada")

    db.session.commit()

    # ── 2. Seed de datos base (solo si tablas vacias) ──
    if Rol.query.count() == 0:
        roles = [
            Rol(nombre="admin", descripcion="Administrador del sistema"),
            Rol(nombre="junta", descripcion="Miembro de la junta vecinal"),
            Rol(nombre="vecino", descripcion="Residente del barrio"),
        ]
        db.session.add_all(roles)
        db.session.commit()
        print("[bootstrap] Roles creados")

    if Barrio.query.count() == 0:
        barrios = [
            Barrio(nombre="Centro", ciudad="Santa Cruz", lat_centro=-17.7833, lng_centro=-63.1825),
            Barrio(nombre="Norte",  ciudad="Santa Cruz", lat_centro=-17.7700, lng_centro=-63.1800),
            Barrio(nombre="Sur",    ciudad="Santa Cruz", lat_centro=-17.8000, lng_centro=-63.1850),
            Barrio(nombre="Este",   ciudad="Santa Cruz", lat_centro=-17.7833, lng_centro=-63.1600),
            Barrio(nombre="Oeste",  ciudad="Santa Cruz", lat_centro=-17.7833, lng_centro=-63.2000),
        ]
        db.session.add_all(barrios)
        db.session.commit()
        print("[bootstrap] Barrios creados")

    if TipoIncidente.query.count() == 0:
        tipos = [
            TipoIncidente(nombre="robo",        nivel_riesgo_default="alto",  icono="theft",     color="#dc3545"),
            TipoIncidente(nombre="violencia",   nivel_riesgo_default="alto",  icono="violence",  color="#dc3545"),
            TipoIncidente(nombre="drogas",      nivel_riesgo_default="alto",  icono="drug",      color="#6f42c1"),
            TipoIncidente(nombre="asalto",      nivel_riesgo_default="alto",  icono="assault",   color="#dc3545"),
            TipoIncidente(nombre="vandalismo",  nivel_riesgo_default="medio", icono="vandalism", color="#fd7e14"),
            TipoIncidente(nombre="sospechoso",  nivel_riesgo_default="medio", icono="suspicious",color="#ffc107"),
            TipoIncidente(nombre="ruido",       nivel_riesgo_default="bajo",  icono="noise",     color="#17a2b8"),
            TipoIncidente(nombre="alumbrado",   nivel_riesgo_default="bajo",  icono="light",     color="#28a745"),
            TipoIncidente(nombre="otro",        nivel_riesgo_default="bajo",  icono="other",     color="#6c757d"),
        ]
        db.session.add_all(tipos)
        db.session.commit()
        print("[bootstrap] Tipos de incidente creados")

    if TipoAlerta.query.count() == 0:
        alertas = [
            TipoAlerta(nombre="nuevo_incidente", descripcion="Nuevo incidente reportado", prioridad=2),
            TipoAlerta(nombre="riesgo_alto",     descripcion="Zona de alto riesgo",       prioridad=1),
        ]
        db.session.add_all(alertas)
        db.session.commit()
        print("[bootstrap] Tipos de alerta creados")

    # ── 3. Admin por defecto ──
    admin = Usuario.query.filter_by(email="admin@sisvec.com").first()
    if not admin:
        admin_pass = os.environ.get("ADMIN_PASSWORD", "admin123")
        rol_admin = Rol.query.filter_by(nombre="admin").first()
        barrio = Barrio.query.first()
        admin = Usuario(
            email="admin@sisvec.com",
            nombre="Administrador",
            rol_id=rol_admin.id if rol_admin else 1,
            barrio_id=barrio.id if barrio else None,
            activo=True,
            email_verified=True,
        )
        admin.set_password(admin_pass)
        db.session.add(admin)
        db.session.commit()
        print(f"[bootstrap] Admin creado (pass: {admin_pass})")

    # Asegurar que el admin existente tenga email_verified=True
    if admin and not admin.email_verified:
        admin.email_verified = True
        db.session.commit()
        print("[bootstrap] Admin marcado como verificado")

    print("[bootstrap] Listo.")

PYEOF

echo "[bootstrap] OK. Iniciando servidor..."
