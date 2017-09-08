#  
## 1、iptables扩展匹配  
  
1. iptables(user space)/netfilter(kernel space)  
2. netfilter组成（表(功能模块)／链／规则）  
filter（INPUT/OUTPUT/FORWARD） 过滤  
nat(PREROUTING/POSTROUTING/OUTPUT) 地址转换  
mangle(5个链 ) 更封装层数据包结构  
--&gt;PREROUTING--&gt;FORWARD--&gt;POSTROUTING--&gt;  
INPUT | | OUTPUT  
本机  
  

#### 规则的匹原则：  
  
1、自上而下按顺序匹配  
2、如果匹配到某条规则，执行这个规则动作，就不往后匹配其它规则  
3、如果列表的所有的规则都匹配不到，则匹配默认规则  
iptables [-t talbe] -A | -I | -D | -R | -E chian option(-s -d -i -o -p --dport -m) -j action(ACCEPT/DROP/REJECT/SNAT/DNAT....)  
应用层  
传输层(tcp/udp/sport/doprt/ tcp6个控制位匹配)  
网络层(-s/-d/icmp)  
数据链路层(mac)  
物理层（-i/-o）  

#### 扩展匹配  
  
需求  
  
只允许172.16.85.14访问本机  
  
不允许任何人访问本机  
  
默认规则 drop  
  
172.16.85.14  
  
1、通用匹配 -i -o -s -d  
-i eth0 从这块网卡流入的数据 流入一般用INPUT和PREROUING  
-o eth0 从这块网卡流出的数据 流出一般在OUTPUT和PSOTROUTING  
-s 源IP  
-d 目标IP  
2、隐含匹配 tcp udp icmp sport dport  
3、扩展匹配 -m mac | iprange | state  
-m multiport：表示启用多端口扩展 之后我们就可以启用比如 --dports 21,23,80,8080-8100, 3306  
常用的ACTION： -j  
DROP：悄悄丢弃 nmap  
一般我们多用DROP来隐藏我们的身份，以及隐藏我们的链表  
REJECT：明示拒绝  
ACCEPT：接受  
custom_chain：转向一个自定义的链  
DNAT  
SNAT  
MASQUERADE：源地址伪装 nat实验的时候  
REDIRECT：重定向：主要用于实现端口重定向  
MARK：打防火墙标记的  
RETURN：返回  
在自定义链执行完毕后使用返回，来返回原规则链。  
  
#### 练习题1：  
  
只要是来自于172.16.85.14的都允许访问我本机的172.16.100.1的SSHD服务  
分析：首先肯定是在允许表中定义的。因为不需要做NAT地址转换之类的，然后查看我们SSHD服务，在22号端口上，处理机制是接受，对于这个表，需要有一来一回两个规则，如果我们允许也好，拒绝也好，对于访问本机服务，我们最好是定义在INPUT链上，而OUTPUT再予以定义就好。(会话的初始端先定义)，所以加规则就是：    
定义进来的： iptables -t filter -A INPUT -s 172.16.0.0/16 -d 172.16.100.1 -p tcp --dport 22 -j ACCEPT   
定义出去的： iptables -t filter -A OUTPUT -s 172.16.100.1 -d 172.16.0.0/16 -p tcp --dport 22 -j ACCEPT   
将默认策略改成DROP:  
iptables -P INPUT DROP  
iptables -P OUTPUT DROP  
iptables -P FORWARD DROP  
  
