#!/usr/bin/env bash
browser="headless-chrome"

mkdir build
mkdir build/reruns
mkdir build/reports
rm -f build/reruns/*
rm -f build/reports/*

docker build -t testhive-regression .
docker stop $(docker ps -aq -f "name=th-regression") || true && docker rm $(docker ps -aq -f "name=th-regression") || true

features_to_run="features/regression/"
index=0
rerun_volume_dir="$(pwd)/build/reruns"

for file in "$features_to_run"/*
do
  index=$(( $index + 1 ))
  docker run -d -e features_to_run=${file} -e rerun_index=${index} -e browser=${browser} \
  -v ${rerun_volume_dir}:/app/build/reruns \
  --name th-regression${index} testhive-regression
done
docker wait $(docker ps -q -f "name=th-regression")

rm build/reports/build_logs.txt

for i in $(seq 1 $index); do
    docker logs th-regression${i} >> build/reports/build_logs.txt
    docker cp th-regression${i}:/app/build/reports build
done

cat build/reruns/* > build/reruns/final_rerun.txt

docker run -d -e features_to_run=@build/reruns/final_rerun.txt -e rerun_index=rerun -e browser=${browser} \
-v ${rerun_volume_dir}:/app/build/reruns \
--name th-regression-rerun testhive-regression

run_exit_code=$(docker wait $(docker ps -q -f "name=th-regression"))

docker logs th-regression-rerun >> build/reports/build_logs.txt
docker cp th-regression-rerun:/app/build/reports build

exit $run_exit_code