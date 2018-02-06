#!/bin/bash
if [ "$UID" -ne 0 ];then
echo "Must be root to run this script."
exit 1
fi
