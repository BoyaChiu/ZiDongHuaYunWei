### 使用xtrabackup实现MySQL主从复制  
环境    ceshi27主库   ceshi28从库
master 172.16.85.10 slave 172.16.85.13  
### 安装xtrabackup 只需要在主库上面安装  
yum -y install perl perl-devel libaio libaio-devel perl-Time-HiRes perl-DBD-MySQL  
wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.2.12/binary/redhat/6/x86_64/percona-xtrabackup-2.2.12-1.el6.x86_64.rpm  
rpm -ivh percona-xtrabackup-2.2.12-1.el6.x86_64.rpm  
### 是现在mysql主从复制  
#### 主从配置检查  
1. 检查server-id配置  
主和从的server-id一定不能一样 不然一定会报错  
show global variables like 'server_id';查看serverid  
也可以通过查看my.cnf  
2. 检查binlog日志是否开启  
show global variables like 'log_bin';  
server-id=1
log-bin=mysql-bin
### 设置mysql密码
mysqladmin -u root password "tanzhouawen"
---  

#### master上做全库备份  
1. 备份  
innobackupex --defaults-file=/usr/local/services/mysql/my.cnf --user=root --password=t8HPW6^8sg /tmp  
2. 保持事务一致性 为了保证备份集中的数据一致，需要操作  
innobackupex --defaults-file=/usr/local/services/mysql/my.cnf --user=root --password=t8HPW6^8sg --apply-log /tmp/2017-03-16_07-46-14  
3. 拷贝文件到slave  
scp -r /tmp/2017-03-16_07-46-14 172.16.85.13:/tmp  

---  

#### master上创建同步账号并授权REPLICATION  
1. 创建用户并授权  
CREATE USER 'slave'@'172.16.85.%' IDENTIFIED BY 'slave';  
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'slave'@'172.16.85.%';  
flush privileges;
2. 在从库测试是否可以使用slave账号登录  
mysql -h172.16.85.10 -uslave -p'slave'  

---  

#### 在从库上面把主库的文件拷贝到/data/mysql/data目录  
1. 停掉从库  
/etc/init.d/mysqld stop  
2. 复制从master上面拷贝的文件放到slave的datadir目录下  
mv /tmp/2017-03-16_07-46-14/* /data/mysql/data  
3. msyqldir的data目录授权  
chown -R mysql:mysql /data/mysql/data  

---  

#### 启动从库 并执行change master设置主服务器复制信息  
1. 启动从库的mysql  
/etc/init.d/mysqld start  
2. 在slave上执行change master设置主服务器复制信息  
master binlog日志从备份文件中可以获得  
cd /tmp/2017-03-16_07-46-14  
cat xtrabackup_binlog_info  
[root@ceshi14 2017-03-16_07-46-14]# cat xtrabackup_binlog_info  
mysql-bin.000017 107  
进入mysql设置change master设置主服务器复制信息  
change master to master_host='172.16.85.10', master_user='slave', master_password='slave',master_port=3306,master_log_file='mysql-bin.000017',master_log_pos=107;

change master to master_host='172.16.147.13', master_user='slave', master_password='slave',master_port=3306,master_log_file='mysql-bin.000001',master_log_pos=244;

#### 在slave上面启动复制  
 slave start;  
检查主从复制是否正常  
mysql>show slave status\G;  
Slave_IO_Running: Yes  
Slave_SQL_Running: Yes  
主从制作OK  
  
### mysql 报错1 
[ERROR] Fatal error: Can't open and lock privilege tables: Table 'mysql.host' doesn't exist
mysql_install_db –usrer=mysql datadir=/var/lib/mysql
  
### 报错2 
innobackupex: Error: Built-in InnoDB in MySQL 5.1 is not supported in this release. You can either use Percona XtraBackup 2.0, or upgrade to InnoDB plugin.
重新下载2.0版本
wget https://www.percona.com/downloads/XtraBackup/XtraBackup-2.0.8/RPM/rhel6/x86_64/percona-xtrabackup-20-2.0.8-587.rhel6.x86_64.rpm
rpm -ivh 