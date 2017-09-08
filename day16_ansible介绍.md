### ansible 系统架构
ansible的优点  
1. ansible糅合了众多老牌运维工具的优点，基本上pubbet和saltstack能实现的功能全部能实现  
2. ansibel 不需要客户端，不需要客户端有一个非常大的优势，就是可以无缝接入现有的架构.ansible不需要在客户端做任何操作，就可以直接使用。  
3. ansible是一个工具，ansible不需要启动服务，仅仅只是一个工具，可以轻松的实现分布式扩展  
4. ansible是一致性，高可靠性，安全性设计的轻量级自动化工具  
ansible的基本架构   
1.连接插件(connectior plugins) 用于连接主机 用来连接被管理端  
2.核心模块(core modules) 连接主机实现操作， 它依赖于具体的模块来做具体的事情  
3.自定义模块(custom modules) 根据自己的需求编写具体的模块  
4.插件(plugins) 完成模块功能的补充  
5.playbooks(剧本) ansible的配置文件,将多个任务定义在剧本中，由ansible自动执行  
6.host inventory（主机清单）定义ansible需要操作主机的范围  
最重要的一点是 ansible是模块化的 它所有的操作都依赖于模块  
https://www.processon.com/mindmap/58d6713be4b0359bbccc00aa   架构图
![image](http://www.2cto.com/uploadfile/Collfiles/20170207/20170207110904279.png)
比如我需要创建一个文件 那么我就需要调用file模块 我需要copy文件，那么我就需要copy模块  
我需要测试机器的存活率，那么就需要ping模块  
ansible all -m ping   

### ansible安装 
* ansible只是一个进程  不需要添加数据库也不需要启动和运行守护进程它只是一个进程你可以轻松使用它安装在任何一点主机上面（除了windows）ansible管理机不能安装到windows上面  
* 版本的选择 因为2.0有非常大的改进  一般都会使用2.0以上的版本  
* 控制机的要求  因为ansible是python写的  所以需要在安装了python2.6或者2.7以上的python版本才可以安装  
* 管理节点的要求  需要安装ssh python版本在2.5以上  
* 安装有3个方式 

1. yum -y install ansible    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo（下载yum源）
2. pip install ansible 
3. 从github下载   
```
$ git clone git：//github.com/ansible/ansible.git --recursive
$ cd ./ansible
$ make rpm
$ sudo rpm -Uvh ./rpm-build/ansible-*.noarch.rpm
```

### 任务执行模式 
ansible系统由控制主机对被管节点的操作方式有两种ad_hoc和playbook    
* ad_hoc单命令模式 可以对多台主机执行单个命令    
```
ansible all -a "/bin/echo hello"
```
* playbook通过多个tasks的集合完成一类功能如web的安装部署，数据库服务器的批量备份等  
```
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is at the latest version
    yum: name=httpd state=latest
  - name: write the apache config file
    template: src=/srv/httpd.j2 dest=/etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running (and enable it at boot)
    service: name=httpd state=started enabled=yes
  handlers:
    - name: restart apache
      service: name=httpd state=restarted
```
### ansible配置文件 ansible.cfg
查看配置文件设置
http://docs.ansible.com/ansible/intro_configuration.html#poll-interval  
* inventory–这个参数表示资源清单inventory文件配置，资源清单就是一些ansible需要链接管理的主机列表。安装完ansible之后默认所在的inventory列表配置如下：  

inventory = /etc/ansible/hosts    

* library–Ansible的操作动作，无论是本地或远程，都使用一小段代码来执行。这小段代码成为模块，这个library参数就是只想存放在Ansible模块的目录。Ansible支持多个目录方式，只要用冒号（：）隔开就可以，同时也会检查当前执行playbook位置下的./library位置。默认的配置如下：

library = /usr/share/ansible  

* forks–设置默认情况下Ansible最多能有多少个进程同时工作，默认设置最多5个进程并行处理。具体需要设置多少个，可以根据控制主机的性能和被管理节点的数量来确定。默认参数配置如下： forks=20 你没有优化的优化的情况下执行比较慢

forks = 5

* sudo_user–这个设置默认执行命令的用户，在playbook中重新设置这个参数。默认参数配置如下：

sudo_user = root  

* remote_port–这个是指定链接被管节点的管理端口，默认22。除非设置了特殊的SSH端口，不然这个参数一般是不需要修改的。默认配置如下：

remote_port = 22

* host_key_checking–这个设置是否检查SSH主机的秘钥。可以设置为True或者False。默认配置如下：

host_key_checking = false  

* timeout–这是设置SSH链接的超时间隔，单位是秒。默认配置实例如下：

timeout = 60

* log_path–Ansible系统默认是不记录日志的，如果想把Ansible系统的输出记录到日志文件中，需要设置log\_path来指定一个存储Ansible日志的文件。配置实例如下：

log_path = /var/log/ansible.log  
poll_interval 异步执行任务的时候多久检查一次任务装填
poll_interval = 15

选择远程的工具   默认情况下就是smart(智能)模式  自动选择连接方式
只有当你需要优化执行速度的时候才需要修改这个选项
transport = smart 

module_set_locale  设置本地的环境变量  
inventory      = /etc/ansible/hosts     这个是默认库文件位置,脚本,或者存放可通信主机的目录  
#library        = /usr/share/my_modules/   Ansible默认搜寻模块的位置  
remote_tmp     = $HOME/.ansible/tmp   Ansible 通过远程传输模块到远程主机,然后远程执行,执行后在清理现场.在有些场景下,你也许想使用默认路径希望像更换补丁一样使用  
pattern        = *    如果没有提供“hosts”节点,这是playbook要通信的默认主机组.默认值是对所有主机通信  
forks          = 5    在与主机通信时的默认并行进程数 ，默认是5d  
poll_interval  = 15    当具体的poll interval 没有定义时,多少时间回查一下这些任务的状态, 默认值是5秒  
sudo_user      = root   sudo使用的默认用户 ，默认是root  
#ask_sudo_pass = True   用来控制Ansible playbook 在执行sudo之前是否询问sudo密码.默认为no  
#ask_pass      = True    控制Ansible playbook 是否会自动默认弹出密码  
transport      = smart   通信机制.默认 值为’smart’。如果本地系统支持   ControlPersist技术的话,将会使用(基于OpenSSH)‘ssh’,如果不支持讲使用‘paramiko’.其他传输选项包括‘local’, ‘chroot’,’jail’等等  
#remote_port    = 22    远程SSH端口。 默认是22  
module_lang    = C   模块和系统之间通信的计算机语言，默认是C语言  
gathering = implicit   控制默认facts收集（远程系统变量）. 默认值为’implicit’, 每一次play,facts都会被收集
#roles_path    = /etc/ansible/roles   roles 路径指的是’roles/’下的额外目录,用于playbook搜索Ansible roles
#host_key_checking = False    检查主机密钥
sudo_exe = sudo     如果在其他远程主机上使用另一种方式执sudu操作.可以使用该参数进行更换
#what flags to pass to sudo   传递sudo之外的参数
#sudo_flags = -H

#SSH timeout    SSH超时时间
timeout = 10
#remote_user = root   使用/usr/bin/ansible-playbook链接的默认用户名，如果不指定，会使用当前登录的用户名
#log_path = /var/log/ansible.log     日志文件存放路径
#module_name = command     ansible命令执行默认的模块
#executable = /bin/sh     在sudo环境下产生一个shell交互接口. 用户只在/bin/bash的或者sudo限制的一些场景中需要修改
#jinja2_extensions = jinja2.ext.do,jinja2.ext.i18n      允许开启Jinja2拓展模块
#private_key_file = /path/to/file         私钥文件存储位置
ansible_managed = Ansible managed: {file} modified on %Y-%m-%d %H:%M:%S by {uid} on {host}   这个设置可以告知用户,Ansible修改了一个文件,并且手动写入的内容可能已经被覆盖.
#display_skipped_hosts = True     显示任何跳过任务的状态 ，默认是显示
#error_on_undefined_vars = False      如果所引用的变量名称错误的话, 将会导致ansible在执行步骤上失败
#system_warnings = True    允许禁用系统运行ansible相关的潜在问题警告
#deprecation_warnings = True     允许在ansible-playbook输出结果中禁用“不建议使用”警告
#command_warnings = False    当shell和命令行模块被默认模块简化的时,Ansible 将默认发出警告
#bin_ansible_callbacks = False    用来控制callback插件是否在运行 /usr/bin/ansible 的时候被加载. 这个模块将用于命令行的日志系统,发出通知等特性
#nocows = 1    默认ansible可以调用一些cowsay的特性   开启/禁用：0/1
#nocolor = 1  输出带上颜色区别， 开启/关闭：0/1




---
#
# 3. 配置Linux主机SSH无密码访问

3.1 生成秘钥

#ssh-keygen -t rsa

3.2 将秘钥拷贝到预管理的节点上

#ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.116.130

## 4. ansible执行

4.1测试主机连通性

修改主机和配置

#vim /etc/ansible/hosts

[xxx]

10.0.0.1

10.0.0.2

ansible all -m ping -k -k指令是增加密码验证

4.2批量执行命令

ansible all -m shell -a '\/bin\/echo hello ansible'

4.3帮助
学习一个软件最重要的2个东西  第一个帮助文档  第二个官方文档
ansible-doc -h

ansible-doc -l

ansible-doc -s yum

有助于我们排错
查看详细信息 -v -vvv  

官方文档 http:\/\/docs.ansible.com

python接口的调用帮助文档 需要进python去看

python环境下

import ansible

from ansible.runner import Runner

from ansible.playbook import PlayBook

help(ansible.runner)

help(ansible.playbook)

## 5.ansible组件

### 5.1ansible inventory

所有的机器信息都存放到ansible的inventory组件里面，默认ansible的inventory是一个静态的ini格式的文件/etc/ansible\/hosts 当然还可以通过ANSIBLE_HOSTS环境变量指定或者运行ansible和ansible-playbook的时候用-i参数临时设置

* 定义主机和主机组

[docker] #定义了一组叫docker
172.16.1.11 #组下面的主机

172.11.11.11 # ansible_ssh_pass='123456'

[docker:vars] #针对docker组使用inventroy内置变量定义了ssh登陆密码

ansible_ssh_pass='123456'

[ansible:children]#定义了一个ansible组 下面包含一个docker组

docker

* 多个inventory列表

配置支持多个inventory
首先需要修改ansible.cfg中hosts的定义改成一个目录比如 hostfile = /data/inventory

然后我们在目录里面放入多个hosts文件

[root@ceshi2 data]# tree inventory

inventory

├── docker

└── hosts

不同的文件可以存放不同的主机:

cat inventory\/hosts

172.16.4.11 ansible_ssh_pass='123456'

cat inventory/docker

[docker]

172.16.1.11 #组下面的主机

172.11.11.11 # ansible_ssh_pass='123456'

[docker:vars] #针对docker组使用inventroy内置变量定义了ssh登陆密码

ansible_ssh_pass='123456'

[ansible:children]#定义了一个ansible组 下面包含一个docker组

docker

* 动态Inventory

动态inventory的意思是所有的变量可以从外部获取,也就是说我们可以从CMDB以及zabbix系统拉取所有的主机信息然后使用ansible进行管理。引用inventory只需要把ansible.cfg文件中的inventory定义值改成一个执行脚本即可。
脚本实例查看例子2-2-1

inventory内置参数

请查看2-2-2

### 5.2ansible Ad-Hoc命令

ad-hoc是点对点的执行ansible命令，介绍一下日常的Ad-Hoc命令

ansible docker -m shell -a 'hostname' -o 
# -o的意思是异步执行

ansible docker -B 120 -P 0 -m shell -a 'sleep 10;hostname' -o #加了-P 0 之后会返回一个job_id 可以通过jobID去查看执行的结果

ansible 172.17.42.101 -m async_status -a 'jid='5265654654''

当-P 大于0的时候会轮询去查询执行结果

其他的一些常用的命令我们会在以后的例子里面给大家讲

### 5.3ansible playbook

playbook是一个剧本，当我们ansible日常命令ad-hoc命令功能完成不了时，就需要playbook来实现了

在实际工作过程中我们大部分的时间都在编写playbook 会在后面的课程单独讲

### 5.4 ansible facts CMDB

facts是ansible用于采集被管机器设备信息的一个功能,我们可以使用setup模块差机器的所有的facts信息

ansible 172.17.1.1 -m setup 收集到信息后可以直接在后面YAML脚本中引用

### 5.5 role

role是对我们日常使用的playbook的目录结构进行规范化，下面使用一个案例来介绍role

案例在2-2-3

### 5.6 ansible Galaxy

这个是官网的分享role的功能平台,可以自己去下载别人写好的role来使用网址是https://galaxy.ansible.com/list
#/roles



Options:

-a MODULE_ARGS, --args=MODULE_ARGS

module arguments

-k, --ask-pass ask for SSH password

-K, --ask-sudo-pass ask for sudo password

-B SECONDS, --background=SECONDS

run asynchronously, failing after X seconds

(default=N/A)

-C, --check don't make any changes; instead, try to predict some

of the changes that may occur

-c CONNECTION, --connection=CONNECTION

connection type to use (default=smart)

-f FORKS, --forks=FORKS

specify number of parallel processes to use

(default=6)

-h, --help show this help message and exit

-i INVENTORY, --inventory-file=INVENTORY

specify inventory host file

(default=/etc/ansible/hosts)

-l SUBSET, --limit=SUBSET

further limit selected hosts to an additional pattern

--list-hosts outputs a list of matching hosts; does not execute

anything else

-m MODULE_NAME, --module-name=MODULE_NAME

module name to execute (default=command)

-M MODULE_PATH, --module-path=MODULE_PATH

specify path(s) to module library

(default=/usr/share/ansible)

-o, --one-line condense output

-P POLL_INTERVAL, --poll=POLL_INTERVAL

set the poll interval if using -B (default=15)

--private-key=PRIVATE_KEY_FILE

use this file to authenticate the connection

-s, --sudo run operations with sudo (nopasswd)

-U SUDO_USER, --sudo-user=SUDO_USER

desired sudo user (default=root)

-T TIMEOUT, --timeout=TIMEOUT

override the SSH timeout in seconds (default=10)

-t TREE, --tree=TREE log output to this directory

-u REMOTE_USER, --user=REMOTE_USER

connect as this user (default=root)

-v, --verbose verbose mode (-vvv for more, -vvvv to enable

connection debugging)

--version show program's version number and exit