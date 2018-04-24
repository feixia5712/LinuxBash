#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
###################
serviceStatus()
{
	local service=$1
	/etc/init.d/$service status 
	[[ $? == 0 ]] && return 0

	/etc/init.d/$service restart
	sleep 5
	/etc/init.d/$service status 
	[[ $? == 0 ]] && return 0

	/etc/init.d/$service restart
	sleep 5
	/etc/init.d/$service status 
	[[ $? == 0 ]] && return 0
	echo "can not start $service service "
}

if [[ $1 == "restart" ]]
then
	/etc/init.d/rpcbind restart
	/etc/init.d/nfs restart
	sleep 10
fi

serviceStatus rpcbind
sleep 3
serviceStatus nfs
