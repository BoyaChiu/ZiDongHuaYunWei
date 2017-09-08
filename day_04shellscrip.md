### 1.建立和运行shell程序    
什么是shell程序呢? 简单的说shell程序就是一个包含若干行    
shell或者linux命令的文件.    
象编写高级语言的程序一样,编写一个shell程序需要一个文本编辑器.如VI等.    
在文本编辑环境下,依据shell的语法规则,输入一些shell/linux命令行,形成一个完整的程序文件.    
执行shell程序文件有三种方法    
(1)#chmod +x file    
(2)#sh file    
(3)# . file    
在编写shell时,第一行一定要指明系统需要那种shell解释你的shell程序,如:#!/bin/bash    
Unix/Linux上常见的Shell脚本解释器有bash、sh、csh、ksh等，习惯上把它们称作一种Shell。我们常说有多少种Shell，其实说的是Shell脚本解释器。
### 2.shell中的变量    
(1)常用系统变量    
\# :保存程序命令行参数的数目    
? :保存前一个命令的返回码    
0 :保存程序名    
* :以(" 1 2...")的形式保存所有输入的命令行参数 所有的参数会被当做一个字符串    
@ :以(" 1"" 2"...)的形式保存所有输入的命令行参数 所有的参数会以空格做分隔符单做一个字符串    

