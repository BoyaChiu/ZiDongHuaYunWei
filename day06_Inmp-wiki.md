### 急速安装lnmp 编译版本  
#### 安装msyql+PHP  
1. 系统centos6.5  
2. 安装 开发软件包  
yum -y groupinstall "Development Tools"  
yum -y libxml2* curl* libjpeg* libpng* libmcrypt*  
3. 安装mysql： yum -y install mysql mysql-server mysql-devel  
4. 下载PHP-5.6.2 wget http://cn2.php.net/distributions/php-5.6.2.tar.gz  
5. 解压 tar -xvf php-5.6.2.ta.rgz  
6. cd php-5.6.2  
7. 编译安装php  
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=php-fpm --with-fpm-group=php-fpm --with-mysql=mysqlnd --with-mysql-sock=/tmp/mysql.sock --with-pdo-mysql=/usr/local/services/mysql --with-libxml-dir --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-iconv-dir --with-zlib-dir --with-mcrypt --enable-soap --enable-gd-native-ttf --enable-ftp --enable-mbstring --enable-exif --disable-ipv6 --with-pear --with-curl --with-openssl --enable-bcmath --enable-sockets  
8. make && make install  
9. 如果出现未安装的错误一般使用yum安装即可 记得别忘记libcurl*  
10. 出现找不到文件路径的情况下 用 find / -name 'name'去查找一下  
11. 出现warning的謦欬下大多是因为版本以及默认安装了，可以去掉该行  
12. 修改php配置文件  
cp php.ini-production /usr/local/php/etc/php.ini  
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf  
cp /opt/php-5.6.2/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm  
13. 启动php 等安装完nginx后才启动  
---  
### 安装nginx  
yum -y install nginx  
修改 vim /etc/nginx/nginx.conf  
user nobody nobody;  
worker_processes 2;  
error_log /var/log/nginx_error.log crit;  
pid /var/run/nginx.pid;  
worker_rlimit_nofile 51200;  
  
events  
{  
use epoll;  
worker_connections 6000;  
}  
  
http  
{  
include mime.types;  
default_type application/octet-stream;  
server_names_hash_bucket_size 3526;  
server_names_hash_max_size 4096;  
log_format combined_realip '$remote_addr $http_x_forwarded_for [$time_local]'  
'$host "$request_uri" $status'  
'"$http_referer" "$http_user_agent"';  
sendfile on;  
tcp_nopush on;  
keepalive_timeout 30;  
client_header_timeout 3m;  
client_body_timeout 3m;  
send_timeout 3m;  
connection_pool_size 256;  
client_header_buffer_size 1k;  
large_client_header_buffers 8 4k;  
request_pool_size 4k;  
output_buffers 4 32k;  
postpone_output 1460;  
client_max_body_size 10m;  
client_body_buffer_size 256k;  
fastcgi_intercept_errors on;  
tcp_nodelay on;  
gzip on;  
gzip_min_length 1k;  
gzip_buffers 4 8k;  
gzip_comp_level 5;  
gzip_http_version 1.1;  
gzip_types text/plain application/x-javascript text/css text/htm application/xml;  
  
server  
{  
listen 80;  
server_name localhost;  
index index.html index.htm index.php;  
root /usr/share/nginx/html;  
  
location ~ .*\.(php|php5)?$  
{  
fastcgi_pass 127.0.0.1:9000;  
fastcgi_index start.php;  
include fastcgi.conf;  
}  
  
}  
  
}  
####   
启动php-fpm  
vim /usr/local/php/etc/php-fpm user=nginx group=nginx  
/etc/init.d/php-fpm start  
启动nginx /etc/init.d/nginx start  
vim /usr/shara/nginx/html/cc.php  
<?php  
phpinfo();  
?>  
127.0.0.1/cc.php  
LNMP安装完成  
  
##wiki安装部署  
### 首先登录进入mysql数据库  
mysql -uroot  
### 创建一个wiki库  
create database wiki charset utf8;  
grant all on wiki.* to wiki@'localhost' identified by 'wiki';  
flush privileges;  
下载wiki软件  
http://kaiyuan.hudong.com/  
unzip HDWiki-v6.0UTF8-20170209.zip  
mv hdwiki/* /data/htdocs/www/  
chown -R www:wwww /data/htocs/www  
### 浏览器http://192.168.1.2 直接进行配置就可以了  