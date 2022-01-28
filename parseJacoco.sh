#!/bin/sh

FILE=jacoco.csv

function get_sum()
{
    file=${1}
    col=${2}
    
    target_str=`awk -F ',' -v OFS=',' -v COL="${col}" '{print $COL}' ${file}`
    target_array=(${target_str//,/ })
    target_len=${#target_array[*]}
    
    target_count=0
    for ((index=1; index<${target_len}; index++))
    do
        target_count=$((${target_count} + ${target_array[index]}))
    done
    
    return ${target_count}
}

get_sum ${FILE} 8
missed_count=$?
#echo "missed_count is ${missed_count}"

get_sum ${FILE} 9
coverd_count=$?
#echo "coverd_count is ${coverd_count}"

totald_count=$((${missed_count}+${coverd_count}))
#echo "totald_count is ${totald_count}"

coverd_percent=`awk 'BEGIN{printf "%.2f%\n",('${coverd_count}'/'${totald_count}')*100}'`
#echo "coverd_percent is ${coverd_percent}"

json_str='{"total": '${totald_count}', "covered": '${coverd_count}', "missed": '${missed_count}', "percent": "'${coverd_percent}'"}'
echo "json_str is ${json_str}"
