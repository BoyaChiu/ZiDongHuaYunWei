
---
useradd   
useradd user01  
-u  
-g  主组（一个用户只能有一个主组）  
-G  辅助组 （多个辅助组) 将一个组加入另外一个组  
-c    
-d  
-s  
-M  
groupadd -g 20000 uplooking  
useradd -u 10000 -g 20000 -c "这是一个使用命令创建的用户" -d /dev/null -s /sbin/nologin -M -G root,bin user03

cat /etc/passwd | grep user03
user03:x:10000:20000:这是一个使用命令创建的用户:/dev/null:/sbin/nologin

改变用户信息 usermod

usermod -c "这是一个普通用户" -d /home/user03 -s /bin/bash user03
cat /etc/passwd | grep user03
user03:x:10000:20000:这是一个普通用户:/home/user03:/bin/bash




**************
/etc/passwd
/etc/shadow
/etc/group
mkidr /home/username
bashrc bash_logout bash_profile
*************


/etc/login.defs  创建用户的模板

/etc/passwd     --存放用户信息
man 5 passwd
account:password:UID:GID:GECOS:directory:shell
用户名:密码:用户ID:组ID:描述信息:用户的家目录:可以登录(/bin/bash)|不可登录（/sbuin/nologin）


/etc/shadow    --用户的创建时间，密码信息
man 5 shadow
user01:!!:15947:0:99999:7:::
++
1.login name-->user01
2.encrypted password --> !!  空密码  "$6$2a..."  加密密码
3.date of last password change  --> 15947 用户创建时间
4.minimum password age-->  0 最小密码修改期限 如果等以3，表示3天之后才能修改密码
5.maximum password age-->  99999 最大密码修改期限 如果等以4，每隔4天修改一次密码
6.password warning period --> 7 密码失效前7天，开始警告
7.password inactivity period --> 空  假如等于3.表示密码失效以后，后3天还可以修改密码8.account expiration date    --> 15950(3) ? 3天以后锁定账户
9.reserved field --> 保留
++

/etc/group

user01:x:2130:
组名称:组密码:组ID:


创建家目录 /home/username


创建环境变量  模板（/etc/skel/.bash*）
.bash_logout   登出执行脚本
.bash_profile  局部（当前用户）环境变量  
.bashrc	       局部bash shell配置文件


++++++++++++++++++++++++
useradd
-u
-g
-G
-c
-d
-s
-M
-m

usermod
-L
-U

userdel
-r

groupadd

groupdel



passwd username
echo “xxx” |passwd --stdin username

chage
+++++++++++++
/etc/login.defs

/etc/passwd
/etc/group
/etc/shadow

/home/username
cp /etc/skel/.bash * /home/username

---
特殊权限
chmod  |u|g|o|a    +|-|=   r w x -  /dir/file -R
       对象	   授权    4 2 1 0 

chown   owner:group  /path -R
chown   user01.	/path   改变所有属性
chown	.user02 /path	只改变所属组
chgrp	user03 /path	改变所属组

0777








特殊权限


冒险位 （临时拥有拥有者的权限）
u+s  4000


强制位,针对目录来操作，可以让新生成目录继承父目录的属组权限
g+s 2000


粘滞位，在公共目录中，用户只能管理(删除)自己的文件（拥有者）
o+t 1000


rw-rwSrwT
r-Srwsr-t
r--r--r-t
r-sr-Sr-T
rwsrwsr--
rwsrwxr-x

1111 
2222
3333
4444
5555
1234
2345
5677
7765
1277
7746
6567
7651


正则表达式  
正则表达式是一种描述方法，一种小型的语言，用字符来表示某种含义的符号  
一个点代表一个字符  
例1 样式.T.代表3个字符，中间的字符是T 左右两边是任意一个字符  
例2 ... 代表字符长度是3的字符串，如果要对比 请加入转意符  
例3 data... 代表data.后接3个字符，入data.txtt data.cf data.123  
^在行首  
例如 样式^jack 代表jack应出现在行首,才符合条件 如jack ding  
表示尾部  
例 样式123 表示在最后一个行是123才符合条件 如jack123  
123jack  
[...]字符集合 [0-9]一位  
[...]代表字符串行中的一个字符（长度为1）  
样式1:[ABc]代表A|B|c这三个字符中的任意一个  
样式2: [Ss]name 代表Same或sname  
一下是常见用法  
[A-Z] 匹配一个大写的字母  
[a-z]匹配一个小写的字母  
[0-9]一个数字  
[^A-Z]除了大写字母之外的一个字符  
[^a-zA-Z] 一个非英文字母的字符  
[^a-zA-Z0-9] 一个非英文字母，并且非数字的字符  
^出现在括号里的第一个位置 表示"非/不是"的意思  
*出现0个以上  
*表示前面的字符出现0个或者多个  
例 aA*c 代表A这个字符可能出现0个或者0个以上 如:ac aAc aAAc  
{...}指定符合的个数  
指定符合的个数  
指定前面字符的个数  
例如：{3,5}表示前面的字符有3到5个。[a-z]{3,5}、代表以小字母组成的字符串，长度是3到5  
(..)把比对符合的字符串暂时保存起来  
例如：H(..)y表示要保存H和y之间的3个字符  
若要提取保存的字符串，可以用位置参数。1代表第一个保存的字符串，2代表第二个保存的字符  



