### 急速安装lnmp 编译版本  
#### 安装msyql+PHP  
1. 系统centos6.5  
2. 安装 开发软件包  
yum -y groupinstall "Development Tools"  
yum -y install libxml2* curl curl-devel libjpeg* libpng* libmcrypt*  freetype-devel
```
如果没有修改成163的源可以直接安装 如果已经改成了163的源需要执行下面的代码
官网不自带 libmcrypt  libmcrypt-devel
wget http://www.atomicorp.com/installers/atomic  下载这个yum源
执行 sh ./atomic 
yum -y install libmcrypt libmcrypt-devel

```
3. 安装mysql： yum -y install mysql mysql-server mysql-devel  
4. 下载PHP-5.6.2 wget http://cn2.php.net/distributions/php-5.6.2.tar.gz  
5. 解压 tar -xvf php-5.6.2.ta.rgz  
6. cd php-5.6.2  
7. 编译安装php  
```
二种情况 第一种 你用了老师给的mysql的rpm包用这种方式编译
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=php-fpm --with-fpm-group=php-fpm --with-mysql=mysqlnd --with-mysql-sock=/tmp/mysql.sock --with-pdo-mysql=/usr/local/services/mysql --with-libxml-dir --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-iconv-dir --with-zlib-dir --with-mcrypt --enable-soap --enable-gd-native-ttf --enable-ftp --enable-mbstring --enable-exif --disable-ipv6 --with-pear --with-curl --with-openssl --enable-bcmath --enable-sockets  
第二种情况  你使用yum来安装mysql
 ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=php-fpm --with-fpm-group=php-fpm --with-mysql --with-mysql-sock=/tmp/mysql.sock --with-pdo-mysql --with-libxml-dir --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-iconv-dir --with-zlib-dir --with-mcrypt --enable-soap --enable-gd-native-ttf --enable-ftp --enable-mbstring --enable-exif --disable-ipv6 --with-pear --with-curl --with-openssl --enable-bcmath --enable-sockets
```
8. make && make install  
9. 如果出现未安装的错误一般使用yum安装即可 记得别忘记libcurl*  
10. 出现找不到文件路径的情况下 用 find / -name 'name'去查找一下  
11. 出现warning的謦欬下大多是因为版本以及默认安装了，可以去掉该行  
12. 修改php配置文件  
cp php.ini-production /usr/local/php/etc/php.ini  
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf  
cp /opt/php-5.6.2/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm  
chmod +x /etc/init.d/php-fpm 
13. 启动php 等安装完nginx后才启动  
---  
### 安装nginx  
yum -y install nginx  
修改 vim /etc/nginx/nginx.conf  
```
user  nginx nginx;

worker_processes 16;

#error_log  /data/logs/nginx_error.log  crit;
error_log /var/log/nginx_error.log crit;
#pid        /usr/local/services/nginx/nginx.pid;
pid /var/run/nginx.pid;

#Specifies the value for maximum file descriptors that can be opened by this process.
worker_rlimit_nofile 65535;

events
{
  use epoll;
  worker_connections 65535;
}

http
{
  include       mime.types;
  default_type  application/octet-stream;

  #charset  gb2312;

  server_names_hash_bucket_size 128;
  client_header_buffer_size 32k;
  large_client_header_buffers 4 32k;
  client_max_body_size 8m;

  sendfile on;
  tcp_nopush     on;

  keepalive_timeout 60;

  tcp_nodelay on;

  fastcgi_connect_timeout 300;
  fastcgi_send_timeout 300;
  fastcgi_read_timeout 300;
  fastcgi_buffer_size 64k;
  fastcgi_buffers 4 64k;
  fastcgi_busy_buffers_size 128k;
  fastcgi_temp_file_write_size 128k;

  gzip on;
  gzip_min_length  1k;
  gzip_buffers     4 16k;
  gzip_http_version 1.0;
  gzip_comp_level 2;
  gzip_types       text/plain application/x-javascript text/css application/xml;
  gzip_vary on;

  #limit_zone  crawler  $binary_remote_addr  10m;
    log_format  www  '$remote_addr - $remote_user [$time_local] "$request" '
              '$status $body_bytes_sent "$http_referer" '
              '"$http_user_agent" $http_x_forwarded_for';

  server
  {
    listen       80;
    server_name  vagrant-centos65.vagrantup.com;
    index start.php index.htm index.html index.php pengyou.php weibo.php qzone.php;
    root  /usr/share/nginx/html;

    #limit_conn   crawler  20;

    location ~ .*\.(php|php5)?$
    {
      #fastcgi_pass  unix:/tmp/php-cgi.sock;
      fastcgi_pass  127.0.0.1:9000;
      fastcgi_index start.php;
#      include fcgi.conf;
      include fastcgi.conf;
    }
    location ~ .*.(svn|git|cvs)
    {
      deny all;
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
      expires      30d;
    }

    location ~ .*\.(js|css)?$
    {
      expires      1h;
    }

      }


}
```
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
mv hdwiki/* /usr/shara/nginx/html/

```
如果使用老师的nginx包安装
mv hdwiki/* /data/htdocs/www/  
chown -R www:wwww /data/htocs/www  
```
### 浏览器http://192.168.1.2 直接进行配置就可以了  