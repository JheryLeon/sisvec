param(
    [string]$InputFile = (Join-Path $PSScriptRoot "backup_seguridad_vecinal.sql")
)

# Leer DATABASE_URL del .env
$envFile = Join-Path (Split-Path $PSScriptRoot -Parent) ".env"
$dbUrl = "postgresql://postgres:1234@localhost:5432/seguridad_vecinal"
if (Test-Path $envFile) {
    $line = (Get-Content $envFile | Where-Object { $_ -match "^DATABASE_URL=" } | Select-Object -First 1)
    if ($line) { $dbUrl = $line -replace "^DATABASE_URL=", "" -replace '["'']', "" }
}

# Parsear URL: postgresql://user:pass@host:port/dbname
$regex = "^postgresql://(.+?):(.+?)@(.+?):(\d+)/(.+)$"
$m = [regex]::Match($dbUrl, $regex)
if ($m.Success) {
    $DB_USER = $m.Groups[1].Value
    $plainPassword = $m.Groups[2].Value
    $DB_HOST = $m.Groups[3].Value
    $DB_PORT = $m.Groups[4].Value
    $DB_NAME = $m.Groups[5].Value
} else {
    $DB_HOST = "localhost"
    $DB_PORT = "5432"
    $DB_USER = "postgres"
    $DB_NAME = "seguridad_vecinal"
    $plainPassword = ""
}

# Detectar psql (cualquier versión)
$PSQL = Get-ChildItem "C:\Program Files\PostgreSQL\*\bin\psql.exe" | Select-Object -First 1 -ExpandProperty FullName
if (-not $PSQL) {
    if (Get-Command "psql" -ErrorAction SilentlyContinue) { $PSQL = "psql" }
    else {
        Write-Host "ERROR: psql.exe no encontrado. Instala PostgreSQL." -ForegroundColor Red
        exit 1
    }
}

Write-Host "=== RESTAURAR base de datos: $DB_NAME ===" -ForegroundColor Cyan
Write-Host "Host: $DB_HOST`:$DB_PORT  Usuario: $DB_USER"
Write-Host "Archivo: $InputFile" -ForegroundColor Yellow

if (-not (Test-Path $InputFile)) {
    Write-Host "ERROR: No se encuentra el archivo $InputFile" -ForegroundColor Red
    exit 1
}

if (-not $plainPassword) {
    $securePass = Read-Host "Password del usuario $DB_USER" -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass)
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}

$env:PGPASSWORD = $plainPassword

Write-Host "`nPaso 1/2: Eliminar conexiones activas a la BD..." -ForegroundColor Cyan
& $PSQL -h $DB_HOST -p $DB_PORT -U $DB_USER -d "postgres" -c "
    SELECT pg_terminate_backend(pg_stat_activity.pid)
    FROM pg_stat_activity
    WHERE pg_stat_activity.datname = '$DB_NAME' AND pid <> pg_backend_pid();
"

Write-Host "Paso 2/2: Restaurando desde $InputFile ..." -ForegroundColor Cyan
& $PSQL -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $InputFile

Remove-Item Env:\PGPASSWORD -ErrorAction SilentlyContinue

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nRESTAURACION EXITOSA" -ForegroundColor Green
} else {
    Write-Host "`nERROR: La restauración falló" -ForegroundColor Red
}
