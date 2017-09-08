### 回顾上节课的内容  

常用的命令  
shell脚本  
  
### 今天的主要内容  
  
1.iptables  

---
附件 
CC攻击器-邪恶十六进制2.0    模拟cc攻击
python写的暴力破解的脚本    模拟暴力破解攻击
   
### linux的防火墙 iptables  
名词解释
dip|sip    source(源)  destination(目的,目标)
sport|dport    
#### netfilter(iptables)  
  
netfilter --工作在内核软件，实现数据包的过滤。  
iptables --工作应用层一个软件，用来控制netfilter。  
1.netfilter/iptables包过滤防火墙（tcp/ip四层）  
1）应用层 －－通过软件为用户提供接口  
2）传输层 －－提供可靠或不可靠的数据传输（TCP／UDP）使用端口来标示服务类型 sport dport  
3）网络层 －－提供路由和选址(icmp) sip dip  
4）数据链路层 －－传输数据帧（MAC） s _mac arp写 在局域网内泛洪 来找到我们对应的MAC  
5）物理层 －－传输透明比特流 eth0 eth1  
过滤的依据： s_mac/sip/dip/sport/dport/状态（三次握手/四次断开）SYN DDOS攻击怎么防御我们DDOS 小流量  
netfilter的逻辑架构： nat 10  
  
