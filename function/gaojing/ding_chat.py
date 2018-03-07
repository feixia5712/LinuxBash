#!/usr/nin/env python
#-*- coding:utf-8 -*-

import json,requests

url="https://oapi.dingtalk.com/robot/send?access_token=262648106feebb848e2eae4b126f4408fda269d29c92c2647b4b13fb1b0bc553"
header = {
        "Content-Type": "application/json",
        "charset": "utf-8"
        }
data={
    "msgtype": "text",
    "text": {
        "content": "我就是我, 是不一样的烟火"
    },
    "at": {
        "atMobiles": [
            "15854228252"
        ],
        "isAtAll": False
    }
}
sendData = json.dumps(data)
response = requests.post(url,data=sendData,headers=header)
print response
