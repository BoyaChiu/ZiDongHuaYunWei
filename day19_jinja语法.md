### ansiblejinja语法  
jinja是ansible的默认的模板语言，ansible默认支持jinja语言的内置的filter,jinja官网也提供了很多的filter  
```  
  - hosts: all  
    gather_facts: False  
    vars:  
      list: [1,2,3,4,5]  
      one: "1"  
      str: "string"  
    tasks:  
        - name: run commands  
          shell: df -h  
          register: info  
        - name： debug pprint filter  
          debug: msg="{{info.stdout|pprint }}"  
        - name: debug conditionals filter  
          debug: msg="the run commands status is changed"  
          when: info|changed  
        - name: debug int capitalize filter  
          debug: msg="The int value {{one|int}} The lower value is {{ str| capitalize }}"  
        - name: debug default filter  
          debug: msg="The Variable value is {{ansible|default('ansible is not define')}}"  
        - name: debug list max and min filter  
          debug: msg="The list max value is {{list|max}} The list min value is {{list|min}}"         
        - name: debug ramdom filter  
          debug: msg="The list ramdom value is {{list|random}} and generate a random value is {{1000|random(1,10)}}"  
        - name: debug join filter  
          debug: msg="The join filter value is {{ list|join("+")}}"  
        - name: debug replace and regex_replace filter  
          debug: "The replace value is {{str|replace('t','T')}} The regex_replace vaule is {{str|regex_replace()'.*tr(.*)$'}}"  
```  
* 第一个是对info.stdout结果使用pprint filter进行格式化  debug时使用，可以打印变量的详细信息  
* 第二个是对inof的执行状态使用changed filter进行判断    过滤结果中的changed  
* 第三个是对one的值进行int转变，然后对str的值进行capitalize格式化   接受一个字符串, 将其转换为首字母大写, 其他字母小写的形式返回  
* 第四个是对ansibel变量进行判断，如果该变量定义了就引用它的值，如果没有定义就使用default内值  
* 第五个是对list内的值进行最大值max和最小值min取值  
* 第六个是对list内的值使用random filter随机挑选一个，然后随机生成1000以内的数据，step是10  
* 第七个是对list内的值使用join filter连接在一起  
* 第八个是对str的值使用replace 与regex_replace替换  
官网  http://jinja.pocoo.org/docs/dev   
1. 例子1  
```  
{% set list=['one','two','three'] %}  
{% for i in list %}  
   {{ i }}  
{% endfor %}  
  
{% set list=['one','two','three'] %}  
{% for i in list %}  
   {% if i=='one'  or i.startswith=='two' %}  
          ----> {{i}}  
    {% elif loop.index == 2 %}  
          <----> {{i}}  
    {% else%}  
          <----  {{ i }}  
    {% endif %}  
{% set dict={'kye':'value'} %}  
{% for key,value in dict.iteritems() %}  
    {{key}} ---->{{value}}  
{% endfor %}  
{% for dict in dicts %}  
    {{ dict['key'] }}  
{% endfor %}  
  
{% set dict={'pian': {'test':'siji'}} %}  
{{ dict['pian']['test'] }}  
  
{{ ansible_devices['sda']['partitions']['sda1']['size'] }}  
{{ ansible_memory_mb['real'].get('total')|int * 2}}  
  
jinja中可以使用set定义临时变量也可以直接使用ansible其他地方定义变量，关于jinja变量的引用都是采用{{变量名}}的方式，当然里面还可以根据变量名数据类型选择你想要的信息，比如dict={'kye':'value'},直接{{dict}} 会返回一个python dict数据，如果只需要key对应的值则需要{{dict['key']}}或者{{dict.get('key')}}  
其实这些都是python的标准用法，在jinja里面也可以直接使用，python的逻辑判断and or not 在jinja的判断中也可以直接使用  
```  
---  
### ansible优化执行速度  
我们通过前面2天的学习已经了解了ansible的一些基本的语法，我们完成一些简单的小项目应该没有什么问题了，但是如果我们想在生产环境当中去使用的话还是有所欠缺的，那么我们怎么样才可以在大规模的生产环境中使用ansible。这里有3个步骤  
第一个 大家通过这2天的实验应该可以发现就是我们ansible的执行速度非常慢， 一个简单的部署操作可能就要几分钟，如果并发高起来肯定会更慢，在生产环境中执行速度太慢了肯定不行，我们第一步就是优化ansible的执行效率  
第二个 在生产环境当中有一个非常重要的东西就是标准化，标准化是为了加快开发效率以及减少出错的几率，那么我们在使用ansible的时候构建我们的playbook肯定也要使用标准化，所谓的标准化其实就是规范我们的ansible整个目录  
第三个 就是介绍在多环境下如何更好的使用ansible等内容  
---  
优化ansble的执行速度  
1. 开启ssh长连接  
ansible模式是使用shh和被管理机器进行通信的，所以ansible对ssh的依赖非常强，那么我们就从ssh入手来优化ansible在openssh5.6以后的版本就可以支持multiplexing，如果我们中控机中的ssh -v 版本大于5.6，那么我们就可以直接在ansible.cfg文件中设置ssh长连接即可  
设置参数如下  
sh_args=-o ControlMaster=auto -o ControlPersist=5d  
ContrlPersisit=5d这个参数是设置整个长连接保持时间整理设置为5天，如果开启后通过ssh链接过的设备都会在当前ansible/cp目录下面生产一个socket文件，也可以通过netstat命令查看，会发现有一个ESTABLISHED状态的连接一直与远端设置进行着TCP连接  
下面是centos系统中的一个repo文件 然后运行 yum update openssh-clients  
```  
#: vim /etc/yum.repos.d/openssh.repo  
[CentALT]  
name=CentALT Packages for Enterprise Linux 6 - $basearch  
baseurl=http://mirror.neu.edu.cn/CentALT/6/$basearch/  
enabled=1  
gpgcheck=0  
```  
如果中控机不方便升级openshh-clients时，也可以直接从其他机器赋值一个高版本的ssh2进制文件，然后软链接到本地的/usr/bin/ssh即可完成升级操作  
2. 开启pipelining  
pipelining也是openssh的一个特性，我们之前的流程是不是在本地生产一个.py的文件然后put到服务器上面再执行这个脚本  
如果我们开启了pipelining这个过程将在ssh的会话中进行，这样可以大大提高整个执行效率,如果需要开启pipelining需要被控制机器/etc/sudoers文件编辑当前ansible ssh用户的配置为requirety。否则会报错    国内的机器操作国外的机器   
配置  
```  
pipelining = True  
```  
3. 开启accelerate模式  
和前面的ssh的Multiplexing有点类似，因为都依赖anisble中控机和远程机器有一个长连接，但是accelerate是使用python程序在远端机器上运行一个守护进程，然后ansible会通过这个守护进程监听的端口进行通信，开启accelerate模式，则需要在ansible中控机和远端机都安装python-keyczar软件包下面是ansible.cfg配置文件  
  
