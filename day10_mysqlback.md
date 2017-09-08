
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
tar cjvf /tmp/mysql_bak.tar.bz2 ./  
  
3.测试还原（只需要把原来备份的文件拷贝回来即可）  
  
第二种逻辑备份mysqldump（mysqld必须是运行着，不需要停掉mysql服务,但需要锁表）：  
逻辑备份＝表结构＋数据（插入）  
  
mysqldump  
1、备份一张表或多张表  
2、备份一个或多个库  
3、备份所有的库  
  
Usage: mysqldump [OPTIONS] database [tables]  
OR mysqldump [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]  
OR mysqldump [OPTIONS] --all-databases [OPTIONS]  
```  
# mysqldump -uroot -p456 test t1 t2> /tmp/t1.sql		--备份单个或多个表
# mysql -uroot -p123 test < /var/tmp/test_t1.sql            还原test库的t1,t2表

# mysqldump -uroot -p456 --databases test test1 test2 > /tmp/test.sql --备份多个库	

# mysqldump -uroot -p456 --all-databases > /tmp/all.sql	--备份所有库
  
还原:  
还原一个表:  
mysql> use test;
mysql> drop table t1;
# mysql -uroot -p456 test < /tmp/t1.sql 
# mysql -uroot -p456 -e "use test; show tables;" 
  
+----------------+  
| Tables_in_test |  
+----------------+  
| imptest |  
| t1 |  
+----------------+  
  
还原一个库:  
mysql> drop database test;
	
# mysql -uroot -p456  -e "create database test;"
# mysql -uroot -p456 test < /tmp/test.sql 
# mysql -uroot -p456 -e "show databases;"
  
+--------------------+  
| Database |  
+--------------------+  
| information_schema |  
| mysql |  
| test |  
  
## +--------------------+  
```
  
mysqldump --在线备份，需要锁表，效率低。只能备份某个时刻数据状态.  
```
# mysqldump -uroot -p147258369 DB > /tmp/DB.sql		--单库
# mysqldump -uroot -p147258369 DB t1 > /tmp/DB.t1.sql	--单表
# mysqldump -uroot -p147258369 --all-databases > /tmp/all.sql	--全库
```  
恢复:  
```  
# mysql -uroot -p123 &lt; /tmp/all.sql  
```
第三种增量数据：  
binlog --记录着mysql服务器增删改的操作记录.  
mysqlbinlog  
--start-datetime=name 开始的时间  
--stop-datetime=name 结束的时间  
--start-position=# 开始的位置(POS)  
--stop-position=# 结束的位置  
```  
mysql> flush logs;
  
# mysqlbinlog --start-position=190 --stop-position=833 mysqld.000001|mysql -uroot -p147258369  
  
# mysqlbinlog --start-position=1554 --stop-datetime="2011-09-02 11:48:10" mysqld.000001 | mysql -uroot -p147258369  
  
## 106-280  
```  
备份方案1：  
完全备份(mysqldump)+增量备份(binlog)  
1、数据总量不大，一般在几百M的数据可以使用这种方法  
2、如果数据量大太，每次备份锁表的时间会比较长，这样就可能影响上层应用正常使用  
  
1.备份  
```  
# mysqldump -uroot -p147258369 --flush-logs --master-data=2 --all-databases > /tmp/all2.sql
	--flush-logs		--备份时先内存中日志写入回磁盘，然后截断日志,并产生新的日志文件
	--master-data=2	--进行全库锁表，并记录当前all2.sql,对应的binlog文件名叫什么
```  
  
查看完整备份文件中的字段  
```  
# vim /tmp/all2.sql  
  
-- CHANGE MASTER TO MASTER_LOG_FILE='mysqld.000002', MASTER_LOG_POS=106;  
  
2.还原  
  
# mysql -uroot -p147258369 < /tmp/all2.sql
# mysqlbinlog --start-position=106 --stop-datetime="2011-09-02 14:00:20" mysqld.000002 | mysql -uroot -p147258369

使用脚本备份:  
  
# vim mysql_backup.sh 
#!/bin/bash


name=`date +%Y%m%d-%T`

/usr/bin/mysqldump -uroot -p147258369 --flush-logs --master-data=2 --all-databases > /tmp/$name.sql

crontab -e	设置第天5点钟做备份
00 05 * * * /bin/sh /var/ftp/notes/scripts/mysql_backup.sh &> /dev/null
```  
---  
  
