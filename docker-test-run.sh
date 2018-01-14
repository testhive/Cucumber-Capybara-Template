#!/usr/bin/env bash

mkdir build
docker build -t testhive-regression .
docker stop th_regression || true && docker rm th_regression || true
docker run --name th_regression testhive-regression
run_exit_code=$?
docker cp th_regression:/app/build/reports build
exit $run_exit_code