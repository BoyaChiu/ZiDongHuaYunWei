linux+nginx+php+mysql 写一个脚本

## 1.playbook详解

### 1.1playbook基本语法

playbook使用yaml语法 yaml语法可以通过http:\/\/www.yaml.org\/spec\/1.2\/spec.html\#Syntax

讲解一个简单的例子

nginx.yml

---

- hosts: all

tasks:

- name: Install nginx

yum: name=nginx start=present

- copy: copy nginx.conf

template: src=.\/nginx.conf.js dest=\/etc\/nginx\/nginx.conf owner=root group

=root mode=0644 validate='nginx -t -c %s'

notify:

- Restart Nginx Service

handlers:

- name: Restart Nginx Service

service: name=nginx state=restarted

hosts

\[nginx\]

192.168.1.1

检查语法

ansible-playbook nginx.yaml --syntax--check

查看运行的主机

ansible-playbook nginx.yaml --list-task

ansible-playbook nginx.yaml --list-hosts

执行

ansible-playbook -i hosts nginx.yaml

验证

ansible all -i hosts -m shell -a 'netstat -tnlp \|grep 80'

## 2playbook变量与引用

### 2.1通过inventory文件来定义变量

做一个简单的例子来说明

hosts:

\[nginx\]

11.1.1.1

\[nginx:vars\]

key=ansible

nginx.yml

---

- hosts: all

gather\_facts: False

tasks:

-name: diskp

debug: msg=" print {{key}}"

* 通过命令传入 加参数-e 这种方法很少用 知道就好

* 在playbook文件里面使用vars\_files来传变量

加一个变量

vars\_files:

-- var.yaml




