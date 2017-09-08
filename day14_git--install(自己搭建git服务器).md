## 在linux下面搭建Git服务器  
#### 1.安装git  
linux做为服务器端系统，windows作为客户端系统,分别安装git  
服务端:  
yum -y install git  
安装完成之后查看git版本  
客户端  
下载安装git for windows 地址https://git-for-windows.gitbub.io  
安装完成之后，可以使用git bash作为命令行客户端  
安装完成之后查看git版本  
#### 2.服务器端创建git用户，用来管理git服务并为用户设置密码  
useradd git  
passwd git  
#### 3.服务端创建git仓库  
mkdir -p data/git  
cd data/git  
git init  
chown -R git:git data  
#### 4.客户端clone远程仓库  
进入git bash 命令行客户端 创建项目地址(设置在d:)  
然后从linux git服务器上clone项目:  
git clone git@192.168.1.1:/home/data/git  
当第一次连接到目标 Git 服务器时会得到一个提示：  
The authenticity of host '192.168.56.101 (192.168.56.101)' can't be established.  
RSA key fingerprint is SHA256:Ve6WV/SCA059EqoUOzbFoZdfmMh3B259nigfmvdadqQ.  
Are you sure you want to continue connecting (yes/no)?  
选择 yes：  
Warning: Permanently added '192.168.56.101' (RSA) to the list of known hosts.  
此时 C:\Users\用户名\.ssh 下会多出一个文件 known_hosts，以后在这台电脑上再次连接目标 Git 服务器时不会再提示上面的语句。  
#### 5.客户端创建ssh公钥和私钥  
ssh-keygen -t rsa -C "saadasdad"  
此时 c:\User\adminsitrator\.ssh下面会多出两个文件id_rsa和id_rsa.pub  
id_rsa是私钥  
id_rsa.pub是公钥  
#### 6.在服务器端git打开RSA认证  
进入/etc/ssh目录 编辑sshd_config 打开以下三个配置的注释:  
RSAAuthentication yes  
PubkeyAuthentication yes  
AuthorizedKeysFile .ssh/authorized_keys  
保存并重启sshd服务:  
/etc/init.d/sshd restart  
由 AuthorizedKeysFile 得知公钥的存放路径是 .ssh/authorized_keys，实际上是 $Home/.ssh/authorized_keys，由于管理 Git 服务的用户是 git，所以实际存放公钥的路径是 /home/git/.ssh/authorized_keys  
在 /home/git/ 下创建目录 .ssh  
[root@localhost git]# pwd  
/home/git  
[root@localhost git]# mkdir .ssh  
[root@localhost git]# ls -a  
. .. .bash_logout .bash_profile .bashrc .gnome2 .mozilla .ssh  
然后把 .ssh 文件夹的 owner 修改为 git  
  
[root@localhost git]# chown -R git:git .ssh  
#### 7.将客户端公钥导入服务器端/home/git/.shh/authorized_keys文件  
回到git bash 导入文件  
ssh git@192.168.1.1 'cat >> .ssh/authorized_keys' < ~/.ssh/id_ras.pub  
需要输入服务端git用户的密码  
回到服务器端查看.ssh是否存在authorized_keys文件  
#### 重要:  
修改.ssh目录的权限为700  
修改.ssh/authorized_keys文件的权限为600  
chmod 700 .ssh  
cd .ssh  
chmod 600 authorized_keys  
#### 8.客户端再次clone远程仓库  
git clone git@192.168.1.1:/home/data/git/git..sdas  