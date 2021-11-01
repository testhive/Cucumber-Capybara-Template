#!/usr/bin/env bash
browser="headless-chrome"

mkdir -p build/reports/junit/rerun
if cucumber features/regression BROWSER=${browser} -t 'not @wip' -f pretty -f html -o build/reports/report.html -f junit -o build/reports/junit -f rerun  -o rerun.txt  security=true; then
    echo "Command succeeded"
else
    cucumber @rerun.txt BROWSER=${browser} -f html -o build/reports/rerun_report.html -f pretty -f junit -o build/reports/junit  security=true
fi