#### (2)定义变量    
shell语言是非类型的解释型语言,不象用C++/JAVA语言编程时需要事先声明变量.给一个变量赋值,实际上就是定义了变量.    
在linux支持的所有shell中,都可以用赋值符号(=)为变量赋值.    
如:  abc=9    
由于shell程序的变量是无类型的,所以用户可以使用同一个变量时而存放字符时而存放整数.  如:name=abc (bash/pdksh)     
在变量赋值之后,只需在变量前面加一个 去引用.    
如:  echo abc    
#### (3)位置变量    
当运行一个支持多个命令行参数的shell程序时,这些变量的值将分别存放在位置变量里.   其中第一个参数存放在位置变量1,第二个参数存放在位置变量2,依次类推...,shell保留这些变量,不允许用户以令外的方式定义他们.同别的变量,用 符号引用他们.    
### 3.shell中引号的使用方法    
shell使用引号(单引号/双引号)和反斜线("")用于向shell解释器屏蔽一些特殊字符.   反引号(")对shell则有特殊意义.    
如: abc="how are you" (bash/pdksh)    
这个命令行把三个单词组成的字符串how are you作为一个整体赋值给变量abc.    
abc1='$LOGNAME,how are you!' (bash/pdksh)    
abc2="$LOGNAME,how are you!" (bash/pdksh)    
LOGNAME变量是保存当前用户名的shell变量,假设他的当前值是:wang.执行完两条命令后, abc1的内容是LOGNAME, how are you!.而abc2的内容是;wang, how are you!.    
象单引号一样,反斜线也能屏蔽所有特殊字符.但是他一次只能屏蔽一个字符.而不能屏蔽 一组字符.    
反引号的功能不同于以上的三种符号.他不具有屏蔽特殊字符的功能.但是可以通过他将一个命令的运行结果传递给另外一个命令.    
如:    
contents=`ls` (bash/pdksh)    
### 4.shell程序中的test命令    
在bash/pdksh中,命令test用于计算一个条件表达式的值.他们经常在条件语句和循环语句中被用来判断某些条件是否满足.    
test命令的语法格式:    
test expression    
或者    
[expression]    
在test命令中,可以使用很多shell的内部操作符.这些操作符介绍如下:    
(1)字符串操作符 用于计算字符串表达式    
test命令 | 含义   
Str1 = str2 | 当str1与str2相同时,返回True    
Str1! = str2| 当str1与str2不同时,返回True    
Str | 当str不是空字符时,返回True    
-n str | 当str的长度大于0时,返回True    
-z str | 当str的长度是0时,返回True    
#### (2)整数操作符具有和字符操作符类似的功能.只是他们的操作是针对整数    
test表达式 | 含义    
Int1 -eq int2|当int1等于int2时,返回True    
Int1 -ge int2|当int1大于/等于int2时,返回True    
Int1 -le int2|当int1小于/等于int2时,返回True    
Int1 -gt int2|当int1大于int2时,返回True    
Int1 -ne int2|当int1不等于int2时,返回True    
#### (3)用于文件操作的操作符,他们能检查:文件是否存在,文件类型等    
test表达式 | 含义    
-d file |当file是一个目录时,返回 True    
-f file |当file是一个普通文件时,返回 True    
-r file |当file是一个刻读文件时,返回 True    
-s file |当file文件长度大于0时,返回 True   
-w file |当file是一个可写文件时,返回 True  
-x file |当file是一个可执行文件时,返回 True  
#### (4)shell的逻辑操作符用于修饰/连接包含整数,字符串,文件操作符的表达式  
test表达式 | 含义  
! expr |当expr的值是False时,返回True  
Expr1 -a expr2|当expr1,expr2值同为True时,返回True  
Expr1 -o expr2|当expr1,expr2的值至少有一个为True时,返回True  
### 5.条件语句  
同其他高级语言程序一样,复杂的shell程序中经常使用到分支和循环控制结构,  
bash,pdksh分别都有两种不同形式的条件语句:if语句和case语句.  
#### (1)if语句  
语法格式:  
bash/pdksh用法:  
if [expression1]  
then  
commands1  
elif [expression2]  
commands2  
else  
commands3  
if  
含义:当expression1的条件为True时,shell执行then后面的commands1命令;当  
expression1的条件为false并且expression2的条件满足为True时,shell执行  
commands2命令;当expression1和expressin2的条件值同为false时,shell执行  
commands3命令.if语句以他的反写fi结尾.  
#### (2)case语句  
case语句要求shell将一个字符串S与一组字符串模式P1,P2,...,Pn比较,当S与  
某个模式Pi想匹配时,就执行相应的那一部分程序/命令.shell的case语句中字符  
模式里可以包含象*这样的通配符.  
语法格式:  
bash/pdksh用法:  
case string1 in  
str1)  
commands1;;  
str2)  
commands2;;  
*)  
commands3;;  
esac  
含义:shell将字符串string1分别和字符串模式str1和str2比较.如果string1与str1匹配,则shell执行commands1的命令/语句;如果string11和str2匹配,则shell执行commands2的命令/语句.否则shell将执行commands3的那段程序/命令.其中,每个分支的程序/命令都要以两个分号(;;)结束.      
### 6.循环语句  
当需要重复的某些操作时,就要用到循环语句  
#### (1)for语句  
大家知道在很多编程语言中for语句是最常见.在shell中也不例外.for语句要求shell将包含  
在这个语句中的一组命令连续执行一定的次数.  
语法格式:  
bash/pdksh  
用法1:  
for var1 in list  
do  
commands  
done  
含义:在这个for语句中,对应于list中的每个值,shell将执行一次commands代表的一组命令.  
在整个循环的每一次执行中,变量var1将依此取list中的不同的值.  
用法2:  
for var1  
do  
setatements  
done  
含义:在这个for语句中,shell针对变量var1中的每一项分别执行一次statements代表的一组  
命令.当使用这种形式的语句时,shell认为var1变量中包含了所有的位置变量,而位置变量中  
存放着程序的命令行参数值.也就是说,他等价于下列形式:  
for var1 in " @"  
do  
statements  
done  
举例:  
for file ;bash/pdksh  
do  
tr a-z A-Z< file>file.caps  
done  
#### (2)while语句  
while语句是shell提供的另一种循环语句. while语句指定一个表达式和一组命令.这个语句使得shell重复执行一组命令,直到表达式的值为False为止.  
语法格式:  
while expression ;bash  
do  
statements  
done  
while (expression) ;tcsh  
statements  
end  
举例:  
count=1 ;bash  
while [ -n " *"] ***  
do  
echo "this is a parameter number count 1"  
shift  
count='expr count + 1'  
done  
set count = 1 ;tcsh  
while ( " * " ! = "")  
echo "this is a parameter number count 1"  
shift  
set count = 'expr count + 1'  
end  
语句中shift命令的功能是将所有的命令行参数依次相左传递.  
### 7.shell中的函数  
shell允许用户定义自己的函数.函数是高级语言中的重要结构.shell中的函数于C或  
者其他  
语言中定义的函数一样.与从头开始,一行一行地写程序相比,使用函数主要好处是有  
利于组织  
整个程序.在bash中,一个函数的语法格式如下:  
fname (){  
shell comands  
}  
定义好函数后,需要在程序中调用他们.bash中调用函数的格式:  
fname [parm1 parm2 parm3...]  
调用函数时,可以向函数传递任意多个参数.函数将这些参数看做是存放他的命令行参数的 位置变量  
总结  
利用shell编程是提高系统管理工作效率的重要手段,学好shell跟了解系统基本命令  
和管理工具的使用方法同样重要!  
附:  
#### A.bash中常用的命令  
命令 | 含义  
& 把程序放到后台执行
ctrl + z  可以将一个正在前台执行的命令放到后台，并且暂停
Alias |设置命令别名  
Bg |将一个被挂起的进程在后台执行  
cd |改变用户的当前目录  
exit |终止一个shell  
export |使作为这个命令的参数的变量及其当前值,在当前运行的shell的子进程中可见  
fc |编辑当前的命令行历史列表  
fg |让一个被挂起的进程在前台执行  
help |显示bash内部命令的帮助信息  
history |显示最近输入的一定数量的命令行  
kill |终止一个进程  
pwd |显示用户当前工作目录  
unalias |删除命令行别名  
#### B.bash中常用的系统变量  
变量 | 含义  
EDITOR,FCEDIT |Bash的fc命令的默认文本编辑器  
HISTFILE |规定存放最近输入命令行文件的名字  
HISTSIZE |规定命令行历史文件的大小  
HOME |当前用户的宿主目录  
OLDPWD |用户使用的前一个目录  
PATH |规定bash寻找可执行文件时搜索的路径  
PS1 |命令行环境中显示第一级提示符号  
PS2 |命令行环境中显示第二级提示符号  
PWD |用户当前工作目录  
SECONDS |当前运行的bash进程的运行时间(以秒为单位)一  
#### 排序统计相关的：wc sort uniq  
wc  
-l 显示行数  
-w 显示单词数  
-m 显示字符数  
默认不加参数，就是相当于上面三个参数都加  
[root@li shell01]# cat /etc/passwd |wc -l  
79  
[root@li shell01]# cat /etc/passwd |wc -w  
106  
[root@li shell01]# cat /etc/passwd |wc -m  
3374  
[root@li shell01]# cat /etc/passwd |wc  
79 106 3374  
wc -L 算一个文件里最长一行有多少个字符  
sort 排序命令  
[root@li shell01]# cat /etc/passwd |  
sort --默认以开头字母排序  
-r 反向排序  
-n 以数字来排  
-f 大小写不敏感  
-t 分隔符  
-k 接数字代表第几列  

