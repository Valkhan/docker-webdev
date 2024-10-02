#!/bin/bash

docker compose -f ../docker-compose-mariadb105.yml build
docker compose -f ../docker-compose-mysql57.yml build
docker compose -f ../docker-compose-mysql83.yml build
docker compose -f ../docker-compose-pma.yml build
docker compose -f ../docker-compose-php71.yml build
docker compose -f ../docker-compose-php74.yml build
docker compose -f ../docker-compose-php80.yml build
docker compose -f ../docker-compose-php81.yml build
docker compose -f ../docker-compose-php82.yml build
docker compose -f ../docker-compose-php83.yml build