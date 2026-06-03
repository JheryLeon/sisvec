@echo off
setlocal enabledelayedexpansion
REM RESTAURAR BD - funciona con doble clic
REM
REM Intenta leer DATABASE_URL del .env primero.
REM Si no encuentra, usa los valores por defecto de abajo.
REM
REM set DB_HOST=localhost
REM set DB_PORT=5432
REM set DB_USER=postgres
REM set DB_NAME=seguridad_vecinal2

set SCRIPT_DIR=%~dp0
set PROJECT_DIR=%SCRIPT_DIR%..
set ENV_FILE=%PROJECT_DIR%\.env
set INPUT_FILE=%PROJECT_DIR%\scripts\backup_seguridad_vecinal.sql

REM ---- Leer DATABASE_URL del .env (si existe) ----
set "FOUND_DB_URL="
if exist "%ENV_FILE%" (
    for /f "tokens=1,* delims==" %%a in ('type "%ENV_FILE%" ^| findstr /b "DATABASE_URL"') do (
        set "FOUND_DB_URL=%%b"
    )
)
if defined FOUND_DB_URL (
    REM postgresql://user:pass@host:port/dbname
    REM Tokens: 1=postgresql, 2=user, 3=pass, 4=host, 5=port, 6=dbname
    for /f "tokens=1-6 delims=:/@ " %%a in ("!FOUND_DB_URL!") do (
        set DB_USER=%%b
        set DB_PASS=%%c
        set DB_HOST=%%d
        set DB_PORT=%%e
        set DB_NAME=%%f
    )
) else (
    REM Valores por defecto (editar aqui si no usas .env)
    if not defined DB_HOST set DB_HOST=localhost
    if not defined DB_PORT set DB_PORT=5432
    if not defined DB_USER set DB_USER=postgres
    if not defined DB_NAME set DB_NAME=seguridad_vecinal2
)
REM Limpiar comillas que puedan venir del .env
set DB_USER=!DB_USER:"=!
set DB_PASS=!DB_PASS:"=!
set DB_NAME=!DB_NAME:"=!

REM ---- Detectar psql (auto, cualquier version) ----
set "PSQL="
for /d %%i in ("%PROGRAMFILES%\PostgreSQL\*") do (
    if exist "%%i\bin\psql.exe" set "PSQL=%%i\bin\psql.exe"
)
if not defined PSQL (
    if exist "%PROGRAMFILES%\PostgreSQL\18\bin\psql.exe" set "PSQL=%PROGRAMFILES%\PostgreSQL\18\bin\psql.exe"
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

if not defined DB_PASS (
    set /P DB_PASS="Password del usuario %DB_USER%: "
)

set "PGPASSWORD=%DB_PASS%"

echo Paso 0/3: Creando BD si no existe...
"%PSQL%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d postgres -c "CREATE DATABASE %DB_NAME%;" 2>nul

echo Paso 1/3: Eliminando conexiones activas...
"%PSQL%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '%DB_NAME%' AND pid <> pg_backend_pid();" 2>nul

echo Paso 2/3: Restaurando desde %INPUT_FILE%...
"%PSQL%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -f "%INPUT_FILE%"

set PGPASSWORD=

if %ERRORLEVEL% equ 0 (
    echo.
    echo RESTAURACION EXITOSA
) else (
    echo.
    echo ERROR: Verifica que la BD %DB_NAME% exista.
)

pause
