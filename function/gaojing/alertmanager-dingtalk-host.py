# -*- coding:UTF-8 -*-
import os
import json
import requests
import smtplib
from email.mime.text import MIMEText
from email.header import Header
import datetime

from flask import Flask
from flask import request

app = Flask(__name__)


now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
d1 = str(now_date)
d2 = d1.replace(" ","T")
d2 += "+08:00"

def email_send(data, title):
    mail_host="smtp.263.net:465"  #设置服务器
    mail_user="haj@jovision.com"    #用户名
    mail_pass="HUanjia521..."   #口令 
     
     
    sender = 'haj@jovision.com'
    receivers = ['haj@jovision.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱
     
    message = MIMEText(data, 'plain', 'utf-8')
    message['From'] = Header("邵阳高可用告警", 'utf-8')
    message['To'] =  Header("邵阳高可用告警", 'utf-8')
     
    subject = title
    message['Subject'] = Header(subject, 'utf-8')
     
     
    try:
        smtpObj = smtplib.SMTP() 
        smtpObj.connect(mail_host, 25)    # 25 为 SMTP 端口号
        smtpObj.login(mail_user,mail_pass)  
        smtpObj.sendmail(sender, receivers, message.as_string())
        print ("邮件发送成功")
    except smtplib.SMTPException:
        print ("Error: 无法发送邮件")



@app.route('/', methods=['POST', 'GET'])
def send():
    if request.method == 'POST':
        post_data = request.get_data()
        send_alert(bytes2json(post_data))
        return 'success'
    else:
        return 'weclome to use prometheus alertmanager dingtalk webhook server!'


def bytes2json(data_bytes):
    data = data_bytes.decode('utf8').replace("'", '"')
    return json.loads(data)


def send_alert(data):
    #token = os.getenv('ROBOT_TOKEN')
    token = '75e034b550c6af6ed358e8ae4225ec587484885851820705a735b75816318fa6'
    if not token:
        print('you must set ROBOT_TOKEN env')
        return
    url = 'https://oapi.dingtalk.com/robot/send?access_token=%s' % token
    for output in data['alerts'][:]:
        try:
            message = output['annotations']['titled']
        except KeyError:
            try:
                message = output['annotations']['description']
            except KeyError:
                message = 'null'
        try:
            instance = output['labels']['instance']
        except KeyError:
            instance = 'null'

        send_data = {
            "msgtype": "markdown",
            "markdown": {
                "title": "prometheus_alert",
                "text": "**告警程序**: prometheus_alert \n" +
                        "**告警级别**: %s \n\n" % output['labels']['severity'] +
                        "**告警主机**: %s \n\n" % instance +
                        "**告警类型**: %s \n\n" % output['labels']['alertname'] +
                        "**告警状态**: %s \n\n" % output['status'] +
                        "**告警描述**: %s \n\n" % message +
                        "**告警详情**: %s \n\n" % output['annotations']['description'] +
                        "**告警时间**: %s \n\n" % output['startsAt'] 
            }
        }
        
        send_data_json = {
            "alarmProm":"prov",
            "alarmLevel": output['labels']['severity'],
            "alarmHost": instance,
            "alarmType": output['labels']['namespace'],
            "alarmStatus": output['status'],
            "alarmContent": output['annotations']['description'],
            "alarmDetails": message,
            "alarmTime": d2
        }
        header = {"Content-Type": "application/json"}
        print(send_data_json)     
        monitor_url = "http://127.0.0.1:9090/v3/event/message/insert"
        req = requests.post(monitor_url, json.dumps(send_data_json), headers=header)
        print (req.text)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
