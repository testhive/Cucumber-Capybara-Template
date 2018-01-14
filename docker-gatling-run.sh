#!/usr/bin/env bash

docker build -f Dockerfile.gatling -t testhive-performance .
docker stop $(docker ps -aq -f "name=th-gatling") || true && docker rm $(docker ps -aq -f "name=th-gatling") || true

docker run --name th-gatling testhive-performance

docker stop th-gatling