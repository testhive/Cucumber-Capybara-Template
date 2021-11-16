#!/usr/bin/env bash

cucumber ${features_to_run} BROWSER=${browser} -t 'not @wip' -f pretty -f html -o results/reports/${report_name}.html -f junit -o results/reports/junit
