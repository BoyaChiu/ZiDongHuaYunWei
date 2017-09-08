## 作业二

---

### Date： 2017-03-04     By author：chiu

### 课堂笔记整理

* ping    测试主机是否存活

```shell
[root@vagrant-centos65 ~]# ping IP地址
参数：
-c：次数
-s：数据包的大小
-i：间隔（单位秒）
```

* ip addr  和 ifconfig   查看 ip 地址

```shell
[root@vagrant-centos65 ~]# ifconfig
[root@vagrant-centos65 ~]# ip addr
```

* top   动态方式查看进程状态

```shell
[root@vagrant-centos65 ~]# top
参数：
h：显示帮助画面，给出一些剪短的命令总结说明
k：终止一个程序。系统将提示用户输入需要终止的进程PID，以及需要发送给该进程什么样的信号。一	  般的终止进程可以使用 15 信号；如果不能正常结束那就使用信号 9 强制结束该进程。默认值是    信号15.在安全模式中此命令被屏蔽
m：切换显示进程和 CPU 状态信息
t：切换显示进程和 CPU 状态信息
c：切换显示命令名称和完整命令行
M：根据驻留内存大小进行排序
P：根据 CPU 使用百分比大小进行排序
T：根据时间 V 累计时间进行排序
W：将当前设置写入 ~/.toprc 文件中。这是写 top 配置文件的推荐方法
```

* ps  查看进程状态   以静态的方式

```txt
参数：
-a：显示其他用户启动的进程
-u:启动这个进程的用户和它启动的时间
-x：查看系统中属于自己的进程
-f：显示进程的父子关系
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
ps -elf
-e：   显示所有进程
-l：   长格式
-f：   全格式
找出内存消耗最多的前 10 名进程
ps -auxf | sort -nr -k | head -10
找出使用 CPU 最多的前 10 名进程
ps -auxf | sort -nr -k 3 | head -10
```

* netstat  查看本机开放的端口

```txt
-t tcp连接
-u udp
-n  不作反解
-l  侦听
-p  进程号
-a 所有
netstat -anp    TCP/UDP/socket监听列表，对应网络连接列表
netstat -tnp    TCP 的网络连接状态
netstat -tnlp   所有 TCP 的侦听列表
netstat -unp    UDP 的网络连接
netstat -unlp   UDP 的侦听列表
netstat -tunlp  TCP/UDP 侦听列表
netstat -rn     查询路由表
UNIX/类UNIX有三种连接：
1.TCP 面向连接
2.UDP 面向无连接
3.socket 通常也称作“套接字”，应用程序通常通过“套接字”相网络发出请求或者应答网络请求
```

* nmap  端口扫描工具

```txt
nmap -p1 -65535 			   iptables 扫描 1-65535 所有的端口
nmap -PS 172.16.85.0/24		   扫描网段中所有已激活的主机的端口，IP 地址和 MAC地址
nmap -sO 192.168.1.19     	   确定目标机支持哪些协议 IP （TCP,ICMP,IGMP等）
namp -O 172.16.85.14           扫描目标主机的操作系统
```


### 常用指令的安装及使用

#### iostat

​	iostat通过观察设备的活跃时间和他们平均传输率之间的关系来监视系统的输入/输出设备负载。iostat生成的报告可以用于修改系统配置从而更好在物理硬盘间平衡输入/输出的报告。

```txt
安装 iostat
在 redhat / CentOS / Fedora
# yum install sysstat

在 Debian / Ubuntu / Linux Mint
$ sudo apt-get install sysstat
```

```txt
iostat
参数：
-O：只显示 I/O 操作进程
-b：批量显示，无交互，主要用作记录到文件
-n NUM：显示 NUM 次，主要用于非交互式模式
-d SEC：间隔 SEC 秒显示一次
-p PID：监控的进程 PID
-u USER：监控的进程用户

iotop 找出使用 I/O 最高的应用程序
iotop 常用快捷键：
左右箭头：改变排序方式，默认是按 I/O 排序
r：改变排序顺序
O：只显示有 I/O 输出的进程
p:进程 V 线程的显示方式的切换
a：显示累计使用量
q:退出
```

