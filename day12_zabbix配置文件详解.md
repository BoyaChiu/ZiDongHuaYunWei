Zabbix之配置文件详解  
   
zabbix配置文件种类：  
zabbix_server配置文件zabbix_server.conf  
zabbix_proxy配置文件zabbix_proxy.conf  
zabbix-agentd配置文件zabbix_agentd.conf  
   
   
   
1.zabbix_server的配置文件：  
   
 NodeID=0 #分布式节点id号，0代表是独立服务器，默认是被注释掉的  
ListenPort=10051 #zabbix server的端口，默认是10051  
SourceIP= #连接的源ip地址，默认为空，默认即可  
LogFile=/tmp/zabbix_server.log #日志文件的存放位置  
LogFileSize=1 #日志文件的大小，单位为MB，当设置为0时，表示不仅行日志轮询， 默认设置为1，默认即可  
DebugLevel=3 #指定调试级别，默认即可  
PidFile=/tmp/zabbix_server.pid #pid文件的存放位置  
DBHost=localhost #数据库主机名，当设置为localhost时，连接mysql通过sock  
DBName=zabbix #指定存放zabbix数据数据库的名字 （必须要配置)  
DBUser=zabbix #指定连接数据库的用户名 （必须要配置)  
DBPassword=zabbix #用户连接数据库需要的密码 （必须要配置)  
DBSocket=/var/lib/mysql/mysql.sock #前文主机设置为localhost，用户连接数据库所用的sock位置，  
DBPort=3306 #数据库的端口号，当用sock连接时，无关紧要，当通过网络连接时需设置  
StartPollers=5 #默认即可  
StartIPMIPollers=0 #使用IPMI协议时，用到的参数  
StartTrappers=5 #打开的进程数  
StartPingers=1  
StartDiscoverers=1  
StartHTTPPollers=1  
StartHTTPPollers=1  
JavaGateway=127.0.0.1 #JavaGateway的ip地址或主机名  
JavaGatewayPort=10052 #JavaGateway的端口号  
StartJavaPollers=5 #开启连接javagatey的进程数  
SNMPTrapperFile=/tmp/zabbix_traps.tmp  
StartSNMPTrapper=0 #如果设置为1，snmp trapper进程就会开启  
ListenIP=0.0.0.0 #监听来自trapper的ip地址  
ListenIP=127.0.0.1  
HousekeepingFrequency=1 #zabbix执行Housekeeping的频率，单位为hours  
MaxHousekeeperDelete=500 #每次最多删除历史数据的行  
SenderFrequency=30 #zabbix试图发送未发送的警报的时间，单位为秒  
CacheSize=8M #缓存的大小  
CacheUpdateFrequency=60#执行更新缓存配置的时间，单位为秒数  
StartDBSyncers=4  
HistoryCacheSize=8M  
TrendCacheSize=4M  
HistoryTextCacheSize=16M  
NodeNoEvents=0  
NodeNoHistory=0  
Timeout=3  #超时时间，自定义键值时如果执行时间较长需要调整此参数  
TrapperTimeout=300  
UnreachablePeriod=45  
UnavailableDelay=60  
UnreachableDelay=15  
AlertScriptsPath=/usr/local/zabbix/shell #脚本的存放路径  
FpingLocation=/usr/local/sbin/fping #fping指令的绝对路径  
SSHKeyLocation=  
LogSlowQueries=0  
TmpDir=/tmp  
Include=/usr/local/etc/zabbix_server.general.conf  
Include=/usr/local/etc/zabbix_server.conf.d/ #子配置文件路径  
StartProxyPollers=1 #在zabbix proxy被动模式下用此参数  
ProxyConfigFrequency=3600  
ProxyDataFrequency=1  
   
   
2.zabbix_agentd的配置文件  
   
