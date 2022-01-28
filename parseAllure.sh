#!/bin/sh

FILE=prometheusData.txt
flag_array=(failed broken passed skipped unknown)

total=0
json_str=""
while read line;
do
    for flag in ${flag_array[@]}
    do
        if [[ ${line} == *${flag}* ]]
        then
            array=(${line// / })
            count=${array[1]}
            total=$((${total}+${count}))
            json_str=${json_str}' "'${flag}'_count": '${count}','
            eval "${flag}_count"=${count}
            break
        fi
    done
done < ${FILE}

for flag in ${flag_array[@]}
do
    var_name=$(eval echo '$'${flag}_count)
    flag_count=$(eval echo ${var_name})
    flag_percent=`awk 'BEGIN{printf "%.2f%\n",('${flag_count}'/'${total}')*100}'`
    json_str=${json_str}' "'${flag}'_percent": '${flag_percent}','
done

json_str='{'${json_str}' "total_count": '${total}' }'
echo "json_str is ${json_str}"

