# Script PowerShell para iniciar el proyecto con Docker
# Uso: .\docker-start.ps1 [dev|prod]

param(
    [string]$Mode = "prod"
)

Write-Host "Iniciando Gestion Tripadvisor con Docker..." -ForegroundColor Cyan
Write-Host "Modo: $Mode" -ForegroundColor Yellow
Write-Host ""

# Verificar que Docker este instalado
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Docker no esta instalado. Por favor instala Docker Desktop primero." -ForegroundColor Red
    exit 1
}

# Verificar que Docker Compose este instalado
if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Docker Compose no esta instalado. Por favor instala Docker Compose primero." -ForegroundColor Red
    exit 1
}

# Verificar que Docker este corriendo
Write-Host "Verificando que Docker este corriendo..." -ForegroundColor Yellow
$dockerCheck = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker no esta corriendo." -ForegroundColor Red
    Write-Host ""
    Write-Host "Intentando iniciar Docker Desktop..." -ForegroundColor Yellow
    
    # Intentar iniciar Docker Desktop
    $dockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    if (Test-Path $dockerPath) {
        Start-Process $dockerPath
        Write-Host "Docker Desktop se esta iniciando. Espera 30-60 segundos..." -ForegroundColor Yellow
        Write-Host "Luego ejecuta este script nuevamente." -ForegroundColor Yellow
    } else {
        Write-Host "ERROR: No se encontro Docker Desktop en la ruta esperada." -ForegroundColor Red
        Write-Host "Por favor inicia Docker Desktop manualmente." -ForegroundColor Yellow
    }
    exit 1
}
Write-Host "OK: Docker esta corriendo" -ForegroundColor Green

# Seleccionar archivo docker-compose segun el modo
if ($Mode -eq "dev") {
    $ComposeFile = "docker-compose.dev.yml"
    Write-Host "Modo desarrollo (con hot reload)" -ForegroundColor Green
} else {
    $ComposeFile = "docker-compose.yml"
    Write-Host "Modo produccion" -ForegroundColor Green
}

# Construir y levantar servicios
Write-Host ""
Write-Host "Construyendo imagenes..." -ForegroundColor Cyan
docker-compose -f $ComposeFile build

Write-Host ""
Write-Host "Levantando servicios..." -ForegroundColor Cyan
docker-compose -f $ComposeFile up -d

Write-Host ""
Write-Host "Esperando a que los servicios esten listos..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Verificar estado de los servicios
Write-Host ""
Write-Host "Estado de los servicios:" -ForegroundColor Cyan
docker-compose -f $ComposeFile ps

Write-Host ""
Write-Host "OK: Servicios iniciados!" -ForegroundColor Green
Write-Host ""
Write-Host "URLs:" -ForegroundColor Cyan
Write-Host "   Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "   Backend:  http://localhost:8080" -ForegroundColor White
Write-Host "   MongoDB:  localhost:27017" -ForegroundColor White
Write-Host ""
Write-Host "Ver logs:" -ForegroundColor Cyan
$logCommand = "docker-compose -f " + $ComposeFile + " logs -f"
Write-Host "   $logCommand" -ForegroundColor Gray
Write-Host ""
Write-Host "Detener servicios:" -ForegroundColor Cyan
$stopCommand = "docker-compose -f " + $ComposeFile + " down"
Write-Host "   $stopCommand" -ForegroundColor Gray
Write-Host ""
