#!/bin/bash
version=$1

# call stop-php.sh
./stop-php.sh

docker start vlk-php${version}
docker ps