```  
[accelerate]  
accelerate_port=5099  
accelerate_timeout=30  
accelerate_connect_timeout=5.0  
```  
如果使用这个模式那么你的流程都会不一样  
4. 设置facts缓存  
我们在playbook里面有一个'gather_facts: yes'这个选项，我们之前有说过这个选项是用来收集我们远端机器的信息的对吧，那么我们执行的时候是不是每次都要执行一次，在机器少的时候可以没什么如果机器多了肯定也会影响我们执行的速度的吧  那么这种情况下我们怎么办，ansible里面有一个设置可以缓存我们的facts的结果，而且可以设置保存的时间  比如我们设置7天等等  
```  
gathering = smart  
fact_caching_timeout = 86400  
fact_caching=jsonfile  
fact_caching_connection = /dev/shm/ansible_fact_cache  
#ansible还支持把数据存放到redis里面  读取速度会更快  
gathering = smart  
fact_caching_timeout = 86400  
fact_caching=redis  
```  
---  
ansible目录结构规范  
  
在日常使用ansible的配置管理工作中，经常会遇到很多role和playbook文件和目录， 还有一些自定义的模块，我们下面推荐一下官网最佳实践中推举使用的ansible工作目录的结构，统一工作目录如下：  
  
java #java环境的inventory文件  
  
web #web环境的inventory文件  
  
group_vars  
  
groups1 #group1 定义的变量文件  
  
groups2 #group2定义的变量文件  
  
host_vars  
  
hostname1 #定义的变量文件  
  
hostname2 #定义的变量文件  
  
library #自定义模块存放目录  
  
filter_plugins #自定义filter插件存放目录  
  
site.yml #playbook 统一入口文件  
  
webservers.yml #特殊任务playbook文件  
  
roles #角色存放目录  
  
common #common 角色目录  
  
  
tasks  
  
main.yml #角色 tasks入口文件  
  
handlers  
  
main.yml #角色handlers入口文件  
  
templates  
  
ntp.conf.j2 #角色 templates文件  
  
files  
  
bar.txt #角色files资源文件  
  
foo.sh #角色files资源文件 COPY SHELL 直接在当前目录下面安装 copy: src=bar.txt dest=optbar.txt  
  
vars  
  
main.yml #角色 变量定义文件  
  
defaults  
  
main.yml #角色 变量定义文件 （优先级低）  
  
meta  
  
main.yml #角色依赖文件  
  
  
webtier #webtier角色目录  
  
monitoring #monitoring角色目录  
  
fooapp #fooapp角色目录  
  
---  
定义多环境  
在实际工作环境中可能会遇到不同环境的机器，比如同时存在多个架构（LNMP+JAVA,LNMP_PYTHON,JAVA+MYSQL,nginx,mysql,php,  mysql+nigx）   php+nginx    php  
在搭建这些环境的过程中会发现有很多的步骤都是重复的比如都有安装mysql的步骤，那么我们在写playbook的时候就需要把角色细化，让每一个角色都可以复用，节省代码量  
很多细节上面的东西需要自己在工作当中去体会  以及优化  
---  
上线前的准备   如果你改好了自己的代码在提交之前需要最后检测一下  
1.语法检测  
在编写玩playbook或者role之后一定要养成进行语法检测的西裤，如果编写的playbook或者role都有语法问题的话，在其他人使用的时候会是一个非常大的麻烦。请务必检查语法  
ansible-playbook –syntax-check /path/to/playbook.yaml  
2.测试运行  
ansible-palybook -C /path/to/palybook.yaml  
---  
讲一个简单的例子     
  
  