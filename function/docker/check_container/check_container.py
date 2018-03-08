#!/usr/bin/env python
#-*- coding:utf-8 -*-


'''
检查docker容器存活，并且报警发送到dingding群
'''

import docker
import subprocess
import json
import logging
import requests
from ding import DingtalkChatbot
import sys
class container(object):
    
    def __init__(self):
        pass

    def check_container(self):
        container_name_new = []
        container_name = [u'test_docker',u'zabbix-web-nginx-pgsql',u'zabbix-server-pgsql',u'zabbix-postgres-server',u'tomcat7-iskyshop2-stress',u'nginx-page',u'tomcat7-iskyshop',u'nginx-front']
        docker_client = docker.DockerClient(base_url='unix://var/run/docker.sock', version='1.27')
        container_id = subprocess.check_output('docker ps -q',shell=True).split('\n')
        for i in container_id:
            if i:
                container_name_new.append(docker_client.containers.get(i).name)
        return container_name_new
    @classmethod
    def get_ip(cls):
        ip=subprocess.check_output("ifconfig eth0 | awk -F [:' ']+ 'NR==2{print $4}'",shell=True)
        return ip
if __name__ == '__main__':

    webhook = "https://oapi.dingtalk.com/robot/send?access_token=262648106feebb848e2eae4b126f44iddddd08fdwera269d29c92c2647b4b13fb1b0bc553"
    # 用户手机号列表
    at_mobiles = [1585422xxxx]
    # 初始化机器人小丁
    xiaoding = DingtalkChatbot(webhook)
    obj = container()
    result = obj.check_container()
    container_name = [u'test_docker',u'zabbix-server-pgsql',u'zabbix-postgres-server',u'tomcat7-iskyshop2-stress',u'nginx-page',u'tomcat7-iskyshop',u'nginx-front']
    for i in  container_name:
        if i in result:
            print "%s is running" %i
        else:
            data="%s %s container is down" %(container.get_ip(),i)
            msg=data
            xiaoding.send_text(msg=msg, at_mobiles=at_mobiles)


