备份/还原:  
冷备：需要停止当前正在运行mysqld,然后直接拷贝或打包数据文件  
  
```  
半热备：mysqldump＋binlog －－适合数据量比较小的应用  
  
在线热备：AB复制 －－实时备份  
```  
  
第一种冷备（物理备份）  
1.停掉mysql服务器  
2.拷贝数据  
cd /data  
tar cjvf /tmp/mysql\_bak.tar.bz2 ./  
  
3.测试还原（只需要把原来备份的文件拷贝回来即可）  
  
第二种逻辑备份mysqldump（mysqld必须是运行着，不需要停掉mysql服务,但需要锁表）：  
逻辑备份＝表结构＋数据（插入）  
  
mysqldump  
1、备份一张表或多张表  
2、备份一个或多个库  
3、备份所有的库  
  
Usage: mysqldump \[OPTIONS\] database \[tables\]  
OR mysqldump \[OPTIONS\] --databases \[OPTIONS\] DB1 \[DB2 DB3...\]  
OR mysqldump \[OPTIONS\] --all-databases \[OPTIONS\]  
  
# mysqldump -uroot -p456 test t1 t2&gt; /tmp/t1.sql --备份单个或多个表  
  
# mysql -uroot -p123 test &lt; /var/tmp/test\_t1.sql 还原test库的t1,t2表  
  
# mysqldump -uroot -p456 --databases test test1 test2 &gt; /tmp/test.sql --备份多个库  
  
# mysqldump -uroot -p456 --all-databases &gt; /tmp/all.sql --备份所有库  
  
还原:  
还原一个表:  
mysql&gt; use test;  
mysql&gt; drop table t1;  
  
# mysql -uroot -p456 test &lt; /tmp/t1.sql  
  
# mysql -uroot -p456 -e "use test; show tables;"  
  
+----------------+  
\| Tables\_in\_test \|  
+----------------+  
\| imptest \|  
\| t1 \|  
+----------------+  
  
还原一个库:  
mysql&gt; drop database test;  
  
# mysql -uroot -p456 -e "create database test;"  
  
# mysql -uroot -p456 test &lt; /tmp/test.sql  
  
# mysql -uroot -p456 -e "show databases;"  
  
+--------------------+  
\| Database \|  
+--------------------+  
\| information\_schema \|  
\| mysql \|  
\| test \|  
  
## +--------------------+  
  
mysqldump --在线备份，需要锁表，效率低。只能备份某个时刻数据状态.  
  
# mysqldump -uroot -p147258369 DB &gt; /tmp/DB.sql --单库  
  
# mysqldump -uroot -p147258369 DB t1 &gt; /tmp/DB.t1.sql --单表  
  
# mysqldump -uroot -p147258369 --all-databases &gt; /tmp/all.sql --全库  
  
恢复:  
  
# mysql -uroot -p123 &lt; /tmp/all.sql  
  
第三种增量数据：  
binlog --记录着mysql服务器增删改的操作记录.  
mysqlbinlog  
--start-datetime=name 开始的时间  
--stop-datetime=name 结束的时间  
--start-position=\# 开始的位置\(POS\)  
--stop-position=\# 结束的位置  
  
mysql&gt; flush logs;  
  
# mysqlbinlog --start-position=190 --stop-position=833 mysqld.000001\|mysql -uroot -p147258369  
  
# mysqlbinlog --start-position=1554 --stop-datetime="2011-09-02 11:48:10" mysqld.000001 \| mysql -uroot -p147258369  
  
## 106-280  
  
备份方案1：  
完全备份\(mysqldump\)+增量备份\(binlog\)  
1、数据总量不大，一般在几百M的数据可以使用这种方法  
2、如果数据量大太，每次备份锁表的时间会比较长，这样就可能影响上层应用正常使用  
  
1.备份  
  
# mysqldump -uroot -p147258369 --flush-logs --master-data=2 --all-databases &gt; /tmp/all2.sql  
  
```  
--flush-logs --备份时先内存中日志写入回磁盘，然后截断日志,并产生新的日志文件  
--master-data=2 --进行全库锁表，并记录当前all2.sql,对应的binlog文件名叫什么  
```  
  
查看完整备份文件中的字段  
  
# vim /tmp/all2.sql  
  
-- CHANGE MASTER TO MASTER\_LOG\_FILE='mysqld.000002', MASTER\_LOG\_POS=106;  
  
2.还原  
  
# mysql -uroot -p147258369 &lt; /tmp/all2.sql  
  
# mysqlbinlog --start-position=106 --stop-datetime="2011-09-02 14:00:20" mysqld.000002 \| mysql -uroot -p147258369  
  
使用脚本备份:  
  
# vim mysql\_backup.sh  
  
# !/bin/bash  
  
