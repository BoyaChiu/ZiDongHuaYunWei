使用register变量

ansibleplaybook中task之间的相互传递变量 比如我们有两个tasks，其中第二个task需要第一个task运行后的结果

下面看这个例子

-host：all

gather_facts: Flase

tasks:

-name:register variable

shell: hostname

register: info

-name: display variable

debug: msg= "sdfsdfsdf {{info}}"

```

在这个例子中 我们把第一个tasks执行结果register给info这个变量 然后打印出来

使用with_items这个关键字就可以完成迭代一个列表.列表里面的每个变量都叫做item

* playbook的循环

ansible的loops

标准loops

---

-hosts: all

taks:

-name: debug loops

debug: msg=" aaa {{ item }}"

with_items:

-one

-two

第二种是循环字典

debug:msg=" name-----&gt; {{item.key}} value----&gt; {{item.value}}"

with_items:

-{key:"one", value: "VALUE1"}

-{value:"two",vaule: "VALUE2"}

嵌套loops

嵌套loops主要实现一对多或者多对多的合并实例：

---

-hosts: all

gather_facts: False

tasks:

-name:debug loops

debug: msg="name ----&gt;{{item[0]}} vaule ---&gt;{{item[1]}}"

with_nested:

- ['A'，'B']

- ['a','b','c']

散列loops

散列loops相比标准loops就是变量支持更丰富的数据结构，比如标准loops的最外层数据必须是python的list数据类型，而散列loops直接支持YAML格式的数据变量

---
- hosts: all
  gather_facts: False
  vars:
    user:
       shan:
          name: shan
          shell: bash
       ceshi:
          name: ceshi
          shell: zsh
  tasks:
    - name: debug loops
      debug: msg= "{{item.key}} value"
      with_dict: "{{user}}"

python 实现方法

user={'xxx': {'name': 'xxx','shell': 'zsh'},'ceshi': {'name': 'ceshi','shell': 'bash' }}

for i,x in user.items():

print i,x['name'],x['shell']

文件匹配loops

文件匹配loops是我们编写playbook的时候需要针对文件进行操作中最常见的一种循环

比如我们要针对一个目录下指定格式的文件进行处理这个时候需要引用with\_filelob循环

---
- hosts: all
  tasks:
     - name: debug loops
       debug: msg="{{item}}"
       with_fileglob:
           - /data/ansible_register/*.yml
with_fileglob会匹配root目录下所有以yaml结尾的文件，当作{{item}}变量

条件判断loops

有时候执行一个tasks之后，我们需要检测这个task的结果是否达到了预想状态,如果没有达到我们预想的状态时,就需要退出整个playbook执行，这个时候我们就需要对某个task结果一直循环检测了

---
- hosts: all
  tasks:
    - name: debug loops
      shell: cat /root/ansible
      register: hosts
      until: hosts.stdout.startswith("Master")
      retries: 5
      delay: 5

5秒执行一次 cat /root/Ansible将结果register给host然后判断host.stdout.startswith的内容是否是Master字符串开头，如果条件成立，此task运行完成，如果条件不成立5秒后重试,5次后还不成立,此task运行失败

文件优先级匹配loops

这个和文件匹配有一点不同 这个是匹配到就会把这个文件当中{{item}}值 如下所示

---

- hosts: all

gather_facts: True

tasks:

- name:debug loops

debug: msg="files ---&gt; {{item}}"

with_first_found:

- "{{ansible_distribution}}.yaml"

- "default.yaml"

register loops

register是用于task直接互相传递数据的一般我们会把register用于在单一的task中进行变量临时存储，其实register还可以同时接受多个task的结果当作变量临时存储，如下所示

---

- hosts: all

gather_facts: True

tasks:

- name:debug loops

shell: "{{item}}"

with_items:

- hostname

- uname

register: ret

-name: display loops

debug: msg= "{% for i in ret.results %} {{ i.stdout }} {% endfor %}"

在执行多个task的时候就需要使用jinja2的for循环才能把所有的结果显示出来了

playbook lookups