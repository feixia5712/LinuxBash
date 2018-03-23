#!/bin/bash

################################
#
#       root@node1:~# free -m
#                                 total        used        free      shared  buff/cache   available
#       Mem:           4957        1640        2394          10         922        2836
#       Swap:          5119           0        5119
#
#  
#    memtotal=userd+free+buff/cache
#    4957=1640+2394+922
#    全部free=free+buff/cache
#    当使用的mem超过90%告警
#
#
###################################################################
memlog=/tmp/meminfo.log
memfreelog=/tmp/memfree.log
#get hostname 
hostname=${HOSTNAME%%.*}
ignoreHost=""

memtest(){

if [[ $# != 0 ]]
        then
                return
else
   memtotal=$(awk '/MemTotal/{print $2}'  /proc/meminfo)   #get mem
   USEDALARMNUM=$(echo "$memtotal/1000*0.9"|bc)
   echo -e "used memory alarm num : $USEDALARMNUM MB"   
   usedmem=$(free -m|awk '/Mem/{print $3}')
   if [[ $usedmem > $USEDALARMNUM ]]
        then
                echo -e "low free memory.Free Memory already used ${usedmem} MB" 
                echo -e "==========$(date +"%F %T")=============\n$(free -t)\n">>$memlog
        fi

fi

}
memtest

