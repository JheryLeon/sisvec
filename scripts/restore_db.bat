@echo off
setlocal
REM RESTAURAR BD - funciona con doble clic
REM
REM Si tu configuracion es distinta, edita estas 4 lineas:
set DB_HOST=localhost
set DB_PORT=5432
set DB_USER=postgres
set DB_NAME=seguridad_vecinal2
REM
REM O usa el script PowerShell (restore_db.ps1) que lee automaticamente del .env

set SCRIPT_DIR=%~dp0
set PROJECT_DIR=%SCRIPT_DIR%..
set INPUT_FILE=%PROJECT_DIR%\scripts\backup_seguridad_vecinal.sql

REM Detectar psql (auto, cualquier version)
set "PSQL="
if exist "%PROGRAMFILES%\PostgreSQL\18\bin\psql.exe" (
    set "PSQL=%PROGRAMFILES%\PostgreSQL\18\bin\psql.exe"
) else (
    for /d %%i in ("%PROGRAMFILES%\PostgreSQL\*") do (
        if exist "%%i\bin\psql.exe" set "PSQL=%%i\bin\psql.exe"
    )
)
if not defined PSQL (
    echo ERROR: psql.exe no encontrado. Instala PostgreSQL.
    pause & exit /b 1
)

if not exist "%INPUT_FILE%" (
    echo ERROR: No se encuentra %INPUT_FILE%
    pause & exit /b 1
)

echo === RESTAURAR %DB_NAME% ===
echo Host: %DB_HOST%:%DB_PORT%  Usuario: %DB_USER%
echo Archivo: %INPUT_FILE%
echo.

set /P PGPASSWORD="Password del usuario %DB_USER%: "

echo Paso 1/2: Eliminando conexiones activas...
"%PSQL%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '%DB_NAME%' AND pid <> pg_backend_pid();" 2>nul

echo Paso 2/2: Restaurando desde %INPUT_FILE%...
"%PSQL%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -f "%INPUT_FILE%"

if %ERRORLEVEL% equ 0 (
    echo.
    echo RESTAURACION EXITOSA
) else (
    echo.
    echo ERROR: Verifica que la BD %DB_NAME% exista.
)

set PGPASSWORD=
pause