PidFile=/tmp/zabbix_agentd.pid #pid文件的存放位置  
LogFile=/tmp/zabbix_agentd.log #日志文件的位置  
LogFileSize=10 #当日志文件达到多大时进行轮询操作  
DebugLevel=3 #日志信息级别  
SourceIP= #连接的源ip地址，默认为空  
EnableRemoteCommands=0 #是否允许zabbix server端的远程指令， 0表示不允许， 1表示允许  
LogRemoteCommands=0 #是否开启日志记录shell命令作为警告 0表示不允许，1表示允许  
Server=127.0.0.1 #zabbix server的ip地址或主机名，可同时列出多个，需要用逗号隔开  
ListenPort=10050 #zabbix agent监听的端口  
ListenIP=0.0.0.0 #zabbix agent监听的ip地址  
StartAgents=3 #zabbix agent开启进程数  
ServerActive=127.0.0.1 #开启主动检查  
Hostname=Zabbix server #在zabbix server前端配置时指定的主机名要相同，最重要的配置  
RefreshActiveChecks=120 #主动检查刷新的时间，单位为秒数  
BufferSend=5 #数据缓冲的时间  
BufferSize=100 #zabbix agent数据缓冲区的大小，当达到该值便会发送所有的数据到zabbix server  
MaxLinesPerSecond=100 #zabbix agent发送给zabbix server最大的数据行  
AllowRoot=0 #是否允许zabbix agent 以root用户运行  
Timeout=3 #设定处理超时的时间  
Include=/usr/local/etc/zabbix_agentd.userparams.conf  
Include=/usr/local/etc/zabbix_agentd.conf.d/ #包含子配置文件的路径  
UnsafeUserParameters=0 #是否允许所有字符参数的传递  
UserParameter= #指定用户自定义参数  
   
   
3.zabbix_proxy的配置文件  
ProxyMode=0            0 - proxy in the active mode    1 - proxy in the passive mode
Server=192.168.100.100 #指定zabbix server的ip地址或主机名  
Hostname=zabbix-proxy-1.35 #定义监控代理的主机名，需和zabbix server前端配置时指定的节点名相同  
LogFile=/tmp/zabbix_proxy.log #指定日志文件的位置  
PidFile=/tmp/zabbix_proxy.pid #pid文件的位置  
DBName=zabbix_proxy #数据库名  
DBUser=zabbix #连接数据库的用户  
DBPassword=zabbix#连接数据库用户的密码  
ConfigFrequency=60 #zabbix proxy从zabbix server取得配置数据的频率  
DataSenderFrequency=60 #zabbix proxy发送监控到的数据给zabbix server的频率

  
---  
Alias  
key的别名，例如 Alias=ttlsa.userid:vfs.file.regexp[/etc/passwd,^ttlsa:.:([0-9]+),,,,\1]， 或者ttlsa的用户ID。你可以使用key：vfs.file.regexp[/etc/passwd,^ttlsa:.: ([0-9]+),,,,\1]，也可以使用ttlsa.userid。  
备注: 别名不能重复，但是可以有多个alias对应同一个key。  
   
AllowRoot  
默认值：0  
是否允许使用root身份运行zabbix，如果值为0，并且是在root环境下，zabbix会尝试使用zabbix用户运行，如果不存在会告知zabbix用户不存在。  
0 - 不允许  
1 - 允许  
   
BufferSend  
取值范围：1-3600  
默认值：5  
数据存储在buffer中最长多少秒  
   
BufferSize  
取值范围：2-65535  
默认值：100  
buffer最大值，如果buffer满了，zabbix将会将检索到的数据发送给zabbix server或者proxy  
   
DebugLevel  
取值范围：0-5  
默认值：3  
指定日志级别  
0 - basic information about starting and stopping of Zabbix processes  
1 - critical级别  
2 - error级别  
3 - warnings级别  
4 - debug级别  
5 - extended debugging (与级别4一样. 只能使用runtime control 来设置.)  
   
EnableRemoteCommands  
默认值：0  
是否运行zabbix server在此服务器上执行远程命令  
0 - 禁止  
1 - 允许  
   
