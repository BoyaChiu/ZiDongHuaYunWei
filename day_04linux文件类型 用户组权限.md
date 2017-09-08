### linux文件类型:  
查看文件类型:  
ls -l     
file +文件 --界定一个文件类型  
---  
|描述       |含义 |  
|----------|-----------|  
|b              |块文件也叫设备文件也叫特殊文件|  
|c              |字符文件|  
|d              |目录文件|  
|p              |管道文件|  
|f(-)           |普通文件／文本文件|  
|l              |链接文件|  
|s(socket)      |unix/类unix套接字|  
  
### 用户/组  
用户类型: 管理员(root) 0    
    普通用户(500+)--普通权限,但可以登录系统    
    程序用户(0< use_id< 500) --普通权限，但不能登录系统    
  
useradd --新建用户   
	useradd username    
	useradd [-c|-d|-g|-G|-s|-u|-m|-M]    
		-c　新建用户时添加注解    
		-d　指定用户的家目录    
		-g　指定用户的主组    
		-G　辅助组    
		-s 指定用户的shell    
		-u 指定用户id    
		-m 新建用户时要创建家目录    
		-M 新建用户时不创建家目    
useradd -u 10005 test05 -d /dev/null -M -c "这是一个程序用户5" -g kkk -G root,bin -s /sbin/nologin    
  
  
* cat /etc/passwd  
  
用户配置文件：   
/etc/passwd	－－存放用户信息     
	man 5 passwd     
/etc/shadow	－－存放密码，账号的时间设置     
	man 5 shadow     
