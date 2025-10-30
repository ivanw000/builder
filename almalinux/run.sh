#!/bin/bash
#export DOCKER_MYUID=`id -u`
#export DOCKER_MYGID=`id -g`
docker compose up -d
docker attach ivanw-builder-almalinux


