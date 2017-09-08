### 介绍LNMP nginx+mysql+php  
#### lnmp最常见的架构
L linux  --系统平台
N nginx  --网站的前端程序，发布静态页面和调用外部程序解析动态页面
M mysql  --网站的后台数据库
P PHP    --网页的变成语言(也可以用python)

工作原理
1. 客户端的所有的页面请求先到达lnmp结构中的nginx
2. nginx根据自己的判断哪些是静态页面，哪些是动态页面
3. 如果是静态页面直接由nginx自己处理就可以返回结果给客户端了
4. 如果*.php动态页面nginx需要调用php中间件服务器来处理
5. 在处理PHP页面的过程中可能需要调用mysql数据库中的数据完成页面编译
6. 编译完成后的页面返回给nginx，nginx再返回给客户端

#### nginx  
ngin是http服务器软件，nginx的特点是处理速度非常快，占用的资源很少。功能上nginx模块全部是静态编译的，也就是说如果需要处理动态的编译需要安装其他软件来完成动态的编译  
#### nginx的的优势  
作为web服务器处理静态文件，索引文件，自动索引的效率非常高  
作为代理服务器，可以实现无缓存的反向代理，提高网站运行速度  
作为负载均衡服务器，可以在内部直接支持rails和php等  
性能方面，采用epoll模型，可以支持多并发并且占用低内存  
稳定方面，采取分段资源分配技术，CPU和内存占用率非常低,少量的dos攻击对nginx基本无作用，  
高可用方面,支持热部署，启动迅速，可以在不间断服务的情况下，直接升级7x24小时不间容灾  
#### nginx的模块和工作原理  
nginx由内核和模块组成，模块结构分为核心模块，基础模块，第三方模块  
核心模块: http模块，event模块，mail模块  
基础模块: http fastCGI模块，http proxy模块，http rewrite模块  
第三方模块: http upstream request hash 模块，notice模块，htttp access key 模块  
模块从功能上分为如下三类:  
Handlers(处理器模块):直接处理请求，并进行输出内容和修改headers信息操作只有一个  
Filters(过滤模块)：主要对其他处理器模块输出的内容进行修改操作，最后由nginx输出案例故障汇总  
Proxies(代理类模块):主要与后端一些服务比如FastCGI进行交互，实现代理和负载均衡  
在工作方式上:  
单工作进程(默认):除主进程外，还有一个工作进程  
多工作进程:每个进程包含多个线程  
nginx模块之间被编译金nginx，因此属于静态编译方式，然后将模块编译为一个so文件，在配置文件中指定是否加载  
nginx模块的HTTP请求和响应过程图如下:  
![](http://note.youdao.com/yws/api/personal/file/341C217EEE6B405381070ECFA0BD8EB4?method=download&shareKey=7078b3cb7c1894d4fc8f84604a74de52)  
![](http://note.youdao.com/yws/api/personal/file/B550D8A382FB4412A1301818055D9845?method=download&shareKey=c5aa13b6d7f33039323e43936053a91d)  
#### nginx进程理解 分发  
nginx进程  
nginx启动后。在linux系统中以Daemon的方式在后台运行，后台进程包含一个master进程和多个work进程，默认以多进程方式  
master管理work 外界的信号都是发给master，再由master分配给work进程  
#### master进程  
1. 管理work进程  
2. 外界的信号都是发给master，再由它分配给work进程  
3. 监控work的运行状态，如发生异常，重新启动新的进程  

#### work进程  
1. work之间是对等的  
2. 基本的网络请求都是在work中进行  
3. 一个请求只能在一个work进程中进行  
4. 一个work进程也不能处理其他进程的请求  
5. work进程的个数是可设置的，一般跟CPU核数相同  
  
  
master进程主要用来管理worker进程，具体包括如下4个主要功能  
1. 接收来自外界的信号  
2. 向各worker进程发送信号  
3. 监控woker进程的运行状态  
4. 当woker进程退出后(异常情况下)，会自动重启新的woker进程  
woker进程主要用来处理网络时间，各个woker进场之间是对等且相互独立的，他们同等竞争来自客户端的请求，一个请求只可能在一个worker进程中处理，woker进程个数一般设置为机器CPU核数  
  
nginx安装 一种是源码安装 一种是rpm包安装  
首先看看源码安装 http://nginx.org  
yum -y install pcre-devel <pcre可以使nginx支持http-rewrite模块>  
tar xvf nginx-1.11.0.tar.gz  
cd nginx-1.11.0  
./configure --with-http_stub_status_module  
--prefix=/usr/local/service/nginx  
--with-http_gzip_static_module  
make && make install  
--with-http_stub_status_module 可以启动nginxstatus功能，以监控nginx当前状态  
### 利用TCMalloc优化nginx的性能 扩张知识  
TCMalloc是谷歌的开源工具google-perftools的成员，它可以在内存分配效率和速度上高很多，可以很大程度提高服务器在高并发情况下的性能，从而降低系统的负载  
1.安装libunwind库，libunwind-0.99-alpha.tar.gz  
tar xvf cd ./configure maek make install  
2.安装google-perftools  
tar xvf gperftools-2.1.tar.gz  
cd ./config make && make install  
echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf  
ldconfig  
至此，google-perftools安装完成  
###nginx启动与关闭  
#### #检查语法  
/usr/loacal/service/nginx/sbin/nginx -t  
#### #平滑重启  
/usr/local/service/sbin/nginx -s reload  
#### #不间断服务器重启，将pid行程重跑(restart)  
kill -HUP `cat /opt/nginx/logs/nginx.pid`  
#### 关闭  
kill 进程号  
##nginx定时切割日志脚本  
1.创建脚本 /usr/local/service/nginx/sbin/cut_nginx_log.sh  
#!/bin/bash  
logs_path="/opt/nginx/logs"  
mkdir -p ${logs_path}$(date-d"yesterday" +"%Y")/$(date  
-d"yesterday" +"%m")/  
mv ${logs_path}access.log ${logs_path}$(date-d"yesterday"  
+"%Y")/$(date-d "yesterday" +"%m")/access_$(date-d "yesterday"+"%Y%m%d").log  
kill -USER1 ·cat /opt/nginx/logs/nginx.pid·  
  
方法二  
cd /usr/local/service/nginx/logs  
/bin/mv access.log access_$(date+%F -d -1day).log  
/usr/local/service/nginx -s reload  
###添加到定时任务  
crontab -e  
30 19 * * * /bin/sh cut.nginx.log > /dev/null 2>&1  
###mysql  
班级 1班 2班 3班 4班 2000个班 名字 马聪 条件 结果 索引  
班级表 300  
1班 2班 3班  
学员表 300  
马聪 1班 alisa 2班 奋斗 9班  
学号表 300  
马聪 001 alisa 002 奋斗 009  
linux 1G 文件 vim 一个1G的文件 读取一个G的内存  
马聪 001 1班  
mysql是一个开放源码的小型关联式数据库管理系统，mysql被广泛应用在internet上的中小型网站中，由于其体积小，速度快，总体拥有成本低，尤其是开发源码这一特点，让非常多的中小型网站为了降低网站总体的成本而选择了mysql作为网站数据库    
存储引擎  
  
安装  
1.可以直接使用yum源安装 yum -y install mysql-server  
2.可以使用二进制软件安装  
安装完成后设置密码  
/usr/loacl/service/mysql/bin/mysqladmin -u root password 'tanzhouawen'  
-- 主要登录mysql -u -p不需要空格  
mysql -uroot -p'tanzhouawen'  
删除数据库test  
drop databases test;  
最后查看数据库表格  
select user,host from mysql.user;  
###删除数据库  
drop database user;  
###删除表用户出现无法删除的解决方法  
delete from mysql.user where user='root' and host='Apache';  
###建立mysql账号  
groupadd mysql  
useradd mysql -g mysql -M -s /sbin/nologin  
tail -1 /etc/passwd  
mysql:x:501:501::/home/mysql:/sbin/nologin  
###初始化数据库  
###创建数据目录并且初始化  
/bin/mysql_install_db -user=mysql  
###启动和关闭mysql  
建议使用mysqld_safe命令启动，因为该命令添加了安全特性，当服务器发生错误时自动重启并且把运行信息记录错误发送到日志文件，命令格式如下:  
mysqld_safe options  
命令的常用选项说明说下:  
--datadir=path 数据文件的目录位置  
--help 显示命令的帮助信息  
--log-err=file_name 将错误信息记录到指定文件中  
--nice=priority 执行mysql进程优先级别  
--open-files-limit=count 设置mysql允许打开的最大文件数  
--pid-file=file_name 设置进程ID文件的位置  
--port=number 设置mysql服务器的监听端口  
--usr={user_name|user_id} 指定运行mysql 进程的用户  
启动 mysql  
/usr/local/service/mysql/bin/mysqld_safe &  
ps -ef |grep mysql  
关闭mysql  
kill -9 命令无法杀死mysql进程 因为mysqld_safe 会自动重启  
正确关闭命令如下:  
/usr/local/mysql/bin/mysqladmin shutdown  
检查mysql服务状态  
/usr/local/mysql/bin/mysqladmin stauts  
更改mysql管理员口令  
mysqladmin -uroot passwd 新口令  
登录mysql  
./mysql -uroot -p  
enter password：新口令  
防止误操作mysql数据库技巧  
mysql --hlep |grep dummy  
-U i-am-a-dummy synonym for option --safe-updates, -U  
在mysql命令加上选项-U后，当发出没有where或LIMIT关键字的UPDATE或DELETE时 mysql程序就会拒绝执行  
也可以做成别名  
做成别名防止同事和DBA误操作  
alias mysql='mysql -U'  
echo "alias mysql='mysql -U'" >>/etc/profile  
./etc/profile  
tailf -l /etc/profile  
总结 备份  
当mysql命令加上选项-U后，当发出没有where或limit关键字的UPDATA或者DELETE时，mysql程序拒绝执行  
mysql主从复制部署  
主从复制可以做什么  
1. 数据的分布  
2. 负载均衡 |读写分离  
3. 可以实现数据的备份  
4. 高可用性和容错行  
主从复制就三个步骤  
1. 从master服务器将改变的数据记录到二进制日志中(这些记录叫做二进制日志事件)  
2. slave服务器将master服务器上的二进制日志拷贝到自己的中继日志中  
3. slave服务器读取中继日志中的时间，然后将改变的数据写入到自己的数据库中  
配置注意事项  
1.master服务器必须开启二进制日志  
2.master和slave的server-id不能相同  
3.同一个master的多个slave，server-id也不能相同  
4.binlog_format最好相同  
5.在slave服务器上配置log-slave-updates=1时，也需要开启二进制日志，如果可以推荐使用read_only选项，改选项会阻止没有权限的线程修改数据  
###推荐一个工具可以在不重启数据库的情况下做主从和备份  
xtrabackup优点  
可以快速可靠的完成数据备份（复制数据文件和追踪事务日志）  
数据备份过程中不会中断事务的处理(热备份)  
节约磁盘空间和网络带宽  
自动完成备份鉴定 检查备份的完整性  
因更快的恢复时间而提高在线时间  
  
http://blog.csdn.net/dyllove98/article/details/41120789  
 