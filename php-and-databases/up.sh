#!/bin/bash

docker compose -f docker-compose-mariadb105.yml up -d
docker compose -f docker-compose-mysql57.yml up -d
docker compose -f docker-compose-mysql83.yml up -d
docker compose -f docker-compose-pma.yml up -d
# docker compose -f docker-compose-php71.yml up -d
docker compose -f docker-compose-php74.yml up -d
# docker compose -f docker-compose-php80.yml up -d
docker compose -f docker-compose-php81.yml up -d
# docker compose -f docker-compose-php82.yml up -d
docker compose -f docker-compose-php83.yml up -d