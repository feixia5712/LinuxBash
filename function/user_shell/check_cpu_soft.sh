#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
WARN=60
CRITICAL=80
INTERVAL=50

if ! which mpstat &>/dev/null; 
then
	nohup apt-get -y sysstat &>/dev/null &
	exit
fi

TMPLOG=/tmp/cpu_si.$$
mpstat  -P ALL  $INTERVAL 1 |awk -vwarn=$WARN '/Average/{if($2 == "all" )next;if ($8>warn) print "cpu"$2" soft interrupt: "$8"%"}' >$TMPLOG

if [[ ! -s $TMPLOG ]]
then
	rm $TMPLOG
	exit
fi

result=$(awk -vcritical=$CRITICAL '{if ($NF > critical) print "critical" }' $TMPLOG)
if [[ "$result" == "" ]]
then
	cat $TMPLOG 
else
	cat $TMPLOG 
fi
rm $TMPLOG


