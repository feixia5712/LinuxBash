#!/usr/bin/env python
#-*-coding:utf-8-*-

'''
调用钉钉接口发送报警信息,很简单就只需要像webhook发送post请求就行了,python的post请求这里使用两种方式实现
'''

import json,urllib2

url="https://oapi.dingtalk.com/robot/send?access_token=xxxxxx"
header = {
        "Content-Type": "application/json",
        "charset": "utf-8"
        }

data={
    "msgtype": "text",
    "text": {
        "content": "我就是我, 是不一样的烟火" #发送的内容
    },
    "at": {
        "atMobiles": [
            "1585xxxx"    具体@的人
        ],
        "isAtAll": False    #false是默认不@所有人
    }
}
sendData = json.dumps(data)
request = urllib2.Request(url,data=sendData,headers=header)
urlopen = urllib2.urlopen(request)
print urlopen.read()

具体详情:https://testerhome.com/topics/11217