#### 练习题2：  
icmp：0 8  
0：响应请求  
8：回答请求  
[icmp对照表](http://www.361way.com/icmp-type/1186.html)  
假如我们允许自己ping别人，但是别人ping自己ping不通如何实现呢？  
分析：对于ping这个协议，进来的为8（ping），出去的为0(响应).我们为了达到目的，需要8出去,允许0进来  
在出去的端口上：iptables -A OUTPUT -p icmp --icmp-type 8 -j ACCEPT  
在进来的端口上：iptables -A INPUT -p icmp --icmp-type 0 -j ACCEPT  
iptables -A OUTPUT -p icmp --icmp-type 8 -j ACCEPT  
iptables -A INPUT -p icmp --icmp-type 0 -j ACCEPT  
iptables -A OUTPUT -p icmp --icmp-type 0 -j DROP  
iptables -A INPUT -p icmp --icmp-type 8 -j DROP  
小扩展：对于127.0.0.1比较特殊，我们需要明确定义它  
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT  
iptables -A OUTPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT  
/lib/modules/2.6.18-194.el5/kernel/net/ipv4/netfilter/：存放模块的位置  
-m connlimit：每个IP的并发连接数(TCP) --关注的是新发起的连接（NEW --syn）  
mount -o loop rhel55.iso /mnt  
rpm -Uvh /mnt/Server/iptables-1.3.5-5.3.el5_4.1.i386.rpm  
iptables -t filter -A INPUT -s 192.168.1.115 -p tcp --dport 22 -m connlimit --connlimit-above 1 -j DROP  
iptables -t filter -A INPUT -s 192.168.1.115 -p tcp --dport 22 -m connlimit ! --connlimit-above 1 -j ACCEPT  
-m icmp：ping包请求与发送  
[root@ ~]# iptables -A INPUT -p icmp -m icmp --icmp-type echo-reply -j ACCEPT  
[root@ ~]# iptables -A INPUT -p icmp -m icmp --icmp-type echo-request -j ACCEPT  
[root@ ~]# iptables -A INPUT -p icmp -j DROP  
[root@ ~]# iptables -A OUTPUT -p icmp -m icmp --icmp-type 0 -j ACCEPT ==&gt; 0 相当于 echo-reply  
[root@ ~]# iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT ==&gt; 8 相当于 echo-request  
-m ipranges：IP范围  
[!] --src-range ip-ip Match source IP in the specified range  
[!] --dst-range ip-ip Match destination IP in the specified range  
[root@ ~]# iptables -t filter -A FORWARD -m iprange --src-range 192.168.1.1-192.168.1.100 -j ACCEPT  
[root@ ~]# iptables -t filter -A FORWARD -m iprange --dst-range 192.168.1.101-192.168.1.252 -j DROP  
-m limit：速率限制  
[root@ ~]# watch iptables -L INPUT -nv  
[root@ ~]# iptables -A INPUT -s 192.168.1.115 -p icmp -m icmp --icmp-type echo-request -m limit --limit 1/second --limit-burst 1 -j ACCEPT  
[root@ ~]# iptables -A INPUT -s 192.168.1.115 -p icmp -m icmp --icmp-type echo-request -j DROP  
-m mac：匹配源地址的 MAC 地址  
[root@ ~]# iptables -A INPUT -m mac --mac 00:0C:29:58:01:9A -p icmp -j DROP  
-m multiport：多端口  
[root@ html]# iptables -A INPUT -s 192.168.1.0/24 -p tcp -m multiport --dport 22:25,25,110,80,53,21 -j DROP  
-m state(NEW/ESTABLISHED/RELATED/INVALID)：  
NEW --第一个数包，跟TCP状态无关  
ESTABLISHED --第二个数据包  
RELATED --已经发生关系的数据（FTP）  
INVALID --无效数据包  
  
#### 个人简单的防火墙（状态）：  
  
ESTABLISHED 不允许其他主机发起的主动访问，只允许本地主机主动发起的发功能文以及lo通讯  
[root@stu110 ~]# iptables -P INPUT DROP  
[root@stu110 ~]# iptables -A INPUT -i lo -j ACCEPT  
[root@stu110 ~]# iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
[root@stu110 ~]# iptables -A INPUT -p icmp -m state --state NEW -m limit --limit 1/second --limit-burst 3 -j ACCEPT  
[root@stu110 ~]# iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
RELATED：已发生关系的  
（1）vsftpd数据传输（考虑模式，默认是主动模式）  
  
#### 主动模式：  
  
21 －－控制端口  
20 －－数据端口  
  
#### 被动模式：  
  
21 －－控制端口  
1024+ －－数据端口  
[root@mail ~]# insmod /lib/modules/2.6.18-164.el5xen/kernel/net/ipv4/netfilter/ip_conntrack_ftp.ko 需要模块的支持，内核才能支持 RELATED状态  
[root@mail ~]# iptables -t filter -A INPUT -p tcp --dport 21 -j ACCEPT  
[root@mail ~]# iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT  
被动模式/主动：  
service vsftpd start  
iptables -A INPUT -p tcp -m multiport --dport 21 -j ACCEPT  
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
modproble ip_conntrack_ftp --加载FTP状态自动跟踪模块，它可以完成自动切换端口  
-m string：字符串内容进行匹配（局限大，效率低，不太用）  
[root@ ~]# iptables -A INPUT -s 192.168.1.8 -p tcp --dport 22 -m string --algo bm --string "sex" -j DROP  
-m time：时间限制  
[root@ linux]# insmod /lib/modules/$(uname -r)/kernel/net/ipv4/netfilter/ipt_time.ko  
[root@ linux]# iptables -t filter -A INPUT -s 192.168.1.1.0/24 -m time --timestart 9:00 --timestop 17:00 --days Mon,Tue,Wed,Thu,Fri -j ACCEPT  
[root@ linux]# iptables -t filter -A INPUT -s 192.168.1.1.0/24 -p tcp --dport 80 -j DROP  
![](http://note.youdao.com/yws/api/personal/file/7FEEDC66D9C348F983EE8340E9305257?method=download&shareKey=339acaf639759bba1c9e23ecc276f496)  
抓包命令  
tcpdump port 80 -nn -v -S  
tcpdump port 80 -nn -v -S  
位码即tcp标志位,有6种标示:  
  
SYN(synchronous建立联机)  
  
ACK(acknowledgement 确认)  
  
PSH(push传送)  
  
FIN(finish结束)  
  
RST(reset重置)  
  
URG(urgent紧急)  
  
Sequence number(顺序号码)  
  
Acknowledge number(确认号码)  
三次握手状态意义:  
LISTEN - 侦听来自远方TCP端口的连接请求；  
SYN-SENT -在发送连接请求后等待匹配的连接请求；  
SYN-RECEIVED - 在收到和发送一个连接请求后等待对连接请求的确认；  
ESTABLISHED- 代表一个打开的连接，数据可以传送给用户；  
FIN-WAIT-1 - 等待远程TCP的连接中断请求，或先前的连接中断请求的确认；  
FIN-WAIT-2 - 从远程TCP等待连接中断请求；  
CLOSE-WAIT - 等待从本地用户发来的连接中断请求；  
CLOSING -等待远程TCP对连接中断的确认；  
LAST-ACK - 等待原来发向远程TCP的连接中断请求的确认；  
TIME-WAIT -等待足够的时间以确保远程TCP接收到连接中断请求的确认；  
CLOSED - 没有任何连接状态；  
TCP/IP协议中，TCP协议提供可靠的连接服务，采用三次握手建立一个连接，如图1所示。  
  
（1）第一次握手：建立连接时，客户端A发送SYN包（SYN=j）到服务器B，并进入SYN_SEND状态，等待服务器B确认。  
  
（2）第二次握手：服务器B收到SYN包，必须确认客户A的SYN（ACK=j+1），同时自己也发送一个SYN包（SYN=k），即SYN+ACK包，此时服务器B进入SYN_RECV状态。  
  
（3）第三次握手：客户端A收到服务器B的SYN＋ACK包，向服务器B发送确认包ACK（ACK=k+1），此包发送完毕，客户端A和服务器B进入ESTABLISHED状态，完成三次握手。  
  
完成三次握手，客户端与服务器开始传送数据。  
![](http://note.youdao.com/yws/api/personal/file/AD90CE1F1F9C4641AE8A9B7925C4CBA6?method=download&shareKey=8dffe20d6d9e0b21db9523572d8914c0)  
四次挥手是断开连接  
由于TCP连接是全双工的，因此每个方向都必须单独进行关闭。这个原则是当一方完成它的数据发送任务后就能发送一个FIN来终止这个方向的连接。收到一个 FIN只意味着这一方向上没有数据流动，一个TCP连接在收到一个FIN后仍能发送数据。首先进行关闭的一方将执行主动关闭，而另一方执行被动关闭。  
  
CP的连接的拆除需要发送四个包，因此称为四次挥手(four-way handshake)。客户端或服务器均可主动发起挥手动作，在socket编程中，任何一方执行close()操作即可产生挥手操作。  
  
（1）客户端A发送一个FIN，用来关闭客户A到服务器B的数据传送。  
  
（2）服务器B收到这个FIN，它发回一个ACK，确认序号为收到的序号加1。和SYN一样，一个FIN将占用一个序号。  
  
（3）服务器B关闭与客户端A的连接，发送一个FIN给客户端A。  
  
（4）客户端A发回ACK报文确认，并将确认序号设置为收到序号加1。  
#### DDOS原理，及轻量级别攻击的防止  
  
#### # vim /etc/sysctl.conf  
  
net.ipv4.tcp_max_syn_backlog = 8096 --超过最大连接数后产生新syn队列的长度  
net.ipv4.tcp_synack_retries = 2 --syn确认的重试次数  
net.ipv4.ip_local_port_range = 1024 65535--表示用于向外连接的端口范围。缺省情况下很小：32768到61000，改为1024到65000。  
net.ipv4.tcp_syncookies = 1 --表示开启SYNCookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；  
net.ipv4.tcp_tw_reuse = 1 --表示开启重用。允许将TIME-WAITsockets重新用于新的TCP连接，默认为0，表示关闭；  
net.ipv4.tcp_tw_recycle = 1 --表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。  
net.ipv4.tcp_max_tw_buckets=5000--表示系统同时保持TIME_WAIT套接字的最大数量，如果超过这个数字,TIME_WAIT套接字将立刻被清除并打印警告信息。默认为180000，改为5000。  
sysctl -p  
1、通过iptables防止轻量级别的DDOS  
-m limit  
-m connlimit  
2、DDOS的原理，三次握手（客户端第三次不回应服务端）  
3、通过内核增大TCP缓冲区，支持更多的连接。  
4、增加更强大的硬件防火墙，用于丢弃（过滤）掉不正常syn请求,搭建负载均衡集群，另外保证你的外网有足够大的带宽  
第一种 一  
  