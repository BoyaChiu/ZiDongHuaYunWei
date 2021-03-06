### 今天主要内容  
1.实用的命令，（写脚本中常用的命令）  
如果在工作中遇到故障怎么处理
* CPU被占满了怎么处理
* 内存被占满了怎么处理
* 带宽被占满了怎么处理
* 磁盘被占满了怎么办 二种情况 第一种有大文件占磁盘空间,磁盘空间不足    一个是有程序在疯狂的读写磁盘 导致其他程序打不开 
2.shell脚本  

##  实用的命令  
###  小命令  
ping 测试主机是否存活  
-c 次数  
-s 数据包大小  
-i 间隔(单位秒)  
echo 1 >/proc/sys/net/ipv4/icmp_echo_ignore_all   禁ping
ip addr || ifconfig 查看网卡 可以看出ip地址  
nslookup 域名解析需要使用 nslookup www.baidu.com 211.157.15.189  
linux没有自带需要额外安装   
 
arp 负责将ip地址解析成mac地址  
tracepath 路由跟踪  
使用场景,当你的网络出现问题的时候，一般运营商会要你提供一份路由跟踪的表 就是用这个命令来实现  
traceroute 192.168.1.1  

* 可以使用yum provides */nslookup反查 查询这个命令在哪个包里面 
  
### top 以动态的方式查看进程状态  
top命令是Linux下常用的性能分析工具，能够实时显示系统中各个进程的资源占用状况，类似于Windows的任务管理器。  
下面详细介绍它的使用方法。  
load average 'w' 'uptime' 'free' 'find' 'iostat' '\/proc' cpuinfo meminfo zoneinfo mouts  
“需要进行调查法则”： 如果长期你的系统负载在 0.70 上下，那么你需要在事情变得更糟糕之前，花些时间了解其原因。  
“现在就要修复法则”：1.00 。 如果你的服务器系统负载长期徘徊于 1.00，那么就应该马上解决这个问题。否则，你将半夜接到你上司的电话，这可不是件令人愉快的事情。  
“凌晨三点半锻炼身体法则”：5.00。 如果你的服务器负载超过了 5.00 这个数字，那么你将失去你的睡眠，还得在会议中说明这情况发生的原因，总之千万不要让它发生。 
如果没有办法可以想了  就迁移你们的业务
常用交互命令  
CPU
* us 用户空间占用CPU百分比  
* sy 内核空间占用CPU百分比  
* ni 用户进程空间内改变过优先级的进程占用CPU百分比  
* id 空闲CPU百分比  
* wa CPU等待磁盘写入完成时间  
如果一台机器看到wa特别高，那么一般说明是磁盘IO出现问题，可以使用iostat等命令继续进行详细分析  
* hi 硬中断消耗时间   
由与系统相连的外设(比如网卡、硬盘)自动产生的。主要是用来通知操作系统系统外设状态的变化。比如当网卡收到数据包
的时候，就会发出一个中断。我们通常所说的中断指的是硬中断(hardirq)。  
* si 软中断消耗时间    
为了满足实时系统的要求，中断处理应该是越快越好。Linux为了实现这个特点，当中断发生的时候，硬中断处理那些短时间
就可以完成的工作，而将那些处理事件比较长的工作，放到中断之后来完成，也就是软中断(softirq)来完成。  
比如我们的U盘 在你弹出来的时候 有的时候需要等待比较长的时间  但是有的时候非常快  
* st: 虚拟机偷取时间  
st的名字很生动，偷取。。。是专门对虚拟机来说的，一台物理是可以虚拟化出几台虚拟机的。在其中一台虚拟机上用top查看发现st不为0，就说明本来有这么多个cpu时间是安排给我这个虚拟机的，但是由于某种虚拟技术，把这个cpu时间分配给了其他的虚拟机了。这就叫做偷取。  
Ctrl+L 擦除并且重写屏幕。    
h或者? 显示帮助画面，给出一些简短的命令总结说明。    
k 终止一个进程。系统将提示用户输入需要终止的进程PID，以及需要发送给该进程什么样的信号。一般的终止进程可以使用15信号；如果不能正常结束那就使用信号9强制结束该进程。默认值是信号15。在安全模式中此命令被屏蔽。    
m 切换显示内存信息。  
t 切换显示进程和CPU状态信息。  
c 切换显示命令名称和完整命令行。  
M 根据驻留内存大小进行排序。  
P 根据CPU使用百分比大小进行排序。  
T 根据时间\/累计时间进行排序。  
W 将当前设置写入~/.toprc文件中。这是写top配置文件的推荐方法。
```
USER   启动进程用户身份
PID    进程号
%CPU   CPU的利用率
%MEM   内存的利用率
VSZ    预留分配的虚拟内存
RSS    真实分配的内存
TTY    在哪个终端启用的进程
STAT   当前进程的状态
D    ：运行中的进程
R    ：运行中的进程
S    ：可中断的睡眠
T    ：停止或被追踪
Z    ：僵尸进程
X    ：死掉的进程
<    ：高优先级别的进程
nVN  ：低优先级别的进程
s    ：是一个进程组，代表还有子进程
+    ：前台进程
START   进程启动时间
TIME    进程运行了多长时间
COMMAND 用什么命令启动的进程
```