### AB复制 --主从复制,可以实现在线备份.  
* mysql 复制介绍
将某一台主机上的 Mysql 数据复制到其它主机(slaves)上，并重新执行一遍从而实现当前主机上的 mysql数据与(master)主机上数据保持一致的过程我们可以称为复制。复制过程中一个服务器充当主服务器，而一个或多个其它服务器充当从服务器。主服务器将更新写入二进制日志文件，并维护文件的一个索引以跟踪日志循环。这些日志可以记录发送到从服务器的更新。当一个从服务器连接主服务器时，它通知主服务器从服务器在日志中读取的最后一次成功更新的位置。从服务器接收从那时起发生的任何更新，然后封锁并等待主服务器通知新的更新
* mysql复制能解决什么问题
1. 数据的分布(data Distribution)
2. 负载均衡| mysql 读写分离
3. 可以实现数据的备份，但是不能当真正意义上数据备份来用
4. 高可用性和容错性(比如双主模式中的互为主从能实现高可用)

* mysql主从复制原理
![mysql原理图](http://img.my.csdn.net/uploads/201202/28/0_1330439010P7lI.gif)

* 步骤
1. 在Master服务器将改变的数据记录到二进制日志(binary log)中(这些记录叫做二进制日志事件)
2. Slave 服务器将 Master 服务器上的二进制日志拷贝到自己的中继日志(relay-log)中
3. Slave 服务器读取中继日志中的事件，然后将改变的数据写入到自己的数据库中

* 流程  
第一步：是在 Master 服务器上记录二进制日志。在每个更新数据的事务完成之前，Master 服务器都会将数据更改记录到二进制日志中。即使事务在执行期间是交错的，Mysql 也会串行地将事务写入到二进制日志中。在把事件写入二进制日志之后，Master 服务器告诉存储引擎可以提交事务了  
第二步：是 Slave 服务器把主服务器的二进制日志拷贝到自己的硬盘上，进入所谓的“中继日志”中。首先，它启动一个工作线程，叫 I/O 线程，这个 I/O 线程开启一个普通的客户端连接，然后启动一个特殊的二进制日志转储进程（它没有相应的 SQL 命令）。这个转储进程 Master 服务器的二进制日志中读取数据。它不会对事件进行轮询。如果 3 跟上了 Master 服务器，就会进入休眠状态并等待有新的事件发生时 Master 服务器发出的信号。I/O 线程把数据写入 Slave 服务器的中继日志中  
第三步： 107 SQL 线程读取中继日志，并且重放其中的事件，然后更新 Slave 服务器的数据。由于这个线程能跟上 I/O 线程，中继日志通常在操作系统的缓存中，所以中继日志的开销很低。SQL 线程执行事件也可以被写入 Slave服务器自己的二进制日志中，它对于有些场景很实用上图中显示了在 Slave 服务器有两个运行的线程，在 Master服务器上也有一个运行的线程：和其他普通连接一样，由 Slave 服务器发起的连接，在 Master 服务器上同样拥有一个线程

```  
master-->slave1--slave2  
-6->slave3  
  
master(binlog)-->slave  
192.168.0.123 192.168.0.254  
```  
  
1、主从机器使用的mysql版本最好一致。  
2、在主服务器上必须启用二进制日志，并且server-id的取值要大于从服务器。  
3、在主服务器上新建一个用于同步binlog的账号。  
4、在主服务器上导出原始数据到从服务器上。  
5、在从服务器上指定主服务器，指定账号、binlog名称、binlog的起始位置(偏移量)。  
  
1、主从机器使用的mysql版本最好一致。  
使用yum命令安装
  
2、在主服务器上启用二进制日志，并且server-id的取值要大于从服务器。  

  
3、在主服务器上新建一个用于同步数据的账号。  

  
4、在主服务器上导出原始数据到从服务器上。  
 
  
5、在从服务器上指定主服务器，指定账号、binlog、binlog的起始位置。  

  
---  
  
常用的命令:  
start slave
stop slave

STOP SLAVE IO_THREAD ;
STOP SLAVE SQL_THREAD;
   -->
   Slave_IO_Running: Yes
   Slave_SQL_Running: No
  
---  
  
在从服务器上启用binlog:  
vim /etc/my.cnf  
log-slave-updates  
log-bin  
  
链式复制  
A -> B -> C
也就是说，A为从服务器B的主服务器，B为从服务器C的主服务器。为了能工作，B必须既为主服务器又为从服务器。你必须用--logs-bin启动A和B以启用二进制日志，并且用--logs-slave-updates选项启动B。  
  
C将B当成主服务器来操作  
  
延迟复制（只开IO线程，关闭SQL线程）  
  
关闭IO_THREAD 或者 SQL_THREAD  
  
```  
仅仅读的请求。他的数据更新都是根据从主服务器上获得信息进行更新。它会打开两个线程：SQL_THREAD, IO_THREAD。  
IO_THREAD 负责连接主服务器，把相关更新下载回来   
SQL_THREAD 执行下载回来的更新操作。  
```  

### bin-log日志(数据的还原)
```
1）使用mysqlbinlog自带查看命令法：
注意：
-->binlog是二进制文件，普通文件查看器cat、more、vim等都无法打开，必须使用自带的mysqlbinlog命令查看
-->binlog日志与数据库文件在同目录中
-->在MySQL5.5以下版本使用mysqlbinlog命令时如果报错，就加上 “--no-defaults”选项

[root@vagrant-centos65 mysql]# ps axu |grep mysql
root      1410  0.2  0.2 106088  1488 pts/0    S    07:14   0:00 /bin/sh /usr/bin/mysqld_safe --datadir=/var/lib/mysql --socket=/var/lib/mysql/mysql.sock --pid-file=/var/run/mysqld/mysqld.pid --basedir=/usr --user=mysql
mysql     1518  3.7  3.2 396240 19816 pts/0    Sl   07:14   0:00 /usr/libexec/mysqld --basedir=/usr --datadir=/var/lib/mysql --user=mysql --log-error=/var/log/mysqld.log --pid-file=/var/run/mysqld/mysqld.pid --socket=/var/lib/mysql/mysql.sock  
```
找到  --datadir这个参数后面的目录就是mysql的数据目录
可以找到bin-log日志

查看bin-log日志的方法
```
mysqlbinlog mysql-bin.000001
[root@vagrant-centos65 mysql]# mysqlbinlog mysql-bin.000001 
/*!40019 SET @@session.max_insert_delayed_threads=0*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#170619  7:21:27 server id 1  end_log_pos 106   Start: binlog v 4, server v 5.1.73-log created 170619  7:21:27 at startup
# Warning: this binlog is either in use or was not closed properly.
ROLLBACK/*!*/;
BINLOG '
d3tHWQ8BAAAAZgAAAGoAAAABAAQANS4xLjczLWxvZwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAB3e0dZEzgNAAgAEgAEBAQEEgAAUwAEGggAAAAICAgC
'/*!*/;
# at 106
#170619  7:38:00 server id 1  end_log_pos 244   Query   thread_id=3     exec_time=0     error_code=0
SET TIMESTAMP=1497857880/*!*/;
SET @@session.pseudo_thread_id=3/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=1, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=0/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C latin1 *//*!*/;
SET @@session.character_set_client=8,@@session.collation_connection=8,@@session.collation_server=8/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
SET PASSWORD FOR 'root'@'localhost'='*22DF0FE262826C66C3A1E8BC8DC2AF2259B42F46'
```
解释 
server id 1 ： 数据库主机的服务号；
end_log_pos 796： sql结束时的pos节点
thread_id=11： 线程号
---
方法2  上面这种办法读取出binlog日志的全文内容比较多，不容易分辨查看到pos点信息
下面介绍一种更为方便的查询命令：
命令格式：
```
mysql> show binlog events [IN 'log_name'] [FROM pos] [LIMIT [offset,] row_count];
参数解释：
IN 'log_name' ：指定要查询的binlog文件名(不指定就是第一个binlog文件)
FROM pos ：指定从哪个pos起始点开始查起(不指定就是从整个文件首个pos点开始算)
LIMIT [offset,] ：偏移量(不指定就是0)
row_count ：查询总条数(不指定就是所有行)
mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |       695 |
| mysql-bin.000002 |       106 |
+------------------+-----------+
```
举例

```
mysql>  show binlog events in 'mysql-bin.000001'\G;
*************************** 1. row ***************************
   Log_name: mysql-bin.000001
        Pos: 4
 Event_type: Format_desc
  Server_id: 1
End_log_pos: 106
       Info: Server ver: 5.1.73-log, Binlog ver: 4
*************************** 2. row ***************************
   Log_name: mysql-bin.000001
        Pos: 106
 Event_type: Query
  Server_id: 1
End_log_pos: 244
       Info: SET PASSWORD FOR 'root'@'localhost'='*22DF0FE262826C66C3A1E8BC8DC2AF2259B42F46'
*************************** 3. row ***************************
   Log_name: mysql-bin.000001
        Pos: 244
 Event_type: Query
  Server_id: 1
End_log_pos: 359
       Info: CREATE USER 'slave'@'172.16.147.%' IDENTIFIED BY 'slave'
*************************** 4. row ***************************
   Log_name: mysql-bin.000001
        Pos: 359
 Event_type: Query
  Server_id: 1
End_log_pos: 510
       Info: GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'slave'@'172.16.147.%'
*************************** 5. row ***************************
   Log_name: mysql-bin.000001
        Pos: 510
 Event_type: Query
  Server_id: 1
End_log_pos: 585
       Info: flush privileges
*************************** 6. row ***************************
   Log_name: mysql-bin.000001
        Pos: 585
 Event_type: Query
  Server_id: 1
End_log_pos: 695
       Info: create database tanzhouawen charset utf8
6 rows in set (0.00 sec)
```
补充
```
上面这条语句可以将指定的binlog日志文件，分成有效事件行的方式返回，并可使用limit指定pos点的起始偏移，查询条数！
如下操作示例：
a）查询第一个(最早)的binlog日志：
mysql> show binlog events\G;

b）指定查询 mysql-bin.000002这个文件：
mysql> show binlog events in 'mysql-bin.000002'\G;

c）指定查询 mysql-bin.000002这个文件，从pos点:624开始查起：
mysql> show binlog events in 'mysql-bin.000002' from 624\G;

d）指定查询 mysql-bin.000002这个文件，从pos点:624开始查起，查询10条（即10条语句）
mysql> show binlog events in 'mysql-bin.000002' from 624 limit 10\G;

e）指定查询 mysql-bin.000002这个文件，从pos点:624开始查起，偏移2行（即中间跳过2个），查询10条
mysql> show binlog events in 'mysql-bin.000002' from 624 limit 2,10\G;
```

### 利用binlog日志恢复mysql数据
场景模拟
* 第一步  wiki库每天都会备份一次
```
0 4 * * * /usr/bin/mysqldump -uroot -p -B -F -R -x --master-data=2 wiki|gzip >/opt/backup/wiki_$(date +%F).sql.gz
参数说明：
-B：指定数据库
-F：刷新日志
-R：备份存储过程等
-x：锁表
--master-data：在备份语句里添加CHANGE MASTER语句以及binlog文件及位置点信息
```
由于上面在全备份的时候使用了-F选项，那么当数据备份操作刚开始的时候系统就会自动刷新log，这样就会自动产生
一个新的binlog日志，这个新的binlog日志就会用来记录备份之后的数据库“增删改”操作
查看一下：
```
mysql> show master status;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000003 |      202 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
```
也就是说， mysql-bin.000003 是用来记录4:00之后对数据库的所有“增删改”操作。

* 第二步我们对这个库进行了各种操作(早上9点)
我们插入一条数据
```
mysql> insert into wiki_user(`username`,`password`,`email`)values('tanzhouawen','123456','123123@qq.com')
    -> ;
Query OK, 1 row affected, 1 warning (0.00 sec)

```
* 第三步 下午18:00 悲剧了  我把数据给删掉了
```
mysql> drop database wiki;
Query OK, 48 rows affected (0.00 sec)
```

* 第四步 这个时候大家一定不要慌张 
先仔细查看最后一个binlog 日志 并记录一下关键的pos点 看看是哪一个pos点导致了数据库的破坏

1. 先停掉业务 不能再插入数据库  
如果是java后端  需要把java停掉
2. 备份最后一个binlog日志
```
[root@vagrant-centos65 mysql]# cd /var/lib/mysql/
[root@vagrant-centos65 mysql]# cp mysql-bin.000003  /opt/backup/
[root@vagrant-centos65 mysql]# cp -v mysql-bin.000003  /opt/backup/
cp: overwrite `/opt/backup/mysql-bin.000003'? y
`mysql-bin.000003' -> `/opt/backup/mysql-bin.000003'
[root@vagrant-centos65 mysql]# 
```
3. 执行刷新日志索引的操作 我们重新开始新的binlog日志记录文件  一般来说bin-log3不会插入数据了的 但是便于我们分析和找节点，以后所有的数据操作都会写入到下一个日志文件
```
mysql> flush logs;
Query OK, 0 rows affected (0.01 sec)

mysql> show master status;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000004 |      106 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
```
* 第五步 读取binlog日志，分析问题
查看binlog日志以及说过了 我们用第二种办法查看
```
mysql> show binlog events in 'mysql-bin.000003';
+------------------+-----+-------------+-----------+-------------+----------------------------------------------------------------------------------------------------------------+
| Log_name         | Pos | Event_type  | Server_id | End_log_pos | Info                                                                                                           |
+------------------+-----+-------------+-----------+-------------+----------------------------------------------------------------------------------------------------------------+
| mysql-bin.000003 |   4 | Format_desc |         1 |         106 | Server ver: 5.1.73-log, Binlog ver: 4                                                                          |
| mysql-bin.000003 | 106 | Query       |         1 |         202 | use `wiki`; DELETE FROM `wiki`.`wiki_session`                                                                  |
| mysql-bin.000003 | 202 | Intvar      |         1 |         230 | INSERT_ID=2                                                                                                    |
| mysql-bin.000003 | 230 | Query       |         1 |         391 | use `wiki`; insert into wiki_user(`username`,`password`,`email`)values('tanzhouawen','123456','123123@qq.com') |
| mysql-bin.000003 | 391 | Query       |         1 |         472 | drop database wiki                                                                                             |
| mysql-bin.000003 | 472 | Rotate      |         1 |         515 | mysql-bin.000004;pos=4                                                                                         |
+------------------+-----+-------------+-----------+-------------+----------------------------------------------------------------------------------------------------------------+
6 rows in set (0.00 sec)
```
很明显可以看到有一个语句drop database wiki
分析得出结果  对数据库造成影响的pos点在于 230-472之间

* 第六步 先把凌晨4点全备份的数据恢复
```
[root@vagrant-centos65 backup]# cd /opt/backup/
[root@vagrant-centos65 backup]# gzip -d wiki_2017-06-21.sql.gz 
[root@vagrant-centos65 backup]# mysql -uroot -p'tanzhouawen' -v  < wiki_2017-06-21.sql 
```
登录数据库 查看数据
```
[root@vagrant-centos65 backup]# mysql -uroot -p'tanzhouawen'
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 32
Server version: 5.1.73-log Source distribution

Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| tanzhouawen        |
| test               |
| wiki               |
+--------------------+
5 rows in set (0.00 sec)
```
可以看到wiki这个数据库已经回来了 
但是这紧紧只是恢复了当天凌晨4点之前的数据， 在4:00-18:00的数据还没有恢复回来
怎么办
我们可以根据之前的mysql-bin.0000003的新binlog日志进行恢复
* 第七步 从binlog日志恢复数据
恢复命令的语法格式:  
mysqlbinlog mysql-bin.0000xx | mysql -u用户名 -p密码 数据库名  

---
常用参数选项解释：  
--start-position=875 起始pos点  
--stop-position=954 结束pos点  
--start-datetime="2016-9-25 22:01:08" 起始时间点  
--stop-datetime="2019-9-25 22:09:46" 结束时间点  
--database=zyyshop 指定只恢复zyyshop数据库(一台主机上往往有多个数据库，只限本地log日志)  
---
不常用选项： 
-u --user=name 连接到远程主机的用户名
-p --password[=name] 连接到远程主机的密码
-h --host=name 从远程主机上获取binlog日志
--read-from-remote-server 从某个MySQL服务器上读取binlog日志
---
小结：实际是将读出的binlog日志内容，通过管道符传递给mysql命令。这些命令、文件尽量写成绝对路径；

指定恢复pos结束点恢复
--stop-position=391 pos结束节点（按照事务区间算，是391）
执行命令
```
/usr/bin/mysqlbinlog --stop-position=391 --database=wiki /var/lib/mysql/mysql-bin.000003 | /usr/bin/mysql -uroot -p'tanzhouawen' -v wiki
``` 
恢复成功
```
mysql>  show binlog events in 'mysql-bin.000003'\G;
*************************** 1. row ***************************
   Log_name: mysql-bin.000003
        Pos: 4
 Event_type: Format_desc
  Server_id: 1
End_log_pos: 106
       Info: Server ver: 5.1.73-log, Binlog ver: 4
*************************** 2. row ***************************
   Log_name: mysql-bin.000003
        Pos: 106
 Event_type: Query
  Server_id: 1
End_log_pos: 202
       Info: use `wiki`; DELETE FROM `wiki`.`wiki_session`
*************************** 3. row ***************************
   Log_name: mysql-bin.000003
        Pos: 202
 Event_type: Intvar
  Server_id: 1
End_log_pos: 230
       Info: INSERT_ID=2
*************************** 4. row ***************************
   Log_name: mysql-bin.000003
        Pos: 230
 Event_type: Query
  Server_id: 1
End_log_pos: 391
       Info: use `wiki`; insert into wiki_user(`username`,`password`,`email`)values('tanzhouawen','123456','123123@qq.com')
*************************** 5. row ***************************
   Log_name: mysql-bin.000003
        Pos: 391
 Event_type: Query
  Server_id: 1
End_log_pos: 472
       Info: drop database wiki
*************************** 6. row ***************************
   Log_name: mysql-bin.000003
        Pos: 472
 Event_type: Rotate
  Server_id: 1
End_log_pos: 515
       Info: mysql-bin.000004;pos=4
6 rows in set (0.00 sec)
```
如果我只想恢复tanzhouawen这一条数据怎么办
### 可以指定需要恢复的区间来写代码
```
更新 name='tanzhouawen' 这条数据，日志区间是Pos[230] --> End_log_pos[391]，按事务区间是：Pos[230] --> End_log_pos[391]
按照事务区间单独恢复
[root@vagrant-centos65 backup]# /usr/bin/mysqlbinlog --start-position=230 --stop-position=391 --database=wiki /var/lib/mysql/mysql-bin.000003 | /usr/bin/mysql -uroot -p'tanzhouawen' -v wiki
``` 
扩展 可以自己去找写资料完善一下 按时间恢复
---

### 扩展2 备份方案
方案1 每天凌晨4:00做一次全备  使用mysqldump

方案2 rsync同步binlog日志到备份的机器  实现备份

### 扩展3 mysql使用技巧
```
[root@vagrant-centos65 backup]# mysql --help |grep dummy
  -U, --i-am-a-dummy  Synonym for option --safe-updates, -U.
i-am-a-dummy                      FALSE
```
如果在mysql后面加上-U选项 当发出没有wherer 或者limit关键字的update或DELETE时，mysql程序就会拒绝执行
举例

```
[root@vagrant-centos65 backup]# mysql -U -uroot -p'tanzhouawen'
delete from wiki_user;
ERROR 1175 (HY000): You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column
```
做成别名让实现 不加条件无法删除
```
[root@vagrant-centos65 backup]# alias mysql='mysql -U'
```