读取 iostat 信息

```shell
[root@vagrant-centos65 ~]# iostat
Linux 2.6.32-431.3.1.el6.x86_64 (vagrant-centos65.vagrantup.com)        03/04/2017      _x86_64_        (1 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.31    0.09    0.25    0.27    0.00   99.08

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda               0.64        25.60        12.93     334738     169064
sdb               0.04         0.33         0.00       4264          0
```

第一部分包含了 CPU 报告

* %user：显示了在执行用户（应用）层时的 CPU 利用率
* %nice：显示在以 nice 优先级运行用户层的 CPU 利用率
* %system：显示在执行系统（内核）层时的 CPU 利用率
* %iowait：显示 CPU 在 I/O 请求挂起时空闲时间的百分比
* %steal：显示了当 hypervisor 正服务于另一个虚拟处理器时无意识地等待 CPU 所占用的时间百分比
* %idle：CPU 在 I/O 没有挂起请求时空闲时间的百分比

第二部分包含设备利用率报告

* Device：列出的 /dev 目录下的设备/分区名称
* tps：显示每秒传输给设备的数量。更高的 tps 意味着处理器更忙
* Blk_read/s：每秒从设备上读取的块的数量（KB,MB）
* Blk_wrtn/s：每秒写入设备上的块的数量（KB,MB）
* Blk_read：显示所有已读的块
* Blk_wrtn：显示所有写入的块

以 KB 或 MB捕捉 iostat

​	默认上，iostat 以 B 为单位衡量 I/O 系统。为了更便于阅读，我们可以 iostat 将报告转成以 KB 或者 MB为单位。只需要加入 -k 参数老创建以 KB 为单位，-m参数来创建以 MB 为单位。如下

```shell
[root@vagrant-centos65 ~]# iostat -k
Linux 2.6.32-431.3.1.el6.x86_64 (vagrant-centos65.vagrantup.com)        03/04/2017      _x86_64_        (1 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          30.23    0.00   12.59    0.14    0.00   57.04

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda               0.40         9.64         8.16     166381     140880
sdb               0.03         0.12         0.00       2132          0
```

```SHELL
[root@vagrant-centos65 ~]# iostat -m
Linux 2.6.32-431.3.1.el6.x86_64 (vagrant-centos65.vagrantup.com)        03/04/2017      _x86_64_        (1 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          30.17    0.00   12.56    0.14    0.00   57.13

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda               0.41         0.01         0.01        162        140
sdb               0.03         0.00         0.00          2          0
```

要扩展报告，我们可以在 iostat 后面跟上 -x选项

```shell
[root@vagrant-centos65 ~]# iostat -x
Linux 2.6.32-431.3.1.el6.x86_64 (vagrant-centos65.vagrantup.com)        03/04/2017      _x86_64_        (1 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          30.03    0.00   12.51    0.14    0.00   57.32

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.10     1.90    0.24    0.17    19.15    16.53    88.02     0.01   22.21    8.59   41.45   5.55   0.23
sdb               0.00     0.00    0.03    0.00     0.25     0.00     8.49     0.00    1.24    1.24    0.00   1.23   0.00
```

iostat 的一些参数说明：

```txt
iostat -c 1 10         # 获取 CPU 状态
$iostat -d -k 1 10     # 查看 TPS 和吞吐量
iostat -d -x -k 1 10   # 查看设备使用率（%util）、响应时间（await）
```



### rz / sz     

​	rz、sz 是 Linux/Unix 同 Windows 进行 Zmodem 文件传输的命令行工具。优点：不再开一个sftp工具登入上去上传下载文件。

​	rz：运行该命令会弹出一个文件选择窗口，从本地选择文件上传到Linux服务器
​		安装命令

​	sz：将选定的文件发送（send）到本地机器

​	

* 编译安装

  root 账户登录后，依次执行以下命令：

```shell
cd /tmp
wget http://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz
tar zxvf lrzsz-0.12.20.tar.gz && cd lrzsz-0.12.20
./configure && make && make install
```

