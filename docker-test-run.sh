#!/usr/bin/env bash

docker build  -t longlost/cukes-template .
docker run longlost/cukes-template
docker cp `docker ps -l -q`:/app/docker-html-report.html docker-html-report.html