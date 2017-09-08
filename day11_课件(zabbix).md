### zabbix介绍  
zabbix是一个开源的监控软件集成了nagos和cat的优势  
而且有很多自带的插件可以使用，而且还有api接口供我们使用  
zabbix还支持自定义监控项   shell echo 1 > /tmp/aaa.txt    echo 0 > /tmp/aaa.txt 

zabbix安装  源码安装方式
用yum安装的   zabbix  PHP nginx mysql 

lnmp 编程我们的zabbix   
nginx + mysql +  php  
### yum安装 zabbix依赖包yum源
rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/6/x86_64/zabbix-release-3.2-1.el6.noarch.rpm  
### zabbix安装  
1. 下载zabbix源码  
wget https://dronedata.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.2.4/zabbix-3.2.4.tar.gz  
2. 创建用户账号  
对于所有的zabbix守护进程，需要一个非特权用户，如果zabbix守护进程重非特权用户启动，那么它将作为该用户运行  
如果守护进程从root账号启动，那么它会切换到zabbix用户，所有找个账号必须存在 手动创建  
groupadd zabbix  
useradd -g zabbix zabbix  
3. 创建zabbix数据库  
安装mysql 使用rpm包 rpm -ivh mysql-5.5  
进入安装目录 /opt/zabbix-3.2.4  
mysql -uroot -p't8HPW6^8sg'  
create databse zabbix character set uft8 collate utf8_bin;  
create database zabbix default charset utf8
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';  
flush privileges;  
exit;  
mysql -uzabbix -p'zabbix' zabbix < schema.sql  
mysql -uzabbix -p'zabbix' zabbix < images.sql  
mysql -uzabbix -p'zabbix' zabbix < data.sql  
  
  
4. 开始编译  
安装依赖包  
```
yum -y install libxml2* snmp* net-snmp* curl* php-mysql  
```
开始配置zabbix（我在这里安装了server和agent）
```
./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2
```
开始安装
```
# 默认提示直接 make install
[root@vagrant-centos65 zabbix-3.2.4]# make install
```
5. 修改zabbix服务器的mysql配置
```shell
[root@vagrant-centos65 zabbix-3.2.4]# vim /usr/local/etc/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
```

---  
安装完成了  
启动后端  
/usr/local/services/zabbix/sbin/zabbix_server  
---  
### 安装web端  
* 搭建一个zabbix运行的环境(lnmp)
nginx和mysql跟之前一样  唯一有区别的就是PHP

### 注意PHP里面需要安装一个这个mysqli.so模块   如果没安装成功PHP不能连接成功
PHP需要重新编译一次   HDWIKI    mysql-pro
```
[root@vagrant-centos65 ~]# cd /opt/
[root@vagrant-centos65 opt]# wget  http://cn2.php.net/distributions/php-5.6.2.tar.gz
[root@vagrant-centos65 opt]# tar xvf php-5.6.2.tar.gz
[root@vagrant-centos65 opt]# cd php-5.6.2
[root@vagrant-centos65 php-5.6.2]# ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=php-fpm --with-fpm-group=php-fpm --with-mysql=mysqlnd --with-mysql-sock=/tmp/mysql.sock --with-libxml-dir --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-iconv-dir --with-zlib-dir --with-mcrypt --enable-soap --enable-gd-native-ttf --enable-ftp --enable-mbstring --enable-exif --disable-ipv6 --with-pear --with-curl --with-openssl --enable-bcmath  --enable-sockets --with-mysqli --with-gettext
[root@vagrant-centos65 php-5.6.2]# make && make test && make install
[root@vagrant-centos65 php-5.6.2]# cp php.ini-production /usr/local/php/etc/php.ini
[root@vagrant-centos65 php-5.6.2]# cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
[root@vagrant-centos65 php-5.6.2]# cp /opt/php-5.6.2/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
# 授权 php-fpm
[root@vagrant-centos65 php-5.6.2]# cd /etc/init.d/
[root@vagrant-centos65 init.d]# chmod 755 php-fpm
```
* 此时，还需修改 PHP的 `vim /usr/local/php/etc/php-fpm.conf` 文件，
```txt
在文件的第 148 行，修改文件内容如下：
148 user = php-fpm
149 group = php-fpm
修改为
148 user = nginx
149 group = nginx
```
### 拷贝文件到前端页面
cp /opt/zabbix-3.2.4/frontends/php /data/htdocs/www  
mv /data/htdocs/www/php/* /data/htdosc/www/  
直接访问 http://IP:80  
有一点需要注意 生成/data/htdocs/www/conf/zabbix.conf.php  
会有一点问题 需要手动复制一个 并把密码填进去  
```
[root@vagrant-centos65 ~]# vim /usr/local/php/etc/php.ini 
php_value max_execution_time 300
php_value memory_limit 128M
php_value post_max_size 16M
php_value upload_max_filesize 2M
php_value max_input_time 300
php_value always_populate_raw_post_data -1
date.timezone = "Asia/Shanghai"
```
  
  
### zabbix添加yum源  
rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/6/x86_64/zabbix-release-3.2-1.el6.noarch.rpm  
yum install zabbix-server-mysql zabbix-web-mysql  
  
  
  
  
  