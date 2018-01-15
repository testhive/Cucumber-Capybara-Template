#!/usr/bin/env bash

mkdir -p build/reports/junit/rerun
mkdir -p build/reruns

cucumber ${features_to_run} BROWSER=${browser} -t 'not @wip' -f pretty \
-f html -o build/reports/report-${rerun_index}.html -f junit -o build/reports/junit \
-f rerun  -o build/reruns/rerun-${rerun_index}.txt
