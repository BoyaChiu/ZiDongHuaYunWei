### 安装完成之后我们开始配置我们的zabbix  
修改密码不要忘记了  
修改zabbix_agentd.conf  
1. Server=IP(服务端地址)  
2. /etc/init.d/zabbix_agentd.conf  
---  
zabbix面板  
monitoring 监控  
1. Dashboard仪表板  
favourte graphs 图表  
favourte screens 屏幕  
favourite maps 地图  
screens 大屏幕显示  
slide shows 幻灯片 可以迁移  
maps 架构图  
last 20 issues 最后20个问题  
web monitoring web监控  
2. problems 问题  
3. overview 回顾  
4. latest data 最新的数据  
5. triggers 触发器  
6. graphs 图表  
  
7. maps 地图  
8. discovery 发现  
9. 应用监控  
---  
inventory 资产管理系统  
---  
reports 报告  
---  
  
configurations配置  
1. hostgroups  
2. template  
3. hosts  
4. maintenance 维护 可以设置维护时间 不告警  
5. actions 动作 你故障了需要通知 在action里面设置  
6. discovery sla(服务等级协议)  
---  
items同一类型的服务器  
triggers触发器  
SNMP 简单网络管理协议 网络设置  
JMX 监控JAVA应用的  
IPMI 性能比较差  
monitored by proxy 分布式监控  
---  
itmes  
triggers触发器  
key 监控项 proc.num[]  
interval 监控的间隔  
history 历史记录保留的天数  
trends 趋势图保留时间 不能看具体  
type 类型  
applications 名称  
status 状态  
---  
自定义监控项  
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
#!/usr/bin/python  
import smtplib  
import sys  
from email.mime.text import MIMEText  
from email.header import Header  
from email.Utils import COMMASPACE  
receiver = sys.argv[1]  
subject = sys.argv[2]  
mailbody = sys.argv[3]  
smtpserver = 'smtp.exmail.qq.com'  
username = '11@qq.com'  
password = '1111'  
sender = username  
msg = MIMEText(sys.argv[3],'html','utf-8')  
msg['Subject'] = Header(subject, 'uft-8')  
msg['From'] = username  
msg['To'] = receiver  
smtp = smtplib.SMTP()  
smtp.connect(smtpserver)  
smtp.starttls()  
smtp.sendmail(msg['From'], msg['To'],msg.as_string())\  
smtp.quit()  
```  
  
短信提供商HTTP  
  
---  
模板 configreure---templete 可以把机器加到一批机器里面让机器在一个组里面   
可以制作一个模板 让所有的机器套用这个模板  
模板可以链接其他的模板  
echarts.baidu.com/doc/example/force1.html  