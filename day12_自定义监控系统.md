### 自定义监控项  
1. 在配置文件里面添加监控项  
2. 在web端添加  
UserParameter=login-user,uptime|awk -F '' '{print $4}'  
/etc/init.d/agented restart  
yum -y install zabbix_get  
zabbix_get -s 127.0.0.1 -p 10050 -k login-user  
主机 items  
create item  
key要对应login-user  
type of infaormation 获取的数据类型  
units定义数据的类型 自动换算  
use custom multiplier 乘以一个数  
update interval 更新的时间间隔  
flexible intervals 额外的获取时间 可以设置定制的时间  
history storage period 历史数据保存时间  
new applications 新的应用的名称  
applications 系统默认的  
populates host inentory field 资产管理  

---  
触发器  
create tigger  
login-user > 2  
expression 表达式  
function 方法  
last T value is > N  
severity 状态  
dependencies 依赖 报警的相关依赖  
---  
action 动作 定义触发的动作 比如发短信 发邮件等等  
自定义回复的信息 发短信70个字符  
recovery 恢复的时候发送的短信  
conditions 条件  
A 如果是维护状态我不会发短信  
B trigger 维护  
operations 干什么  
step 动作 故障升级机制  
from 1 - to 3 第一次到第三次干一个事情 发给运维  
from 4 - to 5 第4次到第5次干一个事情 发给运维经理  
from 8 - to 10 第8次到第10次 就发给CTO  
step duration 时间间隔  
jabber短信  
---  
报警的介质  
administration---mdedia types  
create media type 创建  
type script  
vim /etc/zabbix/zabbix_server.conf +443  
AlertScriptsPath=/usr/lib/zabbix/alertscripts  

### python写的邮件报警系统  
```  
$1 邮件地址 目标  
$2 邮件主题  
$3 邮件的内容  
#!/usr/bin/env python
# coding: utf-8
import smtplib
import sys
from email.mime.text import MIMEText
from email.header import Header
from email.Utils import COMMASPACE
receiver = sys.argv[1]
subject = sys.argv[2]
mailbody = sys.argv[3]
print receiver
print subject
print mailbody
smtpserver = 'smtp.qq.com'
username = '3377271261@qq.com'
password = 'zrfypvowkysqdafh'
sender = username
#msg = MIMEText(sys.argv[3],'html','utf-8')
msg= MIMEText(sys.argv[3],"html","utf-8")
msg['Subject'] = Header(subject, "utf-8")
msg['From'] = username
msg['To'] = receiver
smtp = smtplib.SMTP()
smtp.connect(smtpserver)
smtp.starttls()
smtp.login(username,password)
smtp.sendmail(msg['From'], msg['To'],msg.as_string())
smtp.quit()
```  
  

短信提供商HTTP  
  
---  
模板 configreure---templete 可以把机器加到一批机器里面让机器在一个组里面   
可以制作一个模板 让所有的机器套用这个模板  
模板可以链接其他的模板  
echarts.baidu.com/doc/example/force1.html  

---
zabbix邮件报警变量表
```
常用变量值
默认接收人：故障{TRIGGER.STATUS},服务器:{HOSTNAME1}发生: {TRIGGER.NAME}故障!
默认信息：
告警主机:{HOSTNAME1}
告警时间:{EVENT.DATE} {EVENT.TIME}
告警等级:{TRIGGER.SEVERITY}
告警信息: {TRIGGER.NAME}
告警项目:{TRIGGER.KEY1}
问题详情:{ITEM.NAME}:{ITEM.VALUE}
当前状态:{TRIGGER.STATUS}:{ITEM.VALUE1}
事件ID:{EVENT.ID}
恢复信息：打钩
恢复主旨：恢复{TRIGGER.STATUS}, 服务器:{HOSTNAME1}: {TRIGGER.NAME}已恢复!
恢复信息：
告警主机:{HOSTNAME1}
告警时间:{EVENT.DATE} {EVENT.TIME}
告警等级:{TRIGGER.SEVERITY}
告警信息: {TRIGGER.NAME}
告警项目:{TRIGGER.KEY1}
问题详情:{ITEM.NAME}:{ITEM.VALUE}
当前状态:{TRIGGER.STATUS}:{ITEM.VALUE1}
事件ID:{EVENT.ID}

```
http://www.ithao123.cn/content-7828600.html