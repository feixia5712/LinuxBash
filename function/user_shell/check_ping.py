#!/usr/bin/env python
import subprocess
import re
import time

date=time.strftime('%Y%m%d',time.localtime())
now=time.strftime('%Y-%m-%d %H:%M:%S',time.localtime())
print date
print now

iplist=['192.168.100.129','1.1.1.1','www.baidu.com']

#ping command parameters
interval=0.5
count=10
timeout=1
subp={}
#output dic
output={}
#regex parse ping result
r=re.compile(r'(?P<package_loss>\d+)% packet loss.*\n(rtt min/avg/max/mdev = [0-9.]+/(?P<avg_time>[0-9.]+)/[0-9.]+/[0-9.]+ ms(, pipe \d+)?\n|(pipe \d+)?\n)')

#fork ping child process
for ip in iplist:
    subp[ip]=subprocess.Popen('ping -q -W %s -c %d -i %f %s' %(timeout,count,interval,ip),shell=True,stdout=subprocess.PIPE)
print subp
#get ping result
print len(iplist)
while len(iplist)!=0:
    for ip in iplist:
		#check if child process has terminated
        if subp[ip].poll()!=None:
            out=subp[ip].communicate()[0]
	    m=r.search(out)
            if m:
                status=m.groupdict()
                if status['avg_time']:
		    print "host: %s exit_code: %d package_loss: %s response_time: %s" %(ip,subp[ip].returncode,status['package_loss'],status['avg_time'])
		    output[ip]="host: %s exit_code: %d package_loss: %s response_time: %s\n" %(ip,subp[ip].returncode,status['package_loss'],status['avg_time'])
                    iplist.remove(ip)
		else:
		    print "host: %s exit_code: %d package_loss: %s" %(ip,subp[ip].returncode,status['package_loss'])
		    output[ip]="host: %s exit_code: %d package_loss: %s\n" %(ip,subp[ip].returncode,status['package_loss'])
		    iplist.remove(ip)
	time.sleep(1)
print output
print iplist
