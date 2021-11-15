#!/usr/bin/env bash
browser="chrome_headless"

mkdir results
mkdir results/reports
rm -f results/reports/*

docker build -t testhive-regression .
docker stop $(docker ps -aq -f "name=th-regression") || true && docker rm $(docker ps -aq -f "name=th-regression") || true

features_to_run="features/functional"
index=0

for file in $(find $features_to_run -type f)
do
    if [ -f "$file" ];
    then
        index=$(( $index + 1 ))
        docker run -d -e features_to_run=${file} -e report_name=${file##*/} -e browser=${browser} \
        --name th-regression${index} testhive-regression
    fi
done

result_codes=$(docker wait $(docker ps -q -f "name=th-regression"))

for i in $(seq 1 $index); do
    docker logs th-regression${i} >> results/reports/build_logs.txt
    docker cp th-regression${i}:/app/results/reports results
done

temp=$(echo $result_codes | tr -dc '[:alnum:]\n\r')
exit_codes=${temp//0/}
exit_codes+="check"

if [[ "$exit_codes" == "check" ]]; then
   exit 0
else
   exit 1
fi