name=`date +%Y%m%d-%T`  
  
/usr/bin/mysqldump -uroot -p147258369 --flush-logs --master-data=2 --all-databases &gt; /tmp/$name.sql  
  
crontab -e 设置第天5点钟做备份  
00 05 _ _ \* /bin/sh /var/ftp/notes/scripts/mysql\_backup.sh &&gt; /dev/null  
  
---  
  
AB复制 --主从复制,可以实现在线备份.  
  
主从服务器的作用：  
1、“准“在线备份  
2、负载分担  
  
```  
master-->slave1--slave2  
\-6->slave3  
  
master(binlog)-->slave  
192.168.0.123 192.168.0.254  
```  
  
1、主从机器使用的mysql版本最好一致。  
2、在主服务器上必须启用二进制日志，并且server-id的取值要大于从服务器。  
3、在主服务器上新建一个用于同步binlog的账号。  
4、在主服务器上导出原始数据到从服务器上。  
5、在从服务器上指定主服务器，指定账号、binlog名称、binlog的起始位置\(偏移量\)。  
  
1、主从机器使用的mysql版本最好一致。  
在这个实例中使用的都是mysql官方的RPM包  
  
2、在主服务器上启用二进制日志，并且server-id的取值要大于从服务器。  
  
# vim /etc/my.cnf  
  
server-id=1  
log-bin=/mysql/logs/mysqld  
log-bin-index=/mysql/logs/test\_idx  
  
3、在主服务器上新建一个用于同步数据的账号。  
mysql&gt; grant replication slave,reload,super on _._ to s\_user@'192.168.0.254' identified by '123';  
  
4、在主服务器上导出原始数据到从服务器上。  
master:  
  
# mysqldump -uroot -puplooking --master-data=2 --all-databases &gt; /opt/slave.sql  
  
# scp /opt/slave.sql 192.168.0.254:/opt  
  
# scp /etc/my.cnf 192.168.0.254:/etc/  
  
slave:  
  
# service mysql start  
  
# mysql &lt; /opt/slave.sql --导入数据  
  
# vim /etc/my.cnf  
  
\[mysql\]  
port=3306  
socket=/tmp/mysql.sock  
default-character-set=utf8  
  
\[mysqld\]  
user=mysql  
port=3306  
socket=/tmp/mysql.sock  
datadir=/var/lib/mysql/  
character-set-server=utf8  
sync-binlog=0  
log\_slow\_queries  
long-query-time=1  
innodb\_buffer\_pool\_size = 1G  
innodb\_max\_dirty\_pages\_pct = 90  
innodb\_flush\_log\_at\_trx\_commit = 1  
default-storage-engine=innodb  
server-id=100  
  
# service mysql restart  
  
5、在从服务器上指定主服务器，指定账号、binlog、binlog的起始位置。  
mysql&gt; CHANGE MASTER TO  
-&gt; MASTER\_HOST='192.168.0.123',  
-&gt; MASTER\_USER='s\_use10949r',  
-&gt; MASTER\_PASSWORD='123',  
-&gt; MASTER\_PORT=3306,  
-&gt; MASTER\_LOG\_FILE='mysqld.000007',  
-&gt; MASTER\_LOG\_POS='288',  
-&gt; MASTER\_CONNECT\_RETRY=3;  
  
mysql&gt; start slave;  
mysql&gt; show slave status \G;  
Slave\_IO\_Running: Yes  
Slave\_SQL\_Running: Yes  
Master\_Log\_File: mysqld.000008  
Read\_Master\_Log\_Pos: 610  
Exec\_Master\_Log\_Pos: 610  
  
---  
  
常用的命令:  
start slave  
stop slave  
  
STOP SLAVE IO\_THREAD ;  
STOP SLAVE SQL\_THREAD;  
--&gt;  
Slave\_IO\_Running: Yes  
Slave\_SQL\_Running: No  
  
---  
  
在从服务器上启用binlog:  
vim /etc/my.cnf  
log-slave-updates  
log-bin  
  
链式复制  
A -&gt; B -&gt; C  
也就是说，A为从服务器B的主服务器，B为从服务器C的主服务器。为了能工作，B必须既为主服务器又为从服务器。你必须用--logs-bin启动A和B以启用二进制日志，并且用--logs-slave-updates选项启动B。  
  
C将B当成主服务器来操作  
  
延迟复制（只开IO线程，关闭SQL线程）  
  
关闭IO\_THREAD 或者 SQL\_THREAD  
  
```  
仅仅读的请求。他的数据更新都是根据从主服务器上获得信息进行更新。它会打开两个线程：SQL_THREAD, IO_THREAD。  
IO_THREAD 负责连接主服务器，把相关更新下载回来  
SQL_THREAD 执行下载回来的更新操作。  
```  
  
  
  