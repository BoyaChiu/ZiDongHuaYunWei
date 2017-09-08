#### 优化机器  
profile  
此文件为系统的每个用户设置环境变量，当用户第一次登陆时，改文件被执行，并从/etc/profile.d的目录的配置文件中搜集shell的设置  
1. 设置环境变量  
2. 执行启动脚本  
3. 执行iptables  
sed -i "/LANG=zh_CN\.UTF\-8/d" /etc/profile  
修改语言编码  
sed -i "/export\ LANG=/d" /etc/profile  
echo "export LANG=zh_CN.UTF-8">>/etc/profile  
追加一条代码到我们的profile  
sed -i '/export\ PATH/d' /etc/profile  
echo "export PATH">>/etc/profile  
sed -i '/ulimit -SHn/d' /etc/profile  
echo 'ulimit -SHn 65535' >>/etc/profile  
设置我们当前系统打开的文件数目以及文件数量 log  
sed -i '/export HISTTIMEFORMAT=/d' /etc/profile  
echo 'export HISTTIMEFORMAT=" [%Y-%m-%d %H:%M:%S] "' >>/etc/profile  
source /etc/profile  
ulimit -SHn 65535  
### 内核优化 制作RPM包  
### 调整内核优化  
所谓的内核优化，主要是在linux中针对业务服务器应用而进行的系统内核参数优化，优化合并特殊的标准，我这边以常见生产环境linux的内核优化为例讲解，仅供大家参考  
内核调优  
\#vi /etc/sysctl.cof  
net.ipv4.tcp_fin_timeout=2  
\#表示套接字由本端要求关闭，这个参数决定了他保持在FIN-WAIT-2状态的时间  
net.ipv4.tcp_tw_reuse=1  
\#表示开启重用，允许TIME=WAIT sockets重新用于新的TCP链接，默认为0，关闭  
net.ipv4.tcp_tw_recycle=1  
\#表示开启TCP连接中TIME=WAITsockets的快速回收,默认为0，表示关闭  
net.ipv4.tcp_syncookies=1  
\#表示开启syn cookies，当出现SYN等待队列溢出时，启用cookies来处理可以防范少量syn攻击，默认为0，表示关闭  
net.ipv4.tcp_keepalive_time=600  
\#表示当keepalive起用的时候，TCP发送keepalive消息的频度。缺省是2小时，改为10分钟  
net.ipv4.ip_local_port_range=4000 65000  
\#表示用于向外连接的端口范围。缺省情况下过窄：32768到61000，改为1024到65535。  
net.ipv4.tcp_max_syn_backlog= 16384  
\#表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数  
net.ipv4.tcp_max_tw_buckets= 36000  
\#表示系统同时保持TIME_WAIT套接字的最大数量，如果超过这个数字，TIME_WAIT套接字将立刻被清除并打印警告信息。默认为180000,可适当增大该值，但不建议减小。对于Apache、Nginx等服务器，以上几行参数的设置可以很好地减少TIME_WAIT套接字数量，但是对于Squid，效果却不大。此项参数可以控制TIME_WAIT套接字的最大数量，避免Squid服务器被大量的TIME_WAIT套接字拖死  
  
---  
net.ipv4.route.gc_timeout= 100  
\#路由缓存刷新频率， 当一个路由失败后多长时间跳到另一个  
net.ipv4.tcp_syn_retries=1  
\#对于一个新建连接，内核要发送多个个SYN连接请求才决定放弃，不应该大于255 默认值是5对应于180s左右  
net.ipv4.tcp_synack_retries=1  
\#syn-ack握手状态重试次数，默认5，遭受syn-flood攻击时改为1或2  
net.core.somaxconn=16384  
\#修改socket监听的backlog上限，backlog就是socket的监听队列，当一个请求尚未被处理或者建立适合，他会进去backlog，而scoketserver可以一次性处理backlog里面所有的请求，处理后的请求不再位于监听队列里面，当server处理请求过慢时，新的请求会被拒绝  
net.core.netdev_max_backlog=16384  
\#每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目  
net.ipv4.tcp_max_orphans=16384  
\#系统中最多有多少个TCP 套接字不被关联到任何一个用户文件句柄上。如果超过这个数字，孤儿连接将即刻被复位并打印出警告信息。这个限制仅仅是为了防止简单的DoS 攻击，不能过分依靠它或者人为地减小这个值，更应该增加这个值(如果增加了内存之后)。  
net.ipv4.ip_conntrack_max=25000000  
\#设置让linux支持最大网络连接数  
net.ipv4.netfilter.ip_conntrack_max=25000000  
\#链接跟踪表最大数目  
net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=180  
\#链接跟踪表保存时间，单位：秒  
  
---  
如果出现大量的TIME_WAIT的错误 需要改变下面的三个参数  
net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait=120  
net.ipv4.netfilter.ip_conntrack_tcp_timeout_close_wait=60  
net.ipv4.netfilter.ip_conntrack_tcp_timeout_fin_wait=120  
---  
kernel.msgmnb = 65536  
每个消息队列的最大字节限制  
kernel.msgmax = 65536  
每个消息的最大size.  
kernel.shmmax = 68719476736  
内核参数定义单个共享内存段的最大值  
kernel.shmall = 4294967296  
参数是控制共享内存页数  