![image](http://note.youdao.com/yws/api/personal/file/8A0AE23B912A4BDFB87CF292CF1296D2?method=download&shareKey=1cad1258d1588c90c65e7def86a3e7f6)

netfilter防火墙的元素及关系:  
netfilter==>表==>链==>规则  
  
#### 三张表：  
  
filter 防火墙表，允许和拒绝都在这里实现  
nat 地址转换  
mangle 数据包整形  
  
#### 五条链：  
  
INPUT 本机进站的数据流  
OUTPUT 本机出站的数据流  
FORWARD 路由的数据流  
POSTROUTING 路由后的数据流  
PREROUTING 路由前的数据流  
  
#### 表跟链的对应关系：  
  
filter:INPUT,OUTPUT,FORWARD  
nat: OUTPUT,PREROUTING,POSTROUTING  
  
## mangle:INPUT,OUTPUT,FORWARD,PREROUTING,POSTROUTING  
  
#### 四种数据流：  
  
本机进站的数据流：packet--&gt;ethX--&gt;PREROUTING--&gt;INPUT--&gt;本机  
本机出站的数据流：packet--&gt;OUTPUT--&gt;POSTROUTING--&gt;ethX--&gt;destination  
路由的数据流：  
出去： packet--&gt;eth0--&gt;PREROUTING--&gt;FORWARD--&gt;POSTROUTING--&gt;eth1--destination  
回来： packet--&gt;eth1--&gt;PREROUTING--&gt;FORWARD--&gt;POSTROUTING--&gt;eth0--destination  
本机访问本机： 本机--&gt;packet--&gt;lo--&gt;PREROUTING--&gt;INPUT--&gt;本机  
  
## 本机--&gt;packet--&gt;OUTPUT--&gt;POSTROUTING--lo--&gt;本机  
  
#### 表的匹配顺序:  
  
mangle--&gt;nat--&gt;filter  
  
#### 防火墙规则匹配顺序:  
  
1.按顺序匹配,如果第一条匹配到了就直接执行这条规则的动作,不往下匹配其它规则.  
  
## 2.如果第一条匹配不到,第二条也匹配不到,继续往下匹配直到找到匹配的规则,如果找不到匹配默认规则.  
  
传输层：协议（tcp/udp）  
端口（sport/dport）  
网络层：  
IP地址（sip/dip/icmp） ping  
数据链路层：  
mac地址（--mac-source）  
物理层：  
从哪个网卡进来 -i eth0 eth1 服务器2个地址 外网地址 一个内网地址  

### iptables操作命令
```
#iptables --help
Usage: iptables -[AD] chain rule-specification [options]
       iptables -[RI] chain rulenum rule-specification [options]
       iptables -D chain rulenum [options]
       iptables -[LFZ] [chain] [options]
       iptables -[NX] chain
       iptables -E old-chain-name new-chain-name
       iptables -P chain target [options]
       iptables -h (print this help information)

  --append  -A chain            追加规则
  --delete  -D chain            删除规则
  --delete  -D chain rulenum    删除指定序号的规则
                                
  --insert  -I chain [rulenum]  插入一条规则(default 1=first) 插入会插入表的第一行
  --replace -R chain rulenum    替换一条规则
                                
  --list    -L [chain]          显示出链或者链中的规则
  --flush   -F [chain]          在一个链或者所有链中清空规则
  --zero    -Z [chain]          清空计数
  --new     -N chain            创建用户自定义链
  --delete-chain
            -X [chain]          删除用户自定义链
  --policy  -P chain target     指定默认规则
                                Change policy on chain to target
  --rename-chain
            -E old-chain new-chain
                                     重命名用户自定义链
Options:
  --proto       -p [!] proto    指定协议,!代表取反
  --source      -s [!] address[/mask]   --指定源地址
                                source specification
  --destination -d [!] address[/mask]   --指定目标地址
                                destination specification
  --in-interface -i [!] input name[+]   --指定数据从哪个网口进来
                                network interface name ([+] for wildcard)
  --jump        -j target                       --匹配动作
                                target for rule (may load target extension)
  --goto      -g chain
                              jump to chain with no return
  --match       -m match                        --扩展匹配
                                extended match (may load extension)
  --numeric     -n              --端口和IP以数值方式显示,不作反解
  --out-interface -o [!] output name[+] --指定数据从哪个网口出去
                                network interface name ([+] for wildcard)
  --table       -t table        --指定使用哪个表 (default: `filter')
  --verbose     -v              --显示详细信息
  --line-numbers                --显示规则的序号
  --exact       -x              expand numbers (display exact values)
  ```
  
* 查看
```
# iptables -t nat -L -n -v --line
# iptables -t filter -L -n
# iptables -t filter -L INPUT
# iptables -t filter -L INPUT -v -n
# iptables -t filter -L INPUT -n -v --line
# watch -n 0.1 iptables -L INPUT --line -n -v
iptables -nv -L
```
* 追加 插入 替换 删除
```
追加规则：
# iptables -t filter -A INPUT -i lo -j ACCEPT

插入规则：
# iptables -t filter -I INPUT -i eth0 -j ACCEPT		－－插入成为第一条
# iptables -t filter -I INPUT 3 -i eth0 -j ACCEPT		－－插入成为第三条规则

替换规则：
# iptables -t filter -R INPUT 3 -i eth1 -j ACCEPT		－－替换成为指定规则
	
删除规则：
# iptables -t filter -D INPUT 2					－－删除指定链指定编号的规则

+++++++++++
#iptables -t filter -A INPUT -i lo -j ACCEPT
#iptables -t filter -A OUTPUT -o lo -j ACCEPT
#iptables -t filter -A INPUT -i eth0 -s 192.168.0.0/24 -d 192.168.0.250 -j ACCEPT
# iptables -t filter -A INPUT -i eth1 -j ACCEPT
# iptables -L INPUT -n --line -v
# iptables -t filer -I INPUT 2 -i eth2 -j ACCEPT   插入默认第二条
# iptables -t filter -I INPUT  -i eth3 -j ACCEPT    插入默认第一条
# iptables -t filter -R INPUT 1 -i eth4 -j ACCEPT  替换默认第一条
#iptables -t filter -D INPUT 1					删除默认第一条
# iptables -t filter -F INPUT					清空filter所有INPUT链
#iptables -t filter -F				

#iptables -L INPUT -n --line -v

空规则：
	1、清空一张表
# iptables -t filter -F
注意不会清除默认规则

	2、清空一条链中的规则
# iptables -t filter -F INPUT

新建/删除用户自定义的链：
# iptables -t filter -N uplooking	新建
# iptables -t filter -X uplooking		删除
# iptables -t filter -X				清空filter表中所有用户自定义链
+++++++++
iptables -t filter -N TCP
iptables -t filter -N UDP
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A INPUT -p tcp -j TCP
++++++++
更改默认规则：
# iptables -t filter -P INPUT ACCEPT
# iptables -t filter -P INPUT DROP
```

  

## 从哪个网卡出去 -o  
  
传输层：协议（tcp/udp）  
端口（sport /dport）  
网络层：  
IP地址（sip /dip /icmp） ping  
数据链路层：  
mac地址（--mac-source）  
物理层：  
从哪个网卡进来 -i eth0 eth1 服务器2个地址 外网地址 一个内网地址  
从哪个网卡出去 -o  
  
### tcpdump 抓包工具  
  
1）tcpdump（传输／网络层）  
  
tcpdump -i eth0  
  
tcpdump -i eth0 -vnn  
  
-v：显示包含有TTL，TOS值等等更详细的信息  
  
-n：不要做IP解析为主机名  
  
-nn：不做名字解析和端口解析  
  
更有针对性的抓包：  
  
针对IP，网段，端口，协议  
  
  tcpdump -n -i eth0 -vnn host 192.168.0.154 --主机地址里边只要包含地址有：192.168.0.154  
  
  tcpdump -i eth0 -vnn net 192.168.0.0 /24 --抓取一个网段数据包  
  
  tcpdump -i eth0 -vnn port 22  
  
  tcpdump -i eth0 -vnn udp  
  
  tcpdump -i eth0 -vnn icmp ping  
  
  tcpdump -i eth0 -vnn arp  
  
---  
  
---  
  
$x = y$$x = y$  # tcpdump -i eth0 -vnn ip  
  
  tcpdump -n -i eth0 -vnn src host 192.168.0.154  
  
  tcpdump -i eth0 -vnn dst host 192.168.0.154  
  
  tcpdump -i eth0 -vnn src port 22  
  
  tcpdump -i eth0 -vnn src host 192.168.0.253 and dst port 22  
  
  tcpdump -i eth0 -vnn src host 192.168.0.154 or port 22  
  
  tcpdump -i eth0 -vnn src host 192.168.0.154 and not port 22  
  
抓包最主要的功能在于调试，比如在调试某个服务的时候 明明服务起来了 但是不知道为什么链接不上 可以通过抓包工具来测试看看请求包有没有过来服务器，来判断是传输过程中失败了 还是被服务器拒绝了  
  