inventory参数介绍

ansible_ssh_host
将要连接的远程主机名.与你想要设定的主机的别名不同的话,可通过此变量设置.

ansible_ssh_port
ssh端口号.如果不是默认的端口号,通过此变量设置.

ansible_ssh_user
默认的 ssh 用户名

ansible_ssh_pass
ssh 密码(这种方式并不安全,我们强烈建议使用 --ask-pass 或 SSH 密钥)

ansible_sudo_pass
sudo 密码(这种方式并不安全,我们强烈建议使用 --ask-sudo-pass)

ansible_sudo_exe (new in version 1.8)
sudo 命令路径(适用于1.8及以上版本)

ansible_connection
与主机的连接类型.比如:local, ssh 或者 paramiko. Ansible 1.2 以前默认使用 paramiko.1.2 以后默认使用 'smart','smart' 方式会根据是否支持 ControlPersist, 来判断'ssh' 方式是否可行.

ansible_ssh_private_key_file
ssh 使用的私钥文件.适用于有多个密钥,而你不想使用 SSH 代理的情况.

ansible_shell_type
目标系统的shell类型.默认情况下,命令的执行使用 'sh' 语法,可设置为 'csh' 或 'fish'.

ansible_python_interpreter
目标主机的 python 路径.适用于的情况: 系统中有多个 Python, 或者命令路径不是"/usr/bin/python",比如 *BSD, 或者 /usr/bin/python
不是 2.X 版本的 Python.我们不使用 "/usr/bin/env" 机制,因为这要求远程用户的路径设置正确,且要求 "python" 可执行程序名不可为 python以外的名字(实际有可能名为python26).

与 ansible_python_interpreter 的工作方式相同,可设定如 ruby 或 perl 的路径....


参数	说明
-a	‘Arguments’, —args=’Arguments’ 命令行参数
-m	NAME, —module-name=NAME 执行模块的名字，默认使用 command 模块，所以如果是只执行单一命令可以不用 -m参数
-i PATH,	—inventory=PATH 指定库存主机文件的路径,默认为/etc/ansible/hosts.
-u Username，	—user=Username 执行用户，使用这个远程用户名而不是当前用户
-U	—sud-user=SUDO_User sudo到哪个用户，默认为 root
-k	—ask-pass 登录密码，提示输入SSH密码而不是假设基于密钥的验证
-K	—ask-sudo-pass 提示密码使用sudo
-s	—sudo sudo运行
-S	—su 用 su 命令
-l	—list 显示所支持的所有模块
-s	—snippet 指定模块显示剧本片段
-f	—forks=NUM 并行任务数。NUM被指定为一个整数,默认是5。 #ansible testhosts -a “/sbin/reboot” -f 10 重启testhosts组的所有机器，每次重启10台
—private-key=PRIVATE_KEY_FILE	私钥路径，使用这个文件来验证连接
-v	—verbose 详细信息
all	针对hosts 定义的所有主机执行
-M MODULE_PATH,	—module-path=MODULE_PATH 要执行的模块的路径，默认为/usr/share/ansible/
—list-hosts	只打印有哪些主机会执行这个 playbook 文件，不是实际执行该 playbook 文件
-o —one-line	压缩输出，摘要输出.尝试一切都在一行上输出。
-t Directory,	—tree=Directory 将内容保存在该输出目录,结果保存在一个文件中在每台主机上。
-B	后台运行超时时间
-P	调查后台程序时间
-T Seconds,	—timeout=Seconds 时间，单位秒s
-P NUM,	—poll=NUM 调查背景工作每隔数秒。需要- b
-c Connection,	—connection=Connection 连接类型使用。可能的选项是paramiko(SSH),SSH和地方。当地主要是用于crontab或启动。
—tags=TAGS	只执行指定标签的任务 例子:ansible-playbook test.yml –tags=copy 只执行标签为copy的那个任务
—list-tasks	列出所有将被执行的任务
-C,	—check 只是测试一下会改变什么内容，不会真正去执行;相反,试图预测一些可能发生的变化
—syntax-check	执行语法检查的剧本,但不执行它
-l  SUBSET,	—limit=SUBSET 进一步限制所选主机/组模式 –limit=192.168.0.15 只对这个ip执行
—skip-tags=SKIP_TAGS	只运行戏剧和任务不匹配这些值的标签 —skip-tags=copy_start
-e  EXTRA_VARS,	—extra-vars=EXTRA_VARS 额外的变量设置为键=值或YAML / JSON
-l	—limit 对指定的 主机/组 执行任务 —limit=192.168.0.10，192.168.0.11 或 -l 192.168.0.10，192.168.0.11 只对这个2个ip执行任务