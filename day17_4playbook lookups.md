playbook lookups

通过前面的学习我们知道了很多很放可以定义ansible变量，但是这些变量的定义都是静态的，其实ansible还支持从外部拉取信息，比如我们可以从数据库里面读取信息然后定义给一个变量的形式，这就是ansible的lookups插件，目前ansible已经自带一些lookups组件我可以从ansible的源码文件中查看，我们拿几个常用的lookups来进行讲解吧

playbook conditionals

ansible中所有的conditionals都是使用when来判断

when值是一个条件表达式，如果条件判断成立，这个task就执行某个操作，如果条件判断不成立，该task不执行或者某个操作会跳过 这里说的成立和不成立其实就是true和false,这个条件表达式也支持多个条件之前的and或者or，在判断的时候一定注意数据类型 下面讲解一个例子

---

-hosts: all
tasks:

```
-name: Host192.168.1.118 run this task

debug: msg="{{ ansible\_default\_ipv4.address }}"

when: ansible\_default\_ipv4.address == "192.168.1.118"
```

-name: all host run thsi task

```
shell: hostname
```

register:info

-name: Hostname is ceshi run this task

debug: msg= "{{ ansible\_fqdn }}"

when: info\['stdount'\] = ceshi

-name: hostname is cehi2 run this task

debug: msg= “{{ ansible\_fqdn }}"

when: info\['stdout'\].startswith\('M'\) \#判断info\['stdount'\]的值的第一个字符是不是M开头的 如果是返回true 如果不是就false

第一个when是判断facts信息，ansible\_default\_ipv4取IP地址然后与‘192.168.1.118进行判断，需要注意的是ansible\_default\_ipv4的值是python里面的str数据类型，所以一定要用引号“192.168.1.118”

第二个when是判断主机名是否是ceshi 如果是测试就执行 如果不是 就不执行
第三个when是判断主机名的第一个字符是不是M开头的 如果是就执行 如果不是就不执行或者跳过
skipping表示跳过的意思 就是不执行

Jinja2 filter
Jinja2是目前比较流行的一款模板语言. ansible和saltstack这两个配置管理工具都是只把它当作默认的模板语言，ansible默认支持Jinja2语言的内置filter, 在这里介绍几个经常使用的filter
---
- hosts: all
gather_face: False
vars:
list: [1,2,3,4,5]
one: "1"
str: "string"
takss:
-name: run commands
shell: df -h
register: info
-name: debug pprint filter
debug: msg="{{ info.stdout | pprint }}"
-name: debug conditionals filter
debug: msg=" The run commands status is changed"
when: info|changed
-name: debug int capitalize filter
debug: msg="The int value {{one|int }} The lower value is {{ str|capitalize}}"
-name: debug default filter
debug: msg=" The Variable value is {{ ansible |default('ansible is not define') }}"
-name: debug list max and min filter
debug: msg="The list max value is {{ list|max}} The list min value is {{list| min}}"
-name: debug ramdom filter
debug: msg="The random ramdom value is {{list |random}} and generate a random value is {{1000|random(1,10)}}"
-name: debug join filter
debug: msg="The join filter value is {{list|jon("+")}}"
-name: debug replace and regetx_replace filter
debug: msg="The replace value is {{str|replace('t','T')}} The regex_replace vaule is {{str|regex_replace('.*tr(.*)$','\\1')}}"
第1个是对info.stdout结果使用pprint filter进行格式化
第2个是对info的执行状态使用changed filter进行判断
第3个是对one的值进行int转变，然后对str的值进行capitalize格式化
第4个是对ansible变量进行判断,如果该变量定义了就引用它的值,如果没有定义就使用default内值
第5个是对list内的值进行最大值max和最小值min取值
第6个是对list内的值使用random filter随机挑选一个，然后随机生成1000以内的数据， step是10
第7个是对list内的值使用join filter连接一起
第8个是对str的值使用replace与regex_replace替换

playbook内置变量  
playbook默认已经内置变量，掌握了这些变量后我们可以很容易的实现关于主机相关的逻辑判断了。下面会讲解7个内置变量  
1.groups和group_names  
groups 变量是一个全局变量，它会打印出inventory文件里面所有的主机以及主机组信息，它返回的是一个JSON字符串，我们可以直接把它当作一个变量来使用{{groups}}  
格式进行调用 输出主机变量可以使用{{groups['docker']}} groups_name会打印当前主机所在的groups的名称如果没有定义会返回upgrouped 它返回的也是一个list  
2.hostvars  
hostvars是用来调用指定主机变量，需要传入主机信息，返回的结果也是一个JSON格式的字符串，同样，也可以直接引用JSON字符串内的指定信息  
3.inventory_hostname和inventory_hostname_short  
inventory_hostname 返回主机名  
inventory_hostname_short 返回主机名的第一部分  
4.play_hosts和inventory_dir  
play_hosts变量是用来返回当前playbook运行的主机信息，返回格式是主机list结构,inventory_dir变量是返回当前playbook使用的inventory目录  
5案例

