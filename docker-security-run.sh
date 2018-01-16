#!/usr/bin/env bash

browser="firefox"
zap_proxy="localhost"
zap_port=8095
features_to_run="features/regression"

mkdir build
mkdir build/security
rm -f build/security/*

docker build -f Dockerfile.zap -t testhive-security .
docker stop $(docker ps -aq -f "name=th-security") || true && docker rm $(docker ps -aq -f "name=th-security") || true

docker run -e features_to_run=${features_to_run} -e rerun_index=security -e browser=${browser} \
-e security=true -e zap_proxy=${zap_proxy} -e zap_port=${zap_port} \
--name th-security testhive-security

docker cp th-security:/app/build/security build

docker stop th-security