### ps 查看进程状态 以静态的方式  
-a 显示其他用户启动的进程  
-u 启动这个进程的用户和它启动的时间  
-x 查看系统中属于自己的进程  
-ef 显示进程的父子关系  
USER --启动进程用户身份  
PID －－进程号  
%CPU －－CPU的利用率  
%MEM －－内存的利用率  
VSZ －－预分分配的虚拟内存  
RSS －－真实分配的内存  
TTY －－在哪个终端启用的进程  
STAT －－当前进程的状态  
Ｄ：不可中断的睡眠  
Ｒ：运行当中的进程  
Ｓ: 可中断的睡眠  
T : 停止或被追踪  
Ｚ：僵尸进程  
X : 死掉的进程  
<:高优先级别的进程>  
n/N：低优先级别的进程  
s：是一个进程组，代表还有子进程  
＋：前台进程  
START －－进程启动时间  
ＴIME －－进程运行了多长时间  
COMMAND －－用什么命令启动的进程  
ps -elf   查看父子进程
-e 显示所有进程  
-l 长格式  
-f 全格式  
找出消耗内存最多的前10名进程  
ps -auxf | sort -nr -k 4 | head -10  
找出使用CPU最多的前10名进程  
ps -auxf | sort -nr -k 3 | head -10  

###  netstat 查看本机开放的端口  
-t tcp连接  
-u udp  
-n 不作反解  
-l 侦听  
-p 进程名  
-a 所有  
netstat -anp tcp/udp/socket监听列表，对应网络连接列表。  
netstat -tnp tcp的网络连接状态  
netstat -tnlp 所有tcp的侦听列表  
netstat -unp udp的网络连接  
netstat -unlp udp的侦听列表  
netstat -tunlp tcp/udp侦听侦听列表  
netstat -rn 查询路由表  
unix/类unix中有三种连接：  
1.tcp 面向连接  
2.udp 面向无连接  
3.socket通常也称作"套接字"，应用程序通常通过"套接字"向网络发出请求或者应答网络请求  
### nmap 端口扫描工具  
nmap -p1-65535 (ipaddress) 扫描1-65535所有的端口在IP地址里面  
nmap -PS 172.16.85.0/24 扫描网段中所有已激活的主机的端口，ip地址和物理地址  
nmap -sO 192.168.1.19 确定目标机支持哪些IP协议 (TCP，ICMP，IGMP等):   特别慢
nmap -O 172.16.85.14 扫描目标主机的操作系统  
nmap -T4 -A -v 172.16.147.13   全面扫描   主要是获取软件的版本号   在修复软件版本的时候需要用这个功能查看软件版本
乌云网 发布漏洞  针对软件版本的漏洞  ssh 2.2    2.3   2.6    ssh2.3 有漏洞
1000台机器  ssh2.3 

|服务|端口号|
|----|-------|
|HTTP|80|
|HTTPS|443|
|Telnet|23|
|FTP|21|
|ssh|22|
|SMTP|25|
|POP3|110|
|TOMCAT|8080|
|WIN远程登录|3389|
|mysqlserver|3306|
|nginx|80|


### 查看流量(网卡流量用于检查应用程序使用流量情况)  
iftop 查看网卡流量使用 不能查询具体的应用程序使用了多少流量  
nethogs 查看进程使用了具体的流量 可以查出程序的PID  
用法 nethogs eth0(如果外网流量大就填外网，如果内网流量大就填内网)  
通过pid使用 ps axu 和lsof查出进程 以及程序文件里面什么问题造成的  
### 查看磁盘读写  
yum -y install sysstat
iostat -x 1 10 查看当前磁盘读写 只能查看全局不能查看具体的程序使用了多少IO  
iotop 找出使用io最高的应用程序
du -hs /opt  查看目录大小

凌晨三点 有台机器的读写非常高  导致业务部正常
找出读写最高的进程出来 (pid)

查看IO占用情况 dd if=/dev/zero of=/test.dbf bs=8k count=300000  
-o：只显示有io操作的进程  
-b：批量显示，无交互，主要用作记录到文件。  
-n NUM：显示NUM次，主要用于非交互式模式。  
-d SEC：间隔SEC秒显示一次。  
-p PID：监控的进程pid。  
-u USER：监控的进程用户。  
iotop常用快捷键： 左右箭头：改变排序方式，默认是按IO排序。  
r：改变排序顺序。  
o：只显示有IO输出的进程。  
p：进程\/线程的显示方式的切换。  
a：显示累积使用量。  
q：退出  
ps -ef |主进程给找出来  

### ss 能够快速的显示活动状态的套接字信息  
和netstat的功能一模一样，  
但是当你服务器的socket连接数量非常大的时候，使用netstat就是浪费你的生命 ss最大的优势就是他比netstat快很多  
常用命令  
显示ICP连接 ss -t -a  
显示sockets 摘要 ss -s  
列出所有打开的网络连接端口 ss -l  
查看进程使用的socket ss -pl  
找出套接字\/端口应用程序 ss -pl|grep 3306  
显示所有的UDP sockets ss -u -a  
查看由多少个用户通过TCP或者其他的协议连接我的服务器  
###lsof 查看当前被使用的文件  
lsof功能一般结合ps 工具一起使用可以查询正在执行的文件和脚本  
  
作业:  
把所有的命令全部测试一次
把运行的结果截图或者拷贝下来发给我
写一个总结
举例
如果CPU高 我要怎么做  锻炼解决问题的思路   锻炼自己写文档的能力  
如果IO高我要怎么做


###shell脚本  
请看章节目录下面的内容  
