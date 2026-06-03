# Base de Datos - SISVEC

## Restaurar la base de datos

Ejecutar `restore_db.bat` (doble clic) para cargar la base de datos desde el backup.

El script:
- Lee `DATABASE_URL` del `.env`
- Detecta automaticamente la version de PostgreSQL instalada
- Crea la BD si no existe
- Restaura los datos

## Schema

`schema_seguridad_vecinal.sql` contiene solo la estructura de tablas (sin datos).

## Render

`render_bootstrap.sh` crea tablas, migra columnas y seedea datos base en Render.

## Usuarios de prueba

| Usuario | Contrasena | Rol |
|---------|-----------|-----|
| admin@ejemplo.com | admin123 | Administrador |
| junta@sisvec.com | junta123 | Junta Vecinal |
| vecino1@email.com | vecino123 | Vecino |
| vecino2@email.com | vecino123 | Vecino |
