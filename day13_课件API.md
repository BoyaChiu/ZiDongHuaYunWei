### 什么是API接口
API（Application Programming Interface，应用程序编程接口）是一些预先定义的函数，目的是提供应用程序与开发人员基于某软件或硬件得以访问一组例程的能力，而又无需访问源码，或理解内部工作机制的细节。简单的说，就是通过某一预先定义的渠道读/写数据的方式。
定义: 所有的API接口都是一个网址
把某些功能封装好，方便其他人调用。
调用的人可以很方便使用这些功能，并且可以不需要知道这些功能的具体实现过程。

ffff(asasdasd)
API规范
去调接口的时候要不要做一个验证
为什么要做验证
合法性    
我们一个接口没有做验证 
1. 安全性的问题    ip  攻击ip 破解密码  信息被泄露出去 信息可以卖钱的  
2. 负载的问题   ddos强度  要低几倍的情况下面   www.baidu.com nginx静态页面处理  retrun index.html    api返回一个   去数据库里面查询 处理   json 处理的字典 返回给用户 字典 转换成json html 字典 htmljson 高很多倍
验证码的处理
早前的API接口  每次去请求的时候 请带上你的user password     
账号密码是不是会泄露 
最流行的API接口请求方式
第一次请求的时候 user password 
return key 
以后每次请求用这个key   验证
之前CMDB  一个key只能使用30s  


### api接口调用  
第一步 获取我们的身份证令牌
第二步 参考官方文档 来创建我们的用户 

curl -i -X POST -H 'Content-Type:application/json' -d '{"jsonrpc": "2.0","method":"user.login","params":{"user":"Admin","password":"zabbix"},"id": 1}' http://172.16.102.19/api_jsonrpc.php  
自动化监控的三种方式  
zabbix agent 自动注册  
自动添加到监控里面  
vim /etc/zabbix/zabbix_agentd  
需要改的地方  
ServerActive=10.0.0.1  
端口10051  
hostname=linux-nde2.example.com 唯一  
hostMetadata=模板 自动注册需要添加的模板  
HostMetadataItem=监控项目 system.uname 167行 zabbix_get -s 10.0.0.1 system.uname  
我这个metadata可以通过监控项目来设定  
设置一个动作来触发条件  
actions event source auto registration  
Agent自动注册  
conditions 条件  
proxy=proxy-node1  
host metadata like liunx  
operations 操作  
add host  
add to host group  
link to template  
  
zabbix server 自动发现  
discovery 自动发现  
在server 端修改  
---  
一般的接口都是这样的 发送账号密码请求一个key 通过这个key去进行其他的请求  
zabbix api  
api_jsonrpc.php rpc json api  
1. 验证 https://www.zabbix.com/documentation/3.2/manual/api/reference/user/login  
```  
curl -s -x POST -H 'Content-Type:application/json' -d'  
{  
"jsonrpc": "2.0",  
"method": "user.login",  
"params": {  
"user": "Admin",  
"password": "zabbix"  
},  
"id": 1  
}' http://172.16.147.23/api_jsonrpc.php |python -mjson.tool  
```  
host  
```  
{  
"jsonrpc": "2.0",  
"method": "host.get",  
"params": {  
"output": ["hostid"],  
"selectGroups": "extend",  
"filter": {  
"host": [  
"Zabbix server"  
]  
}  
},  
"auth": "038e1d7b1735c6a5436ee9eae095879e",  
"id": 2  
}  
```  
2. 请求API 获取serssion id auth key  
  
  
  
  
zabbix server agentd之间设置一个主动模式  
zabbix proxy 自动发现  
通过zabbix api接口 去添加一台机器  
  
hostid   hostname 
修改zabbix监控系统里面主机的名字   流程
可以使用ip来获取zabbix里面的信息
1. 业务库当中获取所有的Ip 
2. 获取zabbix里面所有的ip 
3. 循环我们的业务库当中的ip 来获取所有的hostid
4. 

第一个步骤  获取我们的token
第二个请求API接口 来更新我们hostname

作业   先做业务库和zabbix里面库的对比  然后再更新我们的数据
脚本里面2种方法都有    





