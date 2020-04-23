#!/bin/bash

#日志切割
#Rotate the nginx logs to prevent a single logfile from consuming too much disk space.
LOGS_PATH=/usr/local/nginx/logs/history
CUR_LOGS_PATH=/usr/local/nginx/logs
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
mv ${CUR_LOGS_PATH}/access.log ${LOGS_PATH}/access_${YESTERDAY}.log
mv ${CUR_LOGS_PATH}/error.log ${LOGS_PATH}/error_${YESTERDAY}.log
#向nginx master进程发送USR1信号，USR1信号是重新打开日志文件，相当于-s reopen命令
kill -USR1 $(cat /usr/local/nginx/logs/nginx.pid)
