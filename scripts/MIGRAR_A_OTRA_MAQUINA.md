# Migrar proyecto a otra maquina (Windows)

## Archivos necesarios

Copia toda la carpeta del proyecto a la maquina destino.

## Paso a paso

### 1. Instalar PostgreSQL

Descargar e instalar PostgreSQL 18+ desde https://www.postgresql.org/download/windows/
Anota el password que elegis durante la instalacion.

### 2. Crear la base de datos

```powershell
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -c "CREATE DATABASE seguridad_vecinal2;"
```
(te va a pedir el password que pusiste al instalar PostgreSQL)

Si tenes otra version de PostgreSQL, ajusta el `18` en la ruta.

### 3. Configurar `.env`

Edita el archivo `.env` en la raiz del proyecto y cambia `DATABASE_URL` con tu password:

```
DATABASE_URL=postgresql://postgres:TU_PASSWORD@localhost:5432/seguridad_vecinal2
```

### 4. Restaurar la base de datos

**Opcion A — Script .bat (doble clic):**
- Hacer doble clic en `scripts\restore_db.bat`
- Editar las 4 variables al inicio del archivo si usas datos distintos

**Opcion B — Script PowerShell (lee .env automaticamente):**
```powershell
.\scripts\restore_db.ps1
```

**Opcion C — Manual:**
```powershell
& "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d seguridad_vecinal2 -f scripts\backup_seguridad_vecinal.sql
```

### 5. Instalar dependencias Python

```powershell
pip install -r requirements.txt
```

### 6. Ejecutar

```powershell
python run.py
```

Abrir http://localhost:5000

## Usuarios de prueba

| Usuario | Contrasena | Rol |
|---------|-----------|-----|
| admin@sisvec.com | admin123 | Administrador |
| junta@sisvec.com | junta123 | Junta Vecinal |
| vecino1@email.com | vecino123 | Vecino |
| vecino2@email.com | vecino123 | Vecino |

## Notas importantes

- La base de datos se llama `seguridad_vecinal2` (NO `seguridad_vecinal`)
- Los scripts `backup_db.ps1` y `restore_db.ps1` leen la configuracion desde `.env`
- El script `restore_db.bat` tiene las variables editables al inicio
- Los scripts detectan automaticamente cualquier version de PostgreSQL instalada
- Para que funcione el envio de emails local, genera una Contrasena de Aplicacion en Gmail (requiere verificacion en 2 pasos activada) y ponela en `MAIL_PASSWORD` del `.env`

## Respaldo en la maquina actual

Antes de migrar, genera un backup actualizado:

```powershell
.\scripts\backup_db.ps1
```

Esto sobreescribe `scripts\backup_seguridad_vecinal.sql` con los datos actuales.

## Scripts incluidos

| Script | Descripcion |
|--------|-------------|
| `backup_db.ps1` | Hace backup de la BD (PowerShell, lee .env) |
| `restore_db.ps1` | Restaura un backup (PowerShell, lee .env) |
| `restore_db.bat` | Version para CMD (solo doble clic) |
| `backup_seguridad_vecinal.sql` | Backup completo con datos (generado el 03/06/2026) |
| `schema_seguridad_vecinal.sql` | Solo esquema de la BD (sin datos) |
