部署HAProxy + LNMP

jinja2 语法

{% for host in groups['nginx'] %}

{{ hostvars[host].get('ansible_hostname') }}

{% endfor %}

jinjia的for 循环和if判断语法和python语法一样

{% set list= ['one', 'two', 'three'] %}

{% for i in list %}

{{ i }}

{% endfor %}

---------------------------------------

{% set list= ['one', 'two', 'three'] %}

{% for i in list %}

{% if i=='one' or i.startswith == 'two' %}

--------&gt; {{ i }}

{% elif loop.index == 2 %}

----------&gt;{{ i }}

{% else %}

&lt;------- {{ i }}

{% endif %}
{% endfor %}

------------------------------------------

{% for key,value in dict.iteritems() %}

{{ key }} -----------&gt; {{ value }}

{% endfor %}

{% for dict in dicts %}

{{ dict['key'] }}

{% endfor %}

在JINJIA中我们可以使用set定义临时变量，也可以直接使用ansible其他地方定义变量。，关于jinja变量的引用都是采用{{变量名}}

的方式，当然里面还可以根据变量名数据类型选择你想要的信息，比如dict={'key':'value'},直接{{ dict }} 会返回一个python dict数据，如果只需要key对应的值，则只需{{ dict['key']}} 或者{{ dict.get('key')}} 其实这些都是'Python'的标准用法，在jinja里面也可以直接使用。python的逻辑判断 and or not 在jinja判断中也可以直接使用

剧本（playbook）定义ansible任务的配置文件，可以将多个任务定义在一个剧本中，由ansible自动执行，剧本指定支持多个任务可以由控制主机运行多个任务，同时对多台远程主机进行管理
playbook是ansible的配置，部署和篇排语言，可以描述一个你想要的远程系统执行策略，或一组步骤的一般过程。如果ansible模块作为你的工作室工具，playbook就是你的设计方案，在基本层面上剧本可用于管理配置和部署远程机器，在更高级的应用中，可以序列多层应用及滚动更新，并可以把动作委托给其他主机，与监控服务器和负载均衡器交互
主机清单（host inventory） 定义ansible管理的主机策略，默认实在ansible的hosts配置文件中定义被管节点，同事也支持自定义动态主机清单和指定配置文件的位置
编写思路
首先我们需要知道我们要什么样子的架构，然后我们要了解整个架构每个组件之间是如何衔接和交互的，当然我们还要清楚架构中每一个组件的原理和流程。下面我们先了解一下haproxy和lnmp集群架构相关知识
haproxy是一款卓越的提供高可用，负载均衡以及基于TCP和HTTP应用的代理软件，目前很多大公司也在使用它做web集群和cache集群的负载均衡以及代理
LNMP架构是我们每一个运维必须要了解的一个网站架构，它是linux+nginx+php+mysql的首字母简称，这种网站架构很容易实现跨主机的横向和纵向扩展，可快速组建一个庞大的web集群系统
很多工业环境中会在web集群前面加一层负载均衡（haproxy|nginx|lvs）所以我们的haproxy和LAMP集群可以无缝结合下面了解我们这个机构的数据流程
1HAproxy代理以及负载我们的nginx+php
2nginx+php web服务功能
3mysql功能

确定好了架构以及需要完成的功能，那么我们现在就可以开始编写我们的ansible playbook了
我们需要了解整个架构，把所有的文件以及需要完成的工作划分成一个一个的文件夹来实现

第一步了解一下架构 haproxy是一个负载均衡的软件 然后加上2台LNP 最后还要搭建一台mysql 整体架构是这样的

把所有的角色分出来 mysql haproxy nginx(php) 总共只有3个角色

第二步 根据角色来创建对应的文件夹以及编写具体的实例

mkdir -p lnmp/role/mysql lnmp/role/nginx lnmp/role/haproxy

第三步 编写roles的site.yml入口文件

---
```
- name: Init base environment for all hosts

hosts: all

roles:

- base

- name: Install Mysql

hosts: mysql

roles:

- mysql

- name: Install nginx + php

hosts: nginx

gather_facts: True

roles:

- nginx

#- name: Install lvs

# hosts: LVS_MASTER

# roles:

# - lvs_master

#- name: Install lvs_slave

# hosts: LVS_SLAVE

# roles:

# - lvs_slave

- name: install haproxy

hosts: haproxy

roles:

- haproxy


