#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

AWAIT_WARN=150
UTIL_WARN=100
IO_LOG=/tmp/check_io.log



hostname=${HOSTNAME%%.*}


if ! which iostat &>/dev/null; 
then 
	echo "no iostat command ,install ...."; 
	yum install -y sysstat 
	echo "no sysstat package,install fail"
fi

#过滤出
iostat -y -x 297 1 |awk -vawarn=$AWAIT_WARN -vuwarn=$UTIL_WARN '!/Device/{if($10 > awarn || $12 >= uwarn) a[$1]="await:"$10" svctm: "$11" util:"$12"%"}END{for(k in a)print k,a[k]}' >$IO_LOG

if [[ -s $IO_LOG ]]  #是否为空文件
then
	cat $IO_LOG 
fi
rm $IO_LOG

exit 0



