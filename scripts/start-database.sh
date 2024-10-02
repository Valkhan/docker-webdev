#!/bin/bash
version=$1

./stop-database.sh

# Caminho do arquivo .env
arquivo="/dockers/.env"

# Verifica se o arquivo existe
if [ -f "$arquivo" ]; then
    # Substitui a linha que começa com DATABASE_SERVICE=
    sed -i "s/^DATABASE_SERVICE=.*/DATABASE_SERVICE=$version/g" "$arquivo"
fi
docker start vlk-${version}
docker compose -f /dockers/docker-compose-pma.yml up -d
docker ps
