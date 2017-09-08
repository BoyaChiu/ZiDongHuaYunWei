### linux系统sendmail发邮件到qq邮箱
1.安装sendmail和mailx
yum -y install sendmail mailx
2.修改配置文件
cp /etc/mail.rc /etc/mail.rc.bak
cat >> /etc/mail.rc >> EOF
set from=12312313@qq.com smtp=smtp.qq.com
set smtp-auth-user=1231212@qq.com smtp-auth-password=yi12312313 smtp-auth=login
EOF
3.重启启动服务
service sendmail restart
4.发送测试邮件
echo "i love you "|mail -s "ceshi" 123123@qq.com
5.在cong服务器上面创建登录用户只限本地运行，确保安装
grant all privilges on *.* to "ceshi"@"127.0.0.1" identified by "password123"
grant all privileges on *.* to "ceshi"@local identifiled by "password123"
### mysql监控脚本
```
#!/bin/bash
MYSQLPORT=netstat -na|grep "LISTEN"|grep "3306"|awk -F[:""]+'{print $4}'
MYSQLIP=ifconfig eth1|grep "inet addr" |awk -F[:""]+'{print $4}'
STATUS=$(/usr/local/service/mysql/bin/mysql -uroot -ppassword123 -S /tmp/mysql.sock -e "show slave status\G"|grep -i "running")
IO_evn=echo $STAUTS|grep IO|awk '{print $2}'
SQL_env='echo $STATUS|grep SQL|awk'{print $2}''
DATA='date +"%y-%m-%d %H:%M:%S"'
if["$MYSQLPORT"=="3306"]
then
echo 'mysql is runing'
else
mail -s "wanfg mysql is down" 12313123@qq.com
fi
if["$IO_env"= "Yes" -a "$SQL_env"="Yes"]
then
echo "slave is running"
else
echo "### #$DATA### ### " >> log.log
echo "slave is not runling">>> long.log
echo "slave is not runing" |mail -s "waring mysql-slve not runnser" 12313123@qq.com
```
### 定时执行
```
crontab -l
*/1 * * * * * root /bin/sh /mydata/checksdfsf.sh
stop slave
```