# Migrar proyecto a otra máquina (Windows)

## Archivos necesarios

Copia toda la carpeta del proyecto a la otra máquina.

## Manual (PostgreSQL instalado)

1. Instalar PostgreSQL 18+ en la máquina destino
2. Crear la base de datos:
   ```powershell
   & "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -c "CREATE DATABASE seguridad_vecinal;"
   ```
3. Restaurar backup completo o schema limpio:

   **Opción A — Backup completo** (trae datos de ejemplo):
   ```powershell
   .\scripts\restore_db.ps1 -InputFile scripts\backup_seguridad_vecinal.sql
   ```

   **Opción B — Schema limpio + seed** (BD vacía):
   ```powershell
   & "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d seguridad_vecinal -f scripts\schema_seguridad_vecinal.sql
   pip install -r requirements.txt
   python seed_data.py
   ```

4. Configurar `.env` con usuario/password correctos
5. Instalar dependencias:
   ```powershell
   pip install -r requirements.txt
   ```
6. Ejecutar:
   ```powershell
   python run.py
   ```

## Respaldo en la máquina actual

Para generar un backup nuevo en el futuro:
```powershell
.\scripts\backup_db.ps1 -OutputFile scripts\backup_seguridad_vecinal.sql
```

## Scripts incluidos

| Script | Descripción |
|--------|-------------|
| `backup_db.ps1` | Hace backup de la BD (PowerShell) |
| `restore_db.ps1` | Restaura un backup en otra máquina (PowerShell) |
| `restore_db.bat` | Versión para CMD (solo doble clic) |
| `backup_seguridad_vecinal.sql` | Backup completo con datos (generado el 31/05/2026) |
| `schema_seguridad_vecinal.sql` | Solo esquema de la BD (sin datos) |
| `MIGRAR_A_OTRA_MAQUINA.md` | Este archivo - guía de migración |
