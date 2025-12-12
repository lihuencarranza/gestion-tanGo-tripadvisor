#!/bin/bash

# Script para iniciar el proyecto con Docker
# Uso: ./docker-start.sh [dev|prod]

set -e

MODE=${1:-prod}

echo "🐳 Iniciando Gestión Tripadvisor con Docker..."
echo "Modo: $MODE"
echo ""

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Por favor instala Docker primero."
    exit 1
fi

# Verificar que Docker Compose esté instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado. Por favor instala Docker Compose primero."
    exit 1
fi

# Verificar que Docker esté corriendo
if ! docker info &> /dev/null; then
    echo "❌ Docker no está corriendo. Por favor inicia Docker Desktop."
    exit 1
fi

# Seleccionar archivo docker-compose según el modo
if [ "$MODE" = "dev" ]; then
    COMPOSE_FILE="docker-compose.dev.yml"
    echo "📦 Modo desarrollo (con hot reload)"
else
    COMPOSE_FILE="docker-compose.yml"
    echo "📦 Modo producción"
fi

# Construir y levantar servicios
echo ""
echo "🔨 Construyendo imágenes..."
docker-compose -f $COMPOSE_FILE build

echo ""
echo "🚀 Levantando servicios..."
docker-compose -f $COMPOSE_FILE up -d

echo ""
echo "⏳ Esperando a que los servicios estén listos..."
sleep 5

# Verificar estado de los servicios
echo ""
echo "📊 Estado de los servicios:"
docker-compose -f $COMPOSE_FILE ps

echo ""
echo "✅ Servicios iniciados!"
echo ""
echo "📍 URLs:"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:8080"
echo "   MongoDB:  localhost:27017"
echo ""
echo "📝 Ver logs:"
echo "   docker-compose -f $COMPOSE_FILE logs -f"
echo ""
echo "🛑 Detener servicios:"
echo "   docker-compose -f $COMPOSE_FILE down"
echo ""