​	上面安装过程默认把 lsz 和 lrz 安装到了 `/usr/local/bin/`目录下，现在我们不能直接使用，下面创建软链接，并命名为 rz/sz

```shell
cd /usr/bin
ln -s /usr/local/bin/lrz rz
ln -s /usr/local/bin/lsz sz
```

* yum 安装

  root 账户登入后执行以下命令：

  ```shell
  yum install -y lrzsz
  ```

使用方法：

​	sz 命令发送文件到本地：

```shell
# sz filename
```

​	rz 命令本地上传到服务器：

```shell
# rz
```

​	执行命令后，在弹出框中选择要上传的文件即可

SecureCRT设置默认路径：
Options -> Session Options -> Terminal -> Xmodem/Zmodem ->Directories

Xshell设置默认路径：
右键会话 -> 属性 -> ZMODEM -> 接收文件夹

注意：SecureCRT可以方便的上传下载文件，而Xshell没有菜单选择



### netstat

​	`netstat`命令英语显示各种网络相关信息，如网络连接、路由表接口状态（Interface  Statistics），masquerade连接，多播成员（Multicast Memberships）等等。

``` txt
[root@vagrant-centos65 ~]# netstat
常用参数：
-a：（all）显示所有选项，默认不显示LISTEN相关
-t：（tcp）仅显示 tcp 相关选项
-u：（udp）仅显示 udp 相关选项
-l：仅列出有在 Listen（监听）的服务状态

-p：显示简历相关链接的程序名
-r：显示路由信息，路由表
-e：显示扩展信息，例如 uid 等
-s：按各个协议进行统计
-c：每隔一个固定时间，执行该 netstat 命令
注：LISTEC 和 LISTENING 的状态只有用 -a 或者 -l 才能看到
```

用法如下：

* 列出所有端口号（包括监听和未监听）

```shell
# netstat -a      列出所有端口
# netstat -at      列出所有 tcp 端口
# netstat -au      列出所有 udp 单口
```

* 列出所有处于监听状态的 sockets

```shell
# netstat -l      只显示监听端口
# netstat -lt     只列出所有监听 tcp 端口
# netstat -lu     只列出所有监听 udp 端口
# netstat -lx     之列吃所有监听 UNIX 端口
```

* 显示每隔协议的统计信息

```shell
# netstat -s      显示所有端口的统计信息
# netstat -st      显示 tcp 端口的统计信息
# netstat -sc      显示 udp 端口的统计信息
```

* 在 netstat 输出中显示 PID 和进程名称 

```shell
# netstat -pt
```

* 显示核心路由信息

```shell
# netstat -r
```

* 找出程序运行的端口

  并不是所有的进程都能找到，没有权限的会不显示，使用 root 权限查看所有的信息。

```shell
# netstat -ap | grep ssh
```

* 找出运行在指定端口的进程

```shell
# netstat -an | grep ':80'
```

* 显示网络接口列表

```shell
# netstat -i
```



### ss

​	`ss` 即 socket state，也就是说，是可以查看系统中 socket 的状态的，我们可以用`netstat`的，但为什么还要用 `ss`这个工具呢？当然 `ss`自然有它的优点，当我们打开的 socket 数量很多时，`netstat`就会变得很慢。

​	netstat是遍历/proc下面每个PID目录，ss直接读/proc/net下面的统计信息。所以ss执行的时候消耗资源以及消耗的时间都比netstat少很多

```shell
[root@vagrant-centos65 ~]# ss -h
Usage: ss [ OPTIONS ]
       ss [ OPTIONS ] [ FILTER ]
   -h, --help           this message
   -V, --version        output version information
   -n, --numeric        don't resolve service names
   -r, --resolve       resolve host names
   -a, --all            display all sockets
   -l, --listening      display listening sockets
   -o, --options       show timer information
   -e, --extended      show detailed socket information
   -m, --memory        show socket memory usage
   -p, --processes      show process using socket
   -i, --info           show internal TCP information
   -s, --summary        show socket usage summary

   -4, --ipv4          display only IP version 4 sockets
   -6, --ipv6          display only IP version 6 sockets
   -0, --packet display PACKET sockets
   -t, --tcp            display only TCP sockets
   -u, --udp            display only UDP sockets
   -d, --dccp           display only DCCP sockets
   -w, --raw            display only RAW sockets
   -x, --unix           display only Unix domain sockets
   -f, --family=FAMILY display sockets of type FAMILY

   -A, --query=QUERY, --socket=QUERY
       QUERY := {all|inet|tcp|udp|raw|unix|packet|netlink}[,QUERY]

   -D, --diag=FILE      Dump raw information about TCP sockets to FILE
   -F, --filter=FILE   read filter information from FILE
       FILTER := [ state TCP-STATE ] [ EXPRESSION ]
```