cut [-bn] [file] 或 cut [-c] [file] 或 cut [-df] [file]  
cut 命令从文件的每一行剪切字节、字符和字段并将这些字节、字符和字段写至标准输出。  
如果不指定 File 参数，cut 命令将读取标准输入。必须指定 -b、-c 或 -f 标志之一。  
-b ：以字节为单位进行分割。这些字节位置将忽略多字节字符边界，除非也指定了 -n 标志。  
-c ：以字符为单位进行分割。  
-d ：自定义分隔符，默认为制表符。  
-f ：与-d一起使用，指定显示哪个区域。  
-n ：取消分割多字节字符。仅和 -b 标志一起使用。如果字符的最后一个字节落在由 -b 标志的 List 参数指示的<br />范围之内，该字符将被写出；否则，该字符将被排除。  
[root@li ~]# cut -d -f  
[root@li ~]# sort -t -k  
[root@li ~]# awk -F n  
[root@li shell01]# cat /etc/passwd |sort -t ":" -k 3 --以UID来排序，但是它只会以数字的第一个数字来排也就是说 2要排到14的后面  
[root@li shell01]# cat /etc/passwd |sort -t ":" -k 3 -n --多加一个-n参数，才会以整个的数字大小来排序  
uniq 唯一命令  
默认是以连续的重复值内只取一个  
[root@li shell01]# cat /etc/passwd |cut -d ":" -f7 |uniq |grep bash  
/bin/bash  
/bin/bash  
/bin/bash  
/bin/bash  
[root@li shell01]# cat /etc/passwd |cut -d ":" -f7 |grep bash |uniq  
/bin/bash  
--在管道用得多的情况下，命令的顺序会造成很大的结果不同  
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－  
练习：  
对有下面内容的文件进行操作  
http://a.domain.com/1.html  
http://b.domain.com/1.html  
http://c.domain.com/1.html  
http://a.domain.com/2.html  
http://a.domain.com/3.html  
http://b.domain.com/3.html  
http://c.domain.com/2.html  
http://c.domain.com/3.html  
http://a.domain.com/1.html  
得到下面的结果  
4 a.domain.com  
3 c.domain.com  
2 b.domain.com  
cat 1.txt |cut -d"/" -f3 |sort|uniq -c |sort -n -r  
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
#### sed的用法  
sed的语法:sed '样式命令'文件  
意思是 如果文件中的某一行符合样式，就执行指定的sed命令 如删除(d)替换是(s)  
“样式”使用一对//含括，表示寻找的意思。也可以指定数据行的范围：如1,6  
注意 sed不加"-i"的情况下是不修改文件内容的 只是读取文件的内容 >>  
g 与s使用表示全局匹配替换  
p 打印匹配行  
s 替换  
-n 取消默认输出  
-e 允许多项编辑  
-i 修改原文件  
sed删除用法  
sed ‘1,4d’dataf1 #把第一行到第四行删除，并且显示剩下的内容  
sed ‘/La/d’dataf2 #把含有La的行删除  
sed '/La/!d' dataf2  #把不含La的行删除，!是否定的意思  
sed ‘/[0-9]{3}/d’dataf3#把有”3位数”的行删除sed  
sed '/^$/d' dataf5  #删除空行  
sed 显示用法  
sed -n '/La/p' dataf2#显示含有La的行  
sed 替换用法(把-n 换成-i 就是直接替换原文件了)  
sed -n 's/La/Oo/p' dataf2 #把La替换为Oo-n是抑制sed显示其他行  
sed -n 's/La//p' dataf2 #把La替换为空  
sed -n 's/La/Oo/gp' dataf2  #加g是全局替换的意思  
sed -n 's/^...//p' dataf2  #把每行开头的3个字符替换为空  
sed -n 's/...$//p' dataf2 #把每行结尾的3个字符替换为空  
sed -n 's/La/10o/p' dataf2 #替换  
sed -n '/AAA/s/234/567/p' dataf6#找到含有AAA的行，然后把234替换成567  
sed -n '/AAA/,/DDD/s/B/567/p' dataf7#找到含有AAA到DDD的那几行，将B替换成567   
sed -n '/AAA/,/DDD/s/B/567/gp' dataf7   #全局
#### awk的用法  
awk的工作方式是读取数据文件，将每行数据视为一条记录，每笔记录以字段分隔成若干个字段,然后输出各个字段的值  
awk的常用格式  
awk "样式" 文件 : 把符合样式的数据行显示出来  
awk '{操作}' 文件: 对每一行都执行{}中的操作  
awk '样式{操作}' 文件: 对符合样式的数据行，执行{}中的操作  
awk的示例  
awk '/La/' dataf3 #显示含有La的数据行  
awk '{print $1, $2}' dataf3 #显示dataf3每一行的第一个和第二个字段  
awk ‘/La/{print $1, $2}’ dataf3#将含有关键词La的数据行的第1和第2个字段显示  
awk -F: '/^ceshi/{print $3, $4}' /etc/passwd #用-F指定:为分隔符，账号ols3的第三段和第四段显示  
awk -F: 'BEGIN{OFS="+++"}/^mail/{print $1, $2, $3, $4, $5, $6, $7}' /etc/passwd
OFS的作用是存储输出字段的分隔符  
awk应用  
取网卡的IP地址  
ifconfig |sed -n '2p' |awk -F: ‘{print 2}’ |awk '{print 1}'  
取网络设备的名称:  
cat /proc/net/dev/sed -n '4p'|awk -F: '{print $1}'  
取系统内存大小  
cat /proc/meminfo |awk '/MemTotal/{print $1,$2}'
cat /proc/meminfo |sed -n '1p'  