/etc/group		－－组信息     
/etc/gshadow	－－组密码     
/etc/login.defs	--创建用户时使用的模板     
/etc/skel/*	－－用户配置文件模板     
  
user1001:X:110:120:这是一个手工创建的用户:/home/user1001:/bin/bash    
用户名:密码:uid:gid:注释:家目录:shell    
      
密码中 x 代表所有密码存放到 /etc/shadow  (把用户密码分离)      
		  
		用户密码分离  --> Linux 中 shadow 功能定义     
		shadow 定义方法     
			authconfig-tui 设定  [*]  use shadow passwords     
				使用 shadow  --> 密码存放到 /etc/shadow     
				不使用 shadow  --> 密码存放 /etc/passwd (不推荐使用)    
  
		假如把 /etc/passwd 中密码部分删除 (x 去掉)    
		用户登录为管理员或者用户切换 ( su - root ) 都不需要密码    
---  
		  
* vim /etc/shadow  
user1001$1$SefNk95S$OY4g7fMVcRNvcxLJWwW.91:14940:0:99999:7:0:14950:  
每一行9个字段，以冒号分隔，  
1）user1001 --> 用户名  
2）$1$SefNk95S$OY4g7fMVcRNvcxLJWwW.91  --> md5 加密密码  
3）14940  --> 从 1970-01-01 计算经过天数 (2010-11-27)   
4）用户最后修改密码限期  0  -->  密码最小修改限期, 假如 3 --> 14943  <- 从现在开始到 2010-11-30 才允许修改密码  
5）99999 --> 密码修改最大限期 假如15 --> 每 15 天必须改密码一次  
	\--修改 15 后 --> 14940 + 15 = 14955 = 2010-12-12 前必须修改密码  
6）7 --> 密码过期前 7 天开始警告  
7）0 --> 当密码过期后，拒绝用户登录  (3) 过期后三天内还允许修改密码，过了三天拒绝登录  
8）14500 ---> ( 1970-01-01 ) 过了 14500 天 (2011-03-01)  <- 从开始用户帐号锁定  
9）保留标志，目前没有意义  
  
```  
root:$6$7.hOPKoxZau9DJme$wrdlPcqZwPOZ5tWsN6GrZzQjJDPEJsmJdR/4CwCkiCqPWS9Co1Cej70VZdAdt4QxLY5cEgAcIoOimYjkt3QPV1:16086:0:99999:7:::  
```  
2,4-7 密码相关  
1,3,8用户相关  
9 保留  
---  
  
### 密码管理命令  
	passwd ,  usermod, chage   
  
  
chage  
	-d	->  14940  
	-m	->  0	  
	-M	->  99999  
	-W	->  7  
	-I	->  0  
	-E	->  14500  
	  
chage  
	chage -d 0 <username>			--第一次登录强制修改密码  
	chage -E 2010-10-10 <username>	--设置账号的有效期  
	chage -M 30 <username>			--设置３０天修改一次密码  
  
  
user1001:!$1$SefNk95S$OY4g7fMVcRNvcxLJWwW.91:14940:0:99999:7:::  
	  \----- 临时锁定用户  
  
usermod -L username  (锁定)  
usermod -U username  (解锁)  
  
  
#vim /etc/group  
uplooking:x:120:  
组名称 : 密码 : gid : 其他用户,其他用户,其他用户  
  
  
passwd  
	-d  去掉密码(危险)  
	-l   锁定用户  
	-u  解锁  
	-x  99999  
	-n  0  
	-w  7   
	-i  3  
	-S  了解用户密码信息状态  
  
*********************************  
如果一个！  -->【锁定用户】 "（!密文）" 先有密码，然后通过（usermod -L username )"  
如果二个！！--> 【锁定密码】“1.没有设置密码 2.锁定密码（!!密文）” （锁定 passwd -l username>）解锁passwd -u  
如果没有    -->  ”空密码登录“    （passwd -x username）  
*********************************  
  
  
  
  
passwd  
	passwd <username>	设置密码  
	passwd -l <username>	锁定  
	passwd -u <username>	解锁  
  
使用非交互模式设置密码：  
	echo "123456" | passwd --stdin test03  
	  
---  
生成密码工具  
  
* grub-md5-crypt   
  
usermod   
	-d  修改用户家目录  
	-e  设置用户密码的过期时间  
	-g	gid  
	-G	GROUP   
	-l  新的用户登录名      # usermod -l keke test01  
	-L	用户锁定  
	-s  /bin/bash ....  
	-u  uid  
	-U  解锁  
  
userdel		--删除一个用户  
	userdel <username>  
	userdel -r <username>	--删除用户时把家目录一起删除  
	usermod -g <group1> -G <group2,group3> <username>  
```  
#usermod -g root -G kiki02 kiki01  
#id kiki01  
```  
uid=2022(kiki01) gid=0(root) groups=0(root),10006(kiki02) context=root:system_r:unconfined_t:SystemLow-SystemHigh  
  
usermod	－－修改一个已经存在的用户，跟useradd的参数是一样的。  
usermod -c "你不是程序用户"  test04  
usermod -s /sbin/nologin  test04  
usermod -L <username>	锁定用户  
usermod -U <username>   解锁用户  
  
gpasswd  
	gpasswd -a kk root  --将用户kk加入root组  
	gpasswd -M user  
	gpasswd -M test01,test02,test03 kk 将test01,test02,test03用户加入到kk组  
  
# gpasswd -a kiki01 root  
正在将用户“kiki01”加入到“root”组中  
```  
[root@instructor ~]# cat /etc/group  
root:x:0:root,test05,kiki01  
```  
  
groupadd  
```  
# groupadd everyone  
# groupadd rs  
# groupadd cw  
# groupadd sc  
# useradd rs01 -g rs -G everyone  
```  
  
groupdel  
	groupdel <groupname>  
```  
[root@instructor ~]# userdel -r rs01  
[root@instructor ~]# groupdel rs  
```  
---  
授权(chmod/chown)  
|权限|对文件的影响|对目录的影响|  
|----|------------|------------|  
|r(读取)|可以读取文件的内容|可以列出目录名字(文件名)|  
|w(写入)|可以更改文件的内容|可以创建或删除目录中任一文件|  
|x(可执行)|可以作为命令执行文件|可以访问目录的内容(取决于目录中文件的权限)  
  
user    |  group  |  other  |  
4 2 1   |  4 2 1   |   4 2 1  |  
r w x   |  r w x   |   r w x  |  
  
rwx-  
	r	4	--只读  
	w	2	--写  
	x	1	--执行  
	-	0	--无权限  
  
7   rwx  
6   rw-  
5   r-x  
4   r--  
3   -wx  
2   -w-  
1   --x  
0   ---	  
  
|命令|目录所需要权限|源文件所需权限|目标目录所需权限| 备注|  
|----|--------------|--------------|----------------|-----|  
|cd  | x            |无            |无              |     |  
|ls  | r            |无            |无              |     |  
|ls -l  | r+x            |无            |无              |     |  
|mkdir  | x+w(父目录)            |无            |无              |     |  
|rmdir | x+w(父目录)            |无            |无              |     |  
|cat  | x            |r          |无              |     |  
|more  | x            |r            |无              |     |  
|mv  | x            |无所谓            |x+w              |     |  
|cp  | x            |r            |x+w             |     |  
|touch  | x+w            |无            |无              |新文件需要w老文件不需要w     |  
|rm  | x+w            |无            |无              |     |  
  
---  
  
* ls -l /test  
drwxr-xr-x. 2 root root 4096  8月  2 11:26 a  
-rw-r--r--. 1 root root    0  8月  2 11:26 a.txt  
	d	--文件夹  
	-	--普通文件  
	rwx	--拥有者的权限  
	r-x	--属组（主组）的权限  
	r-x	--除了拥有者/属组以外用户的权限（其它用户）  
	root	--拥有者  
	root	--属组	  
  
设置  
chattr  
+a  只能添加不能修改源文件内容  
+i   不允许任何操作  
....自己学习其它参数  
（ The  letters  ‘acdeijstuADST’  select the new attributes for the files:  
       append only (a), compressed  (c),  no  dump  (d),  extent  format  (e),  
       immutable (i), data journalling (j), secure deletion (s), no tail-merg-  
       ing (t), undeletable (u), no atime updates (A),  synchronous  directory  
       updates  (D),  synchronous  updates (S), and top of directory hierarchy  
       (T).）  
  
查看属性  
lsattr  
  
---  
修改权限  
  
chmod/chown/chgrp  
  
chmod	--修改文件权限  
chmod [-R] <a|u|g|o> +-= rwx- /<path>/filename  
chmod [-R] 755 /<path>/filename  
  
  
  
例子：  
	chmod o+r alex    
	chmod o=r alex  
	chmod o-r  alex  
	chmod o=- alex  
	chmod o=--- alex  
	chmod 755 alex  
	chmod 664 alex  
	  
	chown	--修改文件的拥有者/属组/其它用户的权限  
	chown [-R]	<username>.<group> /<path>/filename  
	chown		<username>:<group> /<path>/filename  
	chown		<username> /<path>/filename>  
	chown		:<group> /<path>/filename	  
	  
	chown -R alex:alex alex/  
	chown alex.alex alex/  
  
chgrp 更改文件或者目录的工作组所有权  
	chgrp -R groupname filename  
  
chgrp kk alex  
drwxr-xr-x 2 root kk  4096 Apr 14 06:09 alex  
  
[root@desktop7 tmp]# chown .kiki  xx  -- 改变所属组（chgrp kiki xx）  
  
[root@desktop7 tmp]# chown kiki. xx   ---改变所有属性 （chown kiki:kki xx）  
  
  
=====================================  
setuid/setgid/sticky  u g o  
setuid(4/s)	--冒险位，临时拥有拥有者的权限,针对二进制命令来操作  
#chmod 4755 /usr/bin/vim  
#chmod u+s /usr/bin/vim  
[root@instructor tmp]# ll -d /usr/bin/vim  
-rwxr-xr-x 1 root root 2729356 2009-06-12 /usr/bin/vim  
[root@instructor tmp]# ll -d /usr/bin/vim  
-rwsr-xr-x 1 root root 2729356 2009-06-12 /usr/bin/vim  
  
setgid(2/s)  --强制位,针对目录来操作，可以让新生成目录继承父目录的属组权限  
(小s是一开就有执行权限。而大S是一开始没有执行权限)  
chmod 2755 /test  
chmod g+s /test  
  
  
sticky	--粘滞位，在公共目录中，用户只能管理(删除)自己的文件（拥有者）  
chmod 1755 /test1  
chmod o+t /tse  
============================================  
  
  
  
  
umask	--文件生成码  
umask 0022  
umask 0027  
vim /etc/bashrc  
umask 0027	--改完后需要注销重新登录  
  
（shell/bash）用户配置  
/etc/profile		--用户配置文件（全局配置文件）  
/etc/bashrc		--bash的配置文件（全局配置文件）  
  
$HOME/.bashrc  
$HOME/.bash_prfile	－－每个用户自己的配置文件（局部）    
  
  
-----------------------------------------------------------  
手工创建用户：  
```  
vim /etc/passwd  
user1001:x:110:120:这是一个手工创建的用户:/home/user1001:/bin/bash  
vim /etc/shadow  
user1001:$1$8vhWD0$gyqMvqbn2QaKxLTwRBRtl1:15188:0:99999:7:::  
  
grub-md5-crypt   
Password: 123  
Retype password: 123  
$1$BcA1d0$wrJhjATl7u29lL3id690Z1  
  
vim /etc/shadow  
user1001:$1$BcA1d0$wrJhjATl7u29lL3id690Z1:15460:0:99999:7:::  
  
  
#vim /etc/group  
uplooking:x:120:  
  
#mkdir /home/user1001  
  
#cp  /etc/skel/.*  /home/user1001/  
  
#chown -R 110.120 /home/user1001/  
  
#chmod 700 /home/user1001/ -R  
  
#使用user1001登入用户  
```  