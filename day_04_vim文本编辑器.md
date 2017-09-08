### 文本编辑器
vi   vim      emacs    gedit 


--由两个不同的软件包所提供
[root@li /]# rpm -qf `which vi`
vim-minimal-7.0.109-6.el5
[root@li /]# rpm -qf `which vim`
vim-enhanced-7.0.109-6.el5

which vi |xargs rpm -qf
vim-minimal-7.0.109-6.el5

vi    vim （增强版vi，现在基本各种linux版本都带有vim)

cp /etc/passwd /tmp/
vim /tmp/passwd	--现在打开，没有颜色，因为passwd不是在它应该在的路径，vim是可以区分出来的


		              命令模式
     iIaAoO|ESC /       \:|ESC
        输入模式        末行模式

1.命令模式()：
	            yy	3yy    shift+6	shift+4		                        p/P
　　复制一行	３行　光标行首　光标行尾　行后粘貼/行前粘貼
	dd	3dd     HOME	 END
	u(undo)	--撤消
	yw 选定光标所在行复制
	行内快跳：home/end 或　shift+^ shift+$
	行间快跳：gg:跳到第一行　 G：跳到最后一行
		　10gg:跳到１０行
	
	
	删除，复制，粘贴
	x	向后删除一个字符 ＝ delete
	X	往前删除一个字符 ＝ backspace
	--dd	直接删除光标所在行	ndd  （n代表数字，删除n行）
	--yy	复制光标所在行	nyy	(n代表数字，复制n行）
	--p	粘贴
	--u	回退上一次操作     按一次u只能回退一次
	ctrl+r	重做上一次操作

	
		
	移动相关：
	--ctrl+b 向上翻页  ＝ page up
	--ctrl+f 向下翻页  = page down
	ctrl+d 向下移动半页
	ctrl+u 向上移动半页
	--G	移动到页末 ＝shift +g
	--gg	移动到页头
	--0	移动到行头 ＝ home
	--$	移动到行末  = end
	n(代表数字）＋回车   向下移动N行  	
h 左<--
l  右-->
k 上	
j  下	
		
２.模式行模式：
	命令模式-(:)->末行模式	
	查找：/关键字，向下匹配按n，向上匹配按Ｎ
	　　　？关键字，反向查找
	:set number [set nu]      --设置编码 （set nonumber）	
	# vim /etc/vimrc 
 set number		--在一个空白的地方加上（不要加到代码段里去了），以后使用vim打开任意文件，都会自动显示行号

	:w			--保存
	:wq			－－保存退出
	:wq!			－－  强制保存退出
	:q!			－－不保存退出
	:e!			-可以撤消所有的修改至打开文件的
	:w /tmp/a.txt		－－另存为   强制保存 w! /tmp/a.txt
	:1,10w /tmp/b.txt	--1到１０行另存为
	:r /etc/passwd		--从另一个文件中read入
	:%s/root/ROOT		--在整个文件中搜索每一行的第一个this替换that
	:%s/root/ROOT/g		--在整个文件中搜索每一行this替换that
	:%s/this/that/gc
	:%s#/sbin/nologin#/xbin/login#g
	
--在整个文件中搜索每一行this替换that,每一个都需要确认

	3.输入模式：
	命令模式-(iIaAoO)->输入模式
	i	--在当前光标处进入输入模式	
	I	--在行首进入输入模式
	a	--在当前光标的后一个位进入输入模式
	A	--在当前行末进入输入模式
	o	--在当前光标的下一行插入空行并进入输入模式
	O	--在当前光标的上一行插入空行并进入输入模式
	r	--替换光标所在的字符
	R	--从光标处向后一直替换
总结：打开文件-->命令模式-(iIaAoO)-->输入模式（输入用户自定义内容）-(ESC)->命令模式－(:)－>末行模式－(:wq)－》保存退出


vim -o /tmp/a.txt /tmp/b.txt ...
vim -O /tmp/a.txt /tmp/b.txt ...       切换ctrl+ww


--当两个终端同时打开的话，会产生一个.swap文件
如：你打开/tmp/passwd文件，会产生/tmp/.passwd.swap
解决方法是：直接删除掉它就可以了
rm /tmp/.passwd.swp 
=================================================================================

