#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
ignore="Filesystem|iso9660"
alarmNum=60
criticalNum=80
alert=""
ip=`ifconfig etho|grep Mask|awk -F "addr:" {'print $2'}|awk -F " " '{print $1}'`
df -PTh -x nfs|while read line
do
        #echo ---$line---
        egrep -q "$ignore" <<<$line&& continue
        #匹配出use
        usage=$(awk '{print gensub("([0-9]+)%","\\1","g",$6)}'<<<$line)
		#alarm
        if (( $usage >= $criticalNum ))
	then
	   echo "ip:$ip disk free space alert! $line" 
	fi
        if (( $usage >= $alarmNum ))
        then
	   echo "${ip}_disk_free_space_alert!_${line}" 
        fi
done