常用的`ss`命令

```txt
ss -l 显示本地打开的所有端口
ss -pl 显示每个进程具体打开的socket
ss -t -a 显示所有tcp socket
ss -u -a 显示所有的UDP socekt
ss -s 列出当前socket详细信息
ss -o state established '( dport = :http or sport = :http )'  列出所有http连接中的连接
ss src ADDRESS_PATTERN    使用IP地址筛选
	src：表示来源       ADDRESS_PATTERN：表示地址规则

ss dport OP PORT     端口筛选
  OP:是运算符
  PORT：表示端口
  dport：表示过滤目标端口、相反的有sport
  OP运算符如下：
  <= or le : 小于等于 
  >= or ge : 大于等于
  == or eq : 等于
  != or ne : 不等于端口
  < or lt : 小于这个端口 > or gt : 大于端口
```

### lsof

​	`lsof`（list open files）是一个列出当前系统打开文件的工具。在[Linux](http://lib.csdn.net/base/linux)环境下，任何事物都以文件的形式存在，通过文件不仅仅可以访问常规数据，还可以访问网络连接和硬件。所以，`lsof`的功能很强大。一般 root 用户才能执行`lsof `命令，普通用户可以看见`/usr/sbin/lsof`命令，但是普通用户执行会显示“permission denied”。因此通过`lsof`工具能够查看这个列表对系统监测以及排错将是很有帮助的。

```shell
# yum -y install losf
```

​	在终端下输入`lsof`即可显示系统打开的文件，因为`lsof`需要访问核心内存和各种文件的身份，来运行它才能够充分地发挥其功能。即需要 root 权限

```shell
[root@vagrant-centos65 ~]# lsof
用法：
lsof abc.txt      显示开启文件abc.txt的进程
lsof directory    查找谁在使用文件目录系统
lsof -i:22        查找22端口被哪个进程占用
lsof -c abc       显示abc进程现在打开的文件
lsof -g gid       显示归属gid的进程情况
lsof -p 12        看进程为12的进程打开了哪些文件
lsof -u username  查看用户打开了哪些文件
lsof -i @192.168.1.111    查看远程已打开的网络连接（连接到192.168.1.111）
```



### Vim 编辑器

将 vi 替换为 vim 

```shell
[root@vagrant-centos65 ~]# echo 'alias vi=vim' >>/etc/profile
[root@vagrant-centos65 ~]# tail -1 /etc/profile
alias vi=vim
[root@vagrant-centos65 ~]# source /etc/profile
```

* vim 路径等配置知识

```txt
.viminfo        				 用户使用 vim 的操作历史
.vimrc           				 当前用户 vim 的配置文件
/etc/vimrc       				 系统全局 vim 的配置文件
/usr/share/vim/vim74/colors/     配色模板文件存放路径   
```

常用 vim 按键说明

```txt
[Ctrl] + [f]: 屏幕向下移动一页，相当于 [Page Down]按键
[Ctrl] + [f]: 屏幕向上移动一页，相当于 [Page Up]按键
0或功能键[Home]: 这是数字“0”，移动到这一行的最前面字符处
$或功能键[End]: 移动到这一行的最后面字符处
G: 移动到这个文件的最后一行
N[Enter]: n为数字。光标向下移动 n 行
:n1,n2s/word1/word2/g    n1和n2为数字。在第n1和n2行之间寻找word1这个字符串，并将该字符串替换为word2。例如：在100到200行之间查找 mac并替换为 MAC则用":10,200s/mac/MAC/g"  
:1,$s/word1/word2/g     从第一行到最后一行查找 word1 字符串，并将该字符串替换为 word2。
:1,$s/word1/word2/gc    从第一行到最后一行查找 word1 字符串，并将该字符串替换为 word2。且在替换前显示提示字符给用户确认（confirm）是否需要替换
x,X:   在一行字中，x 为向后删除一个字符（相当于[Del]按键），X 为向前删除一个字符（相当于[Backspace]）
dd:    删除光标所在的那一行
ndd:   n为数字。删除光标所在的向下n行，例如 20dd 则是删除 20 行
yy:    复制光标所在的那一行
nyy:   n为数字。复制光标所在的向下n行，例如20yy则是复制20行
p,P:   p为将已复制的数据在光标下一行粘贴，P为粘贴在光标上一行。例如：我目前光标在 20 行，且已经复制了 10 行数据。则按下 p 后，那 10 行数据会粘贴在原本的 20 行之后，也即由 21 行开始粘贴。但如果是按下 P 呢？那么原本的第 20 行会被变成 30 行
u:     复原前一个操作
[Ctrl] + r:     重做上一个操作
. :    小数点。重复前一个操作的意思。如果想要重复删除、重复粘贴等操作，按下小数点 "." 就好了

:w         将编辑的数据写入硬盘文件中
:w!        若文件属性为 “只读” 时，强制写入该文件。不过，到底能不能写入，还是跟你对该文件的文件权限有关
:q         离开 vi
:q!        若曾修改过文件，又不想存储，使用 "!" 为强制离开不保存的文件
注意： "!" 在 vi 中具有 “强制” 的意思
wq:        保存后离开，若为 "wq!" 则为强制保存后离开
:set nu    显示行号，设置之后会在每一行的前缀显示改行的行号
:set nonu  与 set nu 相反，为取消行号
```

* bash 环境中一些特殊符号总结

|  符号  |                 内容                 |
| :--: | :--------------------------------: |
|  #   | 批注符号，最常用在 script 当中，视为说明。气候的数据均不执行 |
|  \   |      转义字符，将“特殊字符或通配符”还原成一般字符       |
|  \|  |        管道（pipe），分隔两个管道命令的界定        |
|  ;   |   连续命令执行分隔符，连续性命令的界定（注意：与管道符不同）    |
|  ~   |              用户的主文件夹               |
|  $   |       使用变量前导符，即变量之前需要加的变量替代值       |
|  &   |    作业控制（job control），将命令变成背景下工作    |
|  !   |       逻辑运算意义上的 “非” （not）的意思        |
|  /   |            目录符号，路径分隔的符号            |
| >,>> |      数据流重定向，输出导向，分别是“替换”和“累加”      |
| <,<< |            数据流重定向，输入导向             |
| '  ' |           单引号，不具有变量替换的功能           |
|  ""  |             具有变量置换的功能              |
|  ``  |     两个" ` "中间为可以执行的命令，也可使用$()      |
| (  ) |         在中间为子 shell 的起始与结束         |
| {  } |             在中间为命令块的组合             |

注意：设置文件名时尽量不要用到上述的字符。



### Shell script



* 选取命令cut，grep

```shell
[root@vagrant-centos65 ~]# cut -d'分隔字符' -f fields
[root@vagrant-centos65 ~]# cut -c 字符范围
参数：
-d：后面接分隔字符，与 -f 一起使用
-f：依据 -d 分隔字符将一段信息切割成为数段，用 -f 去除第几段的意思
-c：以字符（characters）的单位取出固定字符区间
```

```shell
[root@vagrant-centos65 ~]# grep [-acinv] [--color=auto] '查找字符串' filename
参数：
-a：将 binary 文件以 text 文件的方式查找数据
-c：计算找到 '查找字符串' 的次数
-i：忽略大小写的不同，所以大小写视为相同
-n：顺便输出行号
-v：反向选择，即显示出 '查找字符串' 内容的那一行
--color=auto：可以将找到的关键字部分加上颜色显示
```

* 排序命令： sort，wc，uniq

```SHELL
[root@vagrant-centos65 ~]# sort [-fbMnrtuk] [file or stdin]
参数：
-f：忽略大小写的差异，例如 A 与 a 视为编码相同
-b：忽略最前面的空格符部分
-M：以月份的名字来排序，例如 JAN, DEC 等的排序方法
-n：使用 “纯数字” 进行排序（默认是以文字类型来排序）
-r：反向排序；
-u：就是 uniq，相同的数据中，仅出现一行代表
-t：分隔符，默认是用 [Tab] 键来分隔
-k：以那个区间（field）来进行排序的意思
```

```shell
[root@vagrant-centos65 ~]# uniq [-ic]
参数：
-i：忽略大小写字符的不同
-c：进行计数
```

```shell
[root@vagrant-centos65 ~]# wc [-lwm]
参数：
-l：仅列出多少行
-w：仅列出多少字（英文单字）
-m：多少字符
```

* 双向重定向：tee

```shell
[root@vagrant-centos65 ~]# tee [-a] file
参数：
-a：以累加（append）的方式，将数据加入 file 当中
```

* 字符转换命令：tr，col，join，paste，expand

```shell
[root@vagrant-centos65 ~]# tr [-ds] SET1 ...
参数：
-d：删除信息当中 SET1 这个字符串
-s：替换掉重复的字符
```

```shell
[root@vagrant-centos65 ~]# col [-xb]
参数：
-x：将 tab 键转换成对等的空格键
-b：在文字内有反斜杠（/）时，仅保留反斜杠最后接的那个字符
```

```shell
[root@vagrant-centos65 ~]# join [-ti12] file1 file2
参数：
-t：join 默认以空格符分隔数据，并且对比 “第一字段”的数据，如果两个文件的内容相同，则将两条数据连成一行，且第一份字段放在第一个
-i：忽略大小写的差异
-1：数字1:。代表第一个文件要用哪个字段来分析的意思
-2：代表第二个文件要用哪个字段来分析的意思
注意：在使用 join 之前，所需要处理的文件应该要实现经过排序 （sort）处理，否则有些对比的项目会被略过
```

```shell
[root@vagrant-centos65 ~]# paste [-d] file1 file2
参数：
-d：后面可以接分隔字符、默认是以 [tab] 来分隔的
- ：如果 file 部分写成 - ，表示来自 standard input 的数据的意思
```

```shell
[root@vagrant-centos65 ~]# expand [-t] file
参数：
-t：后面可以接数字。一般来说，一个 [tab] 按键可以用 8 个空格键替换，我们也可以自行定义一个 [tab] 按键代表多少个字符
```

* 切割命令：split

```shell
[root@vagrant-centos65 ~]# split [-bl] file PREFIX
参数：
-b：后面可接欲切割成的文件大小，可加单位，例如 b，k，m 等
-l：以行数来进行切割
PREFIX:代表前导符，可作为切割文件的前导文字
```

* sed 工具

```shell
[root@vagrant-centos65 ~]# sed [-nefr] [动作]
参数：
-n：使用安静（silent）模式。在一般 sed 的用法中，所有来自 STDIN 的数据一般都会被列出到屏幕上。但如果加上 -n 参数后，则只有经过 sed 特殊处理的那一行（或者操作）才会被列出来
-e：直接在命令行模式上进行 sed 的动作编辑
-f：直接将 sed 的动作支持写在一个文件内， -f filename 则可以执行 filename 内的 sed 动作
-r：sed 的动作支持的是扩展型正则表达式的语法（默认是基础正则表达式语法）
-i：直接修改读取的文件的内容，而不是由屏幕输出
动作说明：  [n1[,n2]]function
n1, n2:不见得会存在，一般代表选择进行动作的行数，举例说，如果我的动作是需要在 10 到 20 行之间进行的，则“ 10,20[动作行为]”

function 有下面这些参数:
a	：新增，a 的后面可以接字符串，而这些字符串会在新的一行出现（目前的下一行）
c	：替换，c 的后面可以接字符串，这些字符串可以替换 n1，n2之间的行
d	：删除，因为是删除，所以 d 后面通常不接任何参数
i	：插入，i 的后面可以接字符串，而这些字符串会在新的一行出现（目前的上一行）
p	：打印，也就是将某个选择的数据打印出来。通常 p 会与参数 sed -n 一起运行
s	：替换，可以直接进行替换的工作。通常这个 s 的动作可以搭配正则表达式！例如 1,20s/old/new/g 就是。
```

* awk工具

```shell
[root@vagrant-centos65 ~]# awk '条件类型1{动作1} 条件类型2{动作2} ...' filename
```

​	`awk`后面接两个单引号并加上大括号{}来设置想要对数据进行的处理动作。`awk`可以处理后续接的文件，也可以读取来自前个命令的 standard output 。但如前面所说，`awk`主要是处理每一行的字段内的数据，而默认的字段的分隔符为空格键或 [tab] 键。



### 作业

---



### 总结：

​	1.当发现有程序或脚本占用 cpu 或内存比较高时，可以输入命令 `top` 来动态的查看 CPU 的占用情况，还可以用 `free -m` 命令查看内存使用情况，若为不正常的程序，可以用   `ps aux` 命令来找到脚本的路径，必须与研发部门沟通后，寻求是否能强杀，若能强杀，则用 `kill PID` 来强杀。其中老师上课讲了两个比较重要的命令：

* `ps -auxf | sort -nr -k 4 | head -10`        找出消耗内存最多的前10名进程

* `ps -auxf | sort -nr -k 3 | head -10`        找出使用CPU最多的前10名进程

  ​

  2.当出现 I/O 比较高时，可有 iostat 命令来查看，详细参数见上文内容

  ​

  3.当网络流量异常时，监控网卡流量可以用 `iftop` 命令，还可以用`nethogs eth0`查看进程使用的具体流量情况

  ​

  4.`ss`命令快速的显示活动状态的套接字

  ​

  5.最后还讲解了基本的 shell 脚本语法



### 获取本机的IP 

老师提供的方法：

```shell
[root@vagrant-centos65 ~]# ifconfig eth0 |grep Bcast |cut -d ":" -f2|cut -d " " -f1
192.168.191.2
[root@vagrant-centos65 ~]# ifconfig |grep Bcast |awk -F'[ :]+' '{print $4}'
192.168.191.2
```

其它方法：

```shell
[root@vagrant-centos65 ~]# ifconfig |grep "inet addr:" |grep -v "127.0.0.1" |cut -d: -f2 |awk '{print $1}'
192.168.191.2
[root@vagrant-centos65 ~]# ifconfig -a |grep inet |grep -v 127.0.0.1 |grep -v inet6|awk '{print $2}' |tr -d "addr:"
192.168.191.2
[root@vagrant-centos65 ~]# ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'
192.168.191.2
```



### 启动Mysql脚本

```shell
#/bin/bash
#init
Port=3306
MysqlUser="root"
MysqlPass="123456"
CmdPath="/application/mysql/bin"

#startup fnction
start()
{
	if [ `netstat -lnt|grep "$Port"|wc -l` -eq 0 ]
		then
			printf "Starting Mysql...\n"
			/bin/sh ${CmdPath}/mysqld_safe --defaults-file=/data/${Port}/my.conf2>&1 > /dev/null &
	else
		printf "Mysql is running...\n"
	fi
}

#stop function
stop()
{
	if [ ! `netstat -lnt|grep "$Port"|wc` -l -eq 0]
		then
			printf "Stopping Mysql...\n"
			${CmdPath}/mysqladmin -u ${MysqlUser} -p${MysqlPass} -s /data/${Port}/mysql.sock shutdown
	else
		printf "Mysql is stopped...\n"
	fi
}

#restart funcation
restart()
{
	printf "Restarting Mysql...\n"
	stop
	sleep 2
	start
}

case "$1" in
start)
	start
	;;
stop)
	stop
	;;
restart)
	restart
	;;
*)
	printf "Usage: $0 {start|stop|restart}\n"
esac
```



