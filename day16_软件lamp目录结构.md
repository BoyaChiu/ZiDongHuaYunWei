软件lamp目录结构：
files:存文件的，ansible默认就会到这里目录去找文件，对应task里面的copy模块
tasks：存放tasks的
handlers：存放handlers
templates：存放模板，对应task里面的模块template
vars：这里面定义的变量，只对当前role有作用
meta：定义role和role直接的依赖关系。
```
[root@mysql_2 ~]# tree /root/lamp/
/root/lamp/
├── hosts
├── roles
│ ├── apache
│ ├── handlers
│ │ └── main.yml
│ ├── tasks
│ │ └── main.yml
│ └── templates
│ └── file.j2
└── wq.yml

lamp/hosts 文件内容:

[root@mysql_2 ~]# cat /root/lamp/hosts
[test]
192.168.1.211
192.168.1.212
192.168.1.213

lamp/wq.yml 文件内容:

[root@mysql_2 ~]# cat /root/lamp/wq.yml
---
- name: install httpd
hosts: all
user: root
roles:
- apache
#会调用roles/apache/tasks/main.yml
#- mysql
#- {role: apache,tags:{'delete_httpd'}}

- name: install mysql
hosts: all
roles:
- mysql

lamp/roles/apache/tasks/main.yml 文件内容:

[root@mysql_2 ~]# cat /root/lamp/roles/apache/tasks/main.yml
---
- name: install httpd
yum: name=httpd state=present
notify:
- restart httpd
- restart iptables
#- include: delete_httpd.yml
#会调用、roles\/apache\/handlers\/main.yml文件里 \
#对应name为restart httpd和restart iptables的相应命令并执行，
#若之前apache服务已安装，再次执行，notify无法c触发

lamp/roles/apache/handlers/main.yml 文件内容:

[root@mysql_2 ~]# cat /root/lamp/roles/apache/handlers/main.yml
---
- name: restart httpd
service: name=httpd state=restarted

- name: restart iptables
service: name=iptables state=restarted

templates文件夹目前没有内容,准备放模板文件；


执行，如下：

#cd ./lanmp

#ansible-playbook -i ./hosts wq.yml