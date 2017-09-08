### 问题1 请求agentd的参数有问题  
请求agented端的参数 有几个前提  
1. 必须在server请求agentd端 因为我们配置文件里面会写serverIP 只会允许这一个IP地址去请求  
2. agented端必须开启被动模式 因为我们是去请求agented的数据  
  
zabbix_get -s 172.16.102.21 -k system.uname  
需要修改agented端的配置文件 因为我们使用了主动模式所有agentd端不会开启10050端口 我们需要改成主动和被动模式都存在的情况  
查看修改好的配置文件  
```PidFile=/var/run/zabbix/zabbix_agentd.pid  
LogFile=/var/log/zabbix/zabbix_agentd.log  
Server=172.16.102.19  
ListenPort=10050  
StartAgents=3  
ServerActive=172.16.83.14  
Hostname=linux_node4  
HostnameItem=system.hostname  
HostMetadata=asdasdasd  
HostMetadataItem=system.uname  
Include=/etc/zabbix/zabbix_agentd.d/*.conf```  
Server 就是server的地址  

---  

### 问题2 怎么请求API接口创建一台机器  
```  
  
{ "jsonrpc": "2.0",  
"method": "host.create",  
"params": {  
"host": "Linux server",  
"interfaces": [  
{  
"type": 1,  
"main": 1,  
"useip": 1,  
"ip": "192.168.3.1",  
"dns": "",  
"port": "10050"  
}  
],  
"groups": [  
{  
"groupid": "50"  
}  
],  
"templates": [  
{  
"templateid": "20045"  
}  
],  
"inventory_mode": 0,  
"inventory": {  
"macaddress_a": "01234",  
"macaddress_b": "56768"  
}  
},  
"auth": "038e1d7b1735c6a5436ee9eae095879e",  
"id": 1  
}
```  
### 问题3 怎么在工作当中去使用API接口  
问题 在工作中我们的告警邮件由于只有IP所以需要通过IP去找影响的业务速度太慢了，我们怎么去快速的定位问题  
解决方案 给每一个机器定义一个角色信息 然后在发送邮件的时候发送角色信息 让我们快速的定位到影响的业务  
大部分的公司使用的是自建库 一般会定义一些角色 我们可以通过角色名称来快速的定位问题的所在  
  
写zabbixAPI接口的流程  
1. 获取key  
2. 调用我们接口去实现我们想要的功能  
---  
写脚本之前  
1. 获取key def getzabbixtokey()  
value={} data  
python怎么去请求接口 url data header  
  
2. 调用api接口创建一个主机  
value  
---  
1. zabbix_API接口以及写好了  
2. updat_hostname函数也写好了  
3. 问题 怎么关联 使用IP地址关联  
4. 问题 怎么从数据库里面获取地址  
所有的IP地址全部获取到了  
轮训 拿每一个IP 去zabbix查询 有没有这台机器  
获取hostid  
  
  
update_hostname url auth value  
  
  
  
  
  
  
  
  