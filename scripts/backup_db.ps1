param(
    [string]$OutputFile = (Join-Path $PSScriptRoot "backup_seguridad_vecinal.sql")
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

# Detectar pg_dump (cualquier versión)
$PG_DUMP = Get-ChildItem "C:\Program Files\PostgreSQL\*\bin\pg_dump.exe" | Select-Object -First 1 -ExpandProperty FullName
if (-not $PG_DUMP) {
    if (Get-Command "pg_dump" -ErrorAction SilentlyContinue) { $PG_DUMP = "pg_dump" }
    else {
        Write-Host "ERROR: pg_dump.exe no encontrado. Instala PostgreSQL." -ForegroundColor Red
        exit 1
    }
}

Write-Host "=== BACKUP de la base de datos: $DB_NAME ===" -ForegroundColor Cyan
Write-Host "Host: $DB_HOST`:$DB_PORT  Usuario: $DB_USER"

if (-not $plainPassword) {
    $password = Read-Host "Password del usuario $DB_USER" -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}

$env:PGPASSWORD = $plainPassword

& $PG_DUMP -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME `
    --clean --if-exists --no-owner --no-privileges `
    -f $OutputFile

Remove-Item Env:\PGPASSWORD -ErrorAction SilentlyContinue

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nBACKUP EXITOSO: $OutputFile" -ForegroundColor Green
    $size = (Get-Item $OutputFile).Length / 1KB
    Write-Host "Tamaño: $([Math]::Round($size, 1)) KB" -ForegroundColor Green
} else {
    Write-Host "`nERROR: El backup falló" -ForegroundColor Red
}
