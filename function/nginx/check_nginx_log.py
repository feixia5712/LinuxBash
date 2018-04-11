#!/usr/bin/env python
#_*_coding:utf-8_*_
import time
import sys,os 
from datetime import datetime
import re
from follow import Follow
import subprocess 
print len(sys.argv)
if len(sys.argv) <= 1:
    print "Usage : %s LOG" %sys.argv[0]
    sys.exit(1)
else:
    LOG=sys.argv[1]
if not os.path.exists(LOG) or os.path.getsize(LOG)==0:
    print "Log %s does not exisits or size is 0" %LOG
    sys.exit(1)
    #log=Follow(logFile)
def checkLog(logFile):
    log=Follow(logFile)  #1.log
    while 1:
        time.sleep(1)
    #print log
        log_re = re.compile('^(?P<client_ip>.*?) (?P<host>.*?) (?P<user>.*?) \[(?P<date>.*?)\] "(?P<method>[\w]+) (?P<uri>.*?) (?P<protocol>HTTP/1.1)" (?P<status>200) (?P<body_size>\d+) "(?P<http_referer>.*?)" "(?P<http_user_agent>.*?)" "(?P<http_accept_language>.*?)" "(?P<request_time>.*?)" "(?P<upstream_response_time>.*?)" "(?P<upstream_addr>.*?)" "(?P<upstream_status>.*?)"' )

        line=log.readline()
        print line
        if line:
            log_m=log_re.match(line)	
            print log_m.groupdict()
checkLog(sys.argv[1])
