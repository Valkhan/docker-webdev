#!/bin/bash
docker stop -t 0 $(docker ps -f name=mariadb -f name=mysql -q)
docker ps