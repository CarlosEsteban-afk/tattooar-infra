#!/bin/bash

echo "Iniciando despliegue en la VPS..."

if [ -z "$DOCKER_HUB_USERNAME" ] || [ -z "$DOCKER_HUB_PASSWORD" ]; then
    echo "Error: Las credenciales de docker no están configuradas"
    exit 1
fi

echo "Autenticando y descargando imágenes..."

echo "$DOCKER_HUB_PASSWORD" | docker login --username "$DOCKER_HUB_USERNAME" --password-stdin || {
    echo "❌ Error al autenticar en el registro"
    exit 1
}

echo "🧹 Deteniendo contenedores y limpiando..."
docker compose -f /home/tattooAR/compose.yml down --remove-orphans || true
docker image prune -af

echo "🚀 Levantando contenedores..."
docker compose -f /home/tattooAR/compose.yml up -d || {
    echo "❌ Error al iniciar contenedores"
    docker ps -a | grep tattooAR
    exit 1
}

echo "🧹 Limpiando archivos de entorno..."
rm -rf /home/tattooAR/env_*

echo "✅ Despliegue completado!"