HostMetadata  
取值范围：0-255 字符  
仅用于主机自动注册功能，如果当前值为定义，那么它的值默认为HostMetadataItem的值。这个选项在2.2.0之后加入，并且确保支付不能超过限制，以及字符串必须是UTF8，否则服务器无法启动  
zabbix自动注册请参考：zabbix客户端自动注册（84）  
   
HostMetadataItem  
功能同上，如果HostMetadata值未设置，这个配置才有效。支持使用UserParameters、alias、system.run[]  
   
Hostname  
默认值：HostnameItem配置的值  
主机名，必须唯一，区分大小写。Hostname必须和zabbix web上配置的一直，否则zabbix主动监控无法正常工作。为什么呢？因为agent拿着这个主机名去问server，我有配置主动监控项 吗？server拿着这个主机名去配置里面查询，然后返回信息。  
支持字符：数字字母、'.'、' '、 '_'、 '-'，不超过64个字符  
   
HostnameItem  
默认值:system.hostname  
设置主机名，只有当HostMetadata没设置，她才生效。不支持UserParameters 、aliases，支持system.run[]  
   
Include  
包含自配置文件，不同的配置写到不同的文件中，然后include，配置文件会显得规范。例如: /absolute/path/to/config/files/*.conf. Zabbix 2.4.0开始支持正则表达式。  
   
ListenIP  
默认值：0.0.0.0  
监听IP地址，默认为所有接口，多个ip之间使用逗号分隔  
   
ListenPort  
取值范围：1024-32767  
默认值10050  
监听端口  
   
LoadModule  
加载模块文件，可以写多个  
格式: LoadModule=  
必须配置LoadModulePath，指定模块目录  
zabbix模块请参考：zabbix加载扩展模块 第三方库支持（92）  
   
LoadModulePath  
模块路径，绝对路径，如上  
   
LogFile  
日志文件路径  
如果未配置，日志会记录到syslog中  
   
LogFileSize  
取值范围:0-1024  
默认值：1  
日志文件大小，单位为MB。  
0 - 关闭自动轮滚.  
备注：如果日志文件到达了最大值并且文件轮滚失败，那么老日志文件会被清空掉。  
   
LogRemoteCommands  
默认值：0  
记录原型执行的shell命令日志，级别为warrning  
0 - disabled  
1 - enabled  
   
MaxLinesPerSecond  
取值范围：1-1000  
默认值：100  
处理监控类型为log何eventlog日志时，agent每秒最大发送的行数。默认为100行  
zabbix日志监控请参考：zabbix监控日志文件 MySQL日志为例（95）  
   
PidFile  
默认值:/tmp/zabbix_agentd.pid  
PID文件名  
   
RefreshActiveChecks  
取值范围：60-3600  
默认值：120  
多久时间（秒）刷新一次主动监控配置信息，如果刷新失败，那么60秒之后会重试一次  
   
Server  
zabbix server的ip地址，多个ip使用逗号分隔  
   
ServerActive  
zabbix 主动监控server的ip地址，使用逗号分隔多IP，如果注释这个选项，那么当前服务器的主动监控就被禁用了  
   
SourceIP  
zabbix对外连接的出口IP地址  
   
StartAgents  
取值范围：0-100  
默认值：3  
zabbix启动之后开启被动监控的进程数量，如果设置为0，那么zabbix被动监控被禁用，并且不会监听相应端口，也就是说10050端口不会开启。  
   
Timeout  
默认值：1-30  
默认值：3  
超时时间  
   
UnsafeUserParameters  
取值范围：0,1  
默认值： 0  
允许所有字符的参数传递给用户定义的参数。  
   
User  
默认值：zabbix  
运行zabbix程序的用户，如果AllowRoot被禁用，才有效果  
   
UserParameter  
用户自定义key，格式: UserParameter=,  
例如：serParameter=system.test,who|wc -l  
更多请看：zabbix自定义用户key与参数User parameters（24）  