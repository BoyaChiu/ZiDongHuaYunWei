### 制作批量部署脚本的目的
1. 在日常工作当中会有非常繁琐的部署的操作 比如会经常性部署同样环境的机器 前端(lnmp|lamp) 后端(java+tomcat+mysql)等等 
人工参与的步骤越少，我们的机器就越不容易出故障
2. 日常工作中会有很多重复性的工作 比如 更新，下日志等等 减轻工作量 让运维从繁琐的重复性工作中解放出来去做环境和机器的优化
3. 对一台新的机器进行初始化(包含优化 安装软件 防火墙 等等) 省时间
---

### 我们的需求
工具  ansible  
在使用ansible配置初始化剧本之前，我们一定要清楚想要实现一个什么样的环境，比如我们使用ansible执行初始化剧本之后，整个机器的环境是处于一个什么样的状态以及我们后续应该怎么去维护和扩展等等  
首先我们要了解什么是初始化   
我对一台全新的机器执行一次 是没问题    
但是我们如果说对一台已经执行过一次的机器 再执行一次会不会有什么后果  
https://www.processon.com/mindmap/587a348de4b087b115e02ec5
初始化其实就是对机器上线前进行的一些操作 
在ansible当中所有的配置管理文件都需要做到可以更好的管理和复用ansible的配置文件所以我们一定会使用roles的概念  
在未发生故障之前要考虑这个操作造成的后果，以及程序里面做判断来预防这种误操作造成的后果  
归纳一下整体roles  
第一点 要保证程序不出bug  测试   根据我们的生产环境去做测试 教其他同事使用这个软件   
第二点 必须要3个人以上 其他同事不会的情况下不会去推广   

1. 配置yum源  
2. 配置防火墙    
3. 公钥
4. 初始化  优化
5. 配置时区  
6. 按需安装软件  nginx   php mysql java lua gcc    lnmp  java+mysql  java+nginx
7. 设置crontab做日志分割
8. 配置zabbix
在这里我们需要了解 每个业务角色的定义和指向问题

---
1-5,8的角色都非常简单
在第六步这里会涉及比较多的内容
确定我们的需求 
我们的需求是要把roles的概念引入到install这个角色里面
rolse的概念是把所有的功能全部拆分那么我们在ansible的角色文件里面如何去做
使用 include 引入文件
我们先把所有的角色都定义好
我们怎么来确定要执行那些文件
lnmp   nginx+php+mysql
nginx  true   php true  mysql true    erlang false   843 false jdk false python false 
when 如果判断为true就执行   如果判断为faslse 就不执行  
把rpm包放到一个默认的目录里面   软件包以及放到/data/kaiche_soft
软件包路径的定义  
nginx脚本以及完成  可重复执行  并不会对线上的服务造成影响 

总结 6_install
1. 配置我们的install-->main.yml  利用include(引用外部文件)来做到软件的rolse需求 把所有的软件都分开当做一个一个的软件来调用  
```
---
- include: nginx.yml
  when: install_nginx

- include: mysql.yml
  when: install_mysql

- include: erlang.yml
  when: install_erlang

- include: php.yml
  when: install_php

- include: 843.yml
  when: install_843

- include: jdk.yml
  when: install_jdk

- include: Python.yml
  when: install_python
```
2. 创建要给目录存放我们的软件包(rpm包)
mkdir -p /data/kaiche_soft 
cp *.rpm  /data/kaiche_soft    *.rpm表示我们之前制作好的rpm包
3. 定义软件路径配置文件
mkdir -p /data/kaiche_config 
cat /data/kaiche_config/common.yml
```
#定义软件包的路径
pub_path: '/data/kaiche_soft'

#rpm包的名称
jdk_rpm: jdk-1.8.0_73-1.x86_64
nginx_rpm: nginx-1.4.4-1.x86_64
php_rpm: php-5.3.10-1.x86_64
mysql_rpm: mysql-5.5.24-1.x86_64
gcc_rpm: gcc-4.7.2-1.el6.x86_64
Python_rpm: Python-2.7.6-1.el6.x86_64
erlang_rpm: erlang-5.10.4-1.x86_64
zabbix_rpm: zabbix-agent-3.2.4-1.el6.x86_64

#rpm的路径
jdk_rpm_path: '{{pub_path}}/{{jdk_rpm}}.rpm'
nginx_rpm_path: '{{pub_path}}/{{nginx_rpm}}.rpm'
php_rpm_path: '{{pub_path}}/{{php_rpm}}.rpm'
mysql_rpm_path: '{{pub_path}}/{{mysql_rpm}}.rpm'
erlang_rpm_path: '{{pub_path}}/{{erlang_rpm}}.rpm'
gcc_rpm_path: '{{pub_path}}/{{gcc_rpm}}.rpm'
Python_rpm_path: '{{pub_path}}/{{Python_rpm}}.rpm'
setuptools_path: '{{pub_path}}/setuptools-3.3.tar.gz'
pip_path: '{{pub_path}}/pip-6.1.1.tar.gz'
zabbix_agent: '{{pub_path}}/zabbix_agentd.conf'
path_843: '{{pub_path}}/843.tar.gz'
zabbix_arpm: '{{pub_path}}/{{zabbix_rpm}}.rpm'
```
4. 在hosts文件里面定义组变量  在我们的main.yml文件里面写一个when条件 当我们的install_*为true的时候就引入外部文件 当为false的时候就不引入
```
[lnmp]

[nginx]

[jdk_mysql]

[mysql]

[nginx_php]

[jdk]

[erlang]

[python]
172.16.102.15

[all:vars]
install_nginx=false
install_mysql=false
install_php=false
install_jdk=false
install_python=false
install_erlang=false
install_843=false
is_slave=false


[nginx:vars]
install_nginx=true

[jdk_mysql:vars]
install_jdk=true
install_mysql=true

[lnmp:vars]
install_nginx=true
install_mysql=true
install_php=true

[erlang:vars]
install_erlang=true

[python:vars]
install_python=true
```
5. 写我们具体的软件安装的yml

```
ll /data/kaiche/roles/6_install 
-rw-r--r-- 1 root root 192 Apr  7 12:38 843.yml
-rw-r--r-- 1 root root 492 Apr  7 12:38 erlang.yml
-rw-r--r-- 1 root root 270 Apr  7 13:34 jdk.yml
-rw-r--r-- 1 root root 303 Apr  7 12:54 main.yml
-rw-r--r-- 1 root root 422 Apr  7 12:38 mysql.yml
-rw-r--r-- 1 root root 389 Apr  7 12:38 nginx.yml
-rw-r--r-- 1 root root 383 Apr  7 12:38 php.yml
-rw-r--r-- 1 root root 927 Apr  7 12:38 Python.yml

cat /data/kaiche/roles/6_install/nginx.yml
---
- shell: mkdir -p /data/soft
- copy: src={{ nginx_rpm_path }} dest=/data/soft/


# - yum: name=/data/soft/{{ nginx_rpm }}.rpm state=present
- shell: rpm -q {{ nginx_rpm }}  || rpm -ivh /data/soft/{{ nginx_rpm }}.rpm

- shell: chdir=/usr/local/services test -d nginx

- shell: netstat -ntpl|grep nginx || /sbin/service nginx start

- shell: echo "<?php?>" > /data/htdocs/www/monitor.php
```