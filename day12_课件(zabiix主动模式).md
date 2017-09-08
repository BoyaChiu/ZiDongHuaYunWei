### zabbix agent主动模式监控  
在我们的zabbixserver端主机数量过多的时候，如果有由server端去收集数据，zabbix会出现严重的性能问题，主要的表现有3点  
1. 当被监控端到达一个量级的时候，web会操作卡，容易出现502  
2. 图层断裂 也就是数据丢失  
3. 开启的进程太多 即使减少item的数量，以后加入机器也会出现问题  
---  
既然这么容易出问题，那么肯定有非常好的解决方案  
1. 添加proxy节点做分布式监控  
2. 调整agentd为主动模式  
---  
我们先来做一下主动模式  
首先了解一下什么是主动模式 什么是被动模式  
主动模式就是主动发起请求到zabbix server 询问我需要干的事情  
并主动把数据发给zabbixserver  
被动模式就是等待zabbix server主动请求我的数据  
server端和agent端的关系  
如果server端是主动，那么agent端就是被动  
如果agentd端是被动，那么server就是主动  
第一步是修改我们的agentd配置文件  
172.16.147.26 agentd  
172.16.147.23 server  
```
rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/6/x86_64/zabbix-release-3.2-1.el6.noarch.rpm
yum -y install zabbix-agent* zabbix-proxy  
grep '^[a-Z]' /etc/zabbix/zabbix-agentd.conf  
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
StartAgents=0
ServerActive=172.16.147.26
Hostname=linuxnode2
RefreshActiveChecks=60
BufferSize=200
Timeout=10
Include=/etc/zabbix/zabbix_agentd.d/*.conf
```

```
#客户端agent模式，设置为0表示关闭被动模式，被监控端的 zabbix_agentd 不监听本地端口，所以无法在 netstat -tunpl 中查看到zabbix_agentd进程  
取值范围：0-100
默认值：3
zabbix启动之后开启被动监控的进程数量，如果设置为0，那么zabbix被动监控被禁用，并且不会监听相应端口，也就是说10050端口不会开启。
```
#Server=10.10.10.201 如果设置为纯被动模式，则应该注释掉这一条指令  
ServerActive=**.**.**.** #主动模式的server IP地址  
Hostname=test_host #重要：客户端的hostname，不配置则使用主机名  
RefreshActiveChecks=120 #被监控端到服务器获取监控项的周期，默认120s即可  
BufferSize=200 #被监控端存储监控信息的空间大小  
Timeout=10 #超时时间  
---
第二步调整监控模板  
我们一般做ACTIVE是修改我们模板里面的items改为active模式  
1. 点击template OS linux 模板名称  
2. 点击最下方的full clone 完全克隆  
3. 修改名字 template OS linux Active  
4. 点击添加  
5. 进入模板列表找到刚才添加的模板 并点击监控项  
6. 全选  
7. 最下方找到批量更新  
8. 类型打钩 选择主动模式  
9. 更新  

---  
第三步 添加主机  
1. 配置主机  
2. 配置模板完成  
添加完成后，你会发现zabbix的Z灯不亮 因为你使用的是主动模式  

---  

### proxy代理模式  
zabbix proxy 只是一个进程 需要一个数据库 没有web界面 不会处理事件 也不会发送邮件 只是一个采集数据的功能  
千万要注意数据库   如果你数据库配置错误  不会报数据库错误  只会包获取不到数据
需要数据库  
```
yum -y install zabbix-proxy-mysql  
find / -name schema.sql  
create database zabbix_proxy charset utf8;  
grant all on zabbix_proxy.* to zabbix@localhost identified by 'zabbix';  
读写 用proxy_r proxy_rw flush provilges  
use zabbix_proxy  
source /usr/share/doc/zabbix-proxy-mysql/create/schema.sql  
hostnanme= proxy-node1 zabbixserver就是靠这个来识别  
[root@vagrant-centos65 zabbix]# grep '^[a-Z]' /etc/zabbix/zabbix_proxy.conf  
ProxyMode=0  
Server=172.16.83.15  
Hostname=proxy-node1  
LogFile=/var/log/zabbix/zabbix_proxy.log  
LogFileSize=0  
PidFile=/var/run/zabbix/zabbix_proxy.pid  
DBName=zabbix_proxy  
DBUser=zabbix  
DBPassword=zabbix  
DBSocket=/tmp/mysql.sock  
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log  
Timeout=4  
ExternalScripts=/usr/lib/zabbix/externalscripts  
LogSlowQueries=3000  
[root@vagrant-centos65 zabbix]# grep '^[a-Z]' /etc/zabbix/zabbix_agentd.conf  
PidFile=/var/run/zabbix/zabbix_agentd.pid  
LogFile=/var/log/zabbix/zabbix_agentd.log  
LogFileSize=0  
ListenPort=10050  
StartAgents=0  
ServerActive=172.16.83.14  
Hostname=linux_node3  
Include=/etc/zabbix/zabbix_agentd.d/*.conf  
```
---
再来一个配置文件    注意一个关键点  如果获取不到数据很有可能就是database没有配置好(老师踩过2次坑了)
```
[root@vagrant-centos65 zabbix]# grep '^[a-Z]' /etc/zabbix/zabbix_proxy.conf 
ProxyMode=0
Server=172.16.147.23
Hostname=proxy_node1
LogFile=/var/log/zabbix/zabbix_proxy.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_proxy.pid
DBHost=localhost
DBName=zabbix_proxy
DBUser=zabbix
DBPassword=zabbix
DBSocket=/var/lib/mysql/mysql.sock
DBPort=3306
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
Timeout=4
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000
```
web添加 proxy  
1. 主动模式  
2. 使用proxy的方式 代理  
  
  
  

  
  