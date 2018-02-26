#!/usr/bin/env python
import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr
msg = MIMEText('邮件内容', 'plain', 'utf-8')
msg['From'] = formataddr(["xxx名字",'发件人邮箱'])
msg['To'] = formataddr(["走人",'收件人邮箱'])
msg['Subject'] = "主题"
server = smtplib.SMTP("smtp.126.com", 25)

server.login("发件人邮箱", "发件人邮箱密码")

server.sendmail('发件人邮箱', ['收件人邮箱',], msg.as_string())

server.quit()
