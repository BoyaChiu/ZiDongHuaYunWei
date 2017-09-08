本章目录：  
１、ＲＰＭ的概述及用途  
２、制作一个简单的ＲＰＭ包  
３、从src ＲＰＭ包制作ＲＰＭ包  
４、以nginx源码包为例制作ＲＰＭ包  
５、给ＲＰＭ包签名，并制作成ＹＵＭ源  
  
  
１、ＲＰＭ的概述及用途  
１）RPM包管理工具（简称RPM，全称为The RPM Package Manager）是在Linux下广泛使用的软件包管理器。最早由Red Hat研制，现在也由开源社区开发。RPM通常随附于Linux发行版，但也有单独将RPM作为应用软件发行的发行版。RPM仅适用于安装用RPM来打包的软件，目前是GNU/Linux下软件包资源最丰富的软件包类型  
  
xxx-version.rpm	--redhat suse....  
xxx-veriosn.deb	--debian/ubuntu  
  
２）RPM包管理具体的用途；  
1、快速安装、删除、升级和管理软件，也支持在线安装和升级软件；  
2、通过RPM包管理能知道软件包包含哪些文件，也能知道系统中的某个文件属于哪个软件包；  
3、可以在查询系统中的软件包是否安装以及其版本；  
4、作为开发者可以把自己的程序打包为RPM包发布，减少软件安装前的配置及编译所花耗的时间；  
5、软件包签名GPG和MD5的导入、验证和签名发布,防止软件被篡改。  
6、依赖性的检查，查看是否有软件包由于不兼容而扰乱了系统；  
  
  
  
１、制作一个简单的ＲＰＭ包  
  
RHEL5制作地目录结构介绍（作坊地址）RHEL6:$HOME/rpmbuild：  
# ls /usr/src/redhat/ -l  
drwxr-xr-x 3 root root 4096 03-11 10:24 BUILD	－－源码解压目录  
drwxr-xr-x 9 root root 4096 12-20 17:27 RPMS	－－RPM包（成品）  
drwxr-xr-x 2 root root 4096 03-20 09:48 SOURCES	－－源码的目录（tar.gz）  
drwxr-xr-x 2 root root 4096 03-20 09:44 SPECS	－－xx.spec(makefile)  
drwxr-xr-x 2 root root 4096 2009-07-24 SRPMS	－－src.rpm=xx.spec+tar.gz  
  
1)创建一个xx.tar.gz的源码包，包中只包含一个hello.sh的脚本  
# mkdir ~/hello-1.0  
# cd ~/hello-1.0  
# echo -e '#!/bin/bash\necho "hello world! "' > hello.sh  
# cd ../  
# tar -czvf /usr/src/redhat/SOURCES/hello-1.0-1.tar.gz hello-1.0/  
  
2)创建xx.spec配置文件，这个文件相当于源码安装的makefile  
# vim /usr/src/redhat/SPECS/hello.spec  
Name: hello  
Version: 1.0  
Release: 1  
Summary: This is a Hello script.  
Group: Admin  
License: GPL  
URL: http://www.xxx.com  
Source0: %{name}-%{version}-%{release}.tar.gz  
BuildRoot: /var/tmp/%{name}-buildroot  
%description  
Installs /root/bin/hello.sh,can print "Hello World!" on your screen.  
  
%prep  
%setup -q -n %{name}-%{version}  
  
%build  
  
%install  
rm -rf $RPM_BUILD_ROOT  
mkdir -p $RPM_BUILD_ROOT/root/bin  
install -m 755 hello.sh $RPM_BUILD_ROOT/root/bin/hello.sh  
  
%clean  
rm -rf $RPM_BUILD_ROOT  
  
%files  
%defattr(-,root,root,-)  
/root/bin/hello.sh  
  
%changelog  
  
参数说明：  
Name:	－－包名称  
Version:	－－版本  
Release:	1%{?dist}	－－版本发布的次数  
Summary:	－－说明信息  
Group:	－－属于哪个group,这个就是yum grouplist对应的内容  
License:	－－版权信息  
URL:	－－软件包的主页，可用于网站宣传和帮助用户找到官方网站  
Source0:	－－相关输入文件定义  
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)	－－相关编译目录定义  
  
BuildRequires:	－－创建此ＲＰＭ包所依赖的软件包  
Requires:	－－安装此ＲＰＭ包所依赖的软件包，可通过rpm -qR查询得到  
  
%description	－－给ＲＰＭ包简要的描述信息  
  
%prep	－－前期准备  
%setup -q	－－解压源代码包，生成在BUILD目录之下  
  
%build	－－编译  
%configure	－－相当于./configure  
make %{?_smp_mflags}	－－相当于make  
  
%install	－－相当于make install  
rm -rf %{buildroot}  
make install DESTDIR=%{buildroot}  
  
%clean	－－相当于make clean,在编译完成之后的清除临时文件操作  
rm -rf %{buildroot}  
  
%files	--RPM 包的逐项文件清单，rpm -ql  
%defattr(-,root,root,-)	--权限设置  
%doc  
  
%changelog	－－发行注记  
  
  
  
3)根据spec文件把hello.tar.gz编译成ＲＰＭ包  
# rpm -q rpm-build	－－首先确认是否有rpm的制作工具和编译环境（gcc）  
rpm-build-4.4.2.3-18.el5  
  
# rpmbuild -ba /usr/src/redhat/SPECS/hello.spec －－由于我们这个ＲＰＭ包只有一个文件，而且是脚本，所以不需要编译  
rpmbuild -ba	--从xx.spec创建srcrpm源码包和RPM包  
-bb	--从xx.spec创建RPM包  
-bp	--不创建包，只解压并且打补丁  
  
# ls /usr/src/redhat/RPMS/i386/  
hello-1.0-1.i386.rpm hello-debuginfo-1.0-1.i386.rpm	－－成功编译出来的ＲＰＭ包  
  
# ls /usr/src/redhat/SOURCES/  
hello-1.0-1.tar.gz	－－成功编译出来的源码包  
  
# rpm -qpl /usr/src/redhat/RPMS/i386/hello-1.0-1.i386.rpm  
/root/bin/hello.sh  
  
２、通过SRCRPM包制作RPM包  
SRCRPM包的作用中要用于升级红帽自带的ＲＰＭ包，因为软件包中带了很多patch包  
  
下载zip的src.rpm包，并安装，查看spec文件，进一步理解rpm构建流程。  
# wget ftp://ftp.redhat.com/redhat/linux/enterprise/5Server/en/os/SRPMS/zip-2.31-2.el5.src.rpm  
  
# rpm -ivh zip-2.31-2.el5.src.rpm －－安装src.rpm包，在RHEL5默认安装在/usr/src/redhat目录中  
  
# rpm -qpl zip-2.31-2.el5.src.rpm  
warning: zip-2.31-2.el5.src.rpm: Header V3 DSA signature: NOKEY, key ID 37017186  
exec-shield.patch  
zcrypt29.tar.gz  
zip-2.3-currdir.patch  
zip-2.31-configure.patch  
zip-2.31-install.patch  
zip-2.31-near-4GB.patch  
zip-2.31-umask_mode.patch  
zip.spec  
zip23-umask.patch  
zip23.patch  
zip231.tar.gz  
  
# less /usr/src/redhat/SPECS/zip.spec --查看并分析spec配置文件  
# rpmbuild -bb /usr/src/redhat/SPECS/zip.spec	－－制作ＲＰＭ包，这次只制作rpm包，不再创建源码包。  
# ls /usr/src/redhat/RPMS/i386/zip-*  
/usr/src/redhat/RPMS/i386/zip-2.31-2.i386.rpm /usr/src/redhat/RPMS/i386/zip-debuginfo-2.31-2.i386.rpm  
  
  
３、以nginx为例制作ＲＰＭ包  
# mv nginx-1.2.2.tar.gz /usr/src/redhat/SOURCES/  
# vim /usr/src/redhat/SPEC/nginx.spec  
Summary: nginx 'engine x' is a HTTP server and mail proxy server  
Name: nginx  
Version: 1.2.2  
Release: 1  
Source0: %{name}-%{version}.tar.gz  
License: MIT  
Group: Applications/Internet  
Buildroot: %{_tmppath}/%{name}-%{version}-root  
Requires: bash  
%description  
nginx has been running for more than three years on many heavily loaded Russian sites  
including Rambler (RamblerMedia.com).  
In March 2007 about 20% of all Russian virtual hosts were served or proxied by nginx.  
According to Google Online Security Blog year ago nginx served or proxied about 4% of  
all Internet virtual hosts, although Netcraft showed much less percent.  
According to Netcraft in March 2008 nginx served or proxied 1 million virtual hosts.  
  
%prep  
%setup -q -n %{name}-%{version}  
  
%build  
./configure \  
--user=nginx \  
--group=nginx \  
--prefix=/var/nginx \  
--with-http_stub_status_module \  
--with-http_ssl_module \  
--with-md5=/usr/lib \  
--with-sha1=/usr/lib \  
--conf-path=/etc/nginx/nginx.conf \  
--error-log-path=/var/log/nginx/error_log \  
--pid-path=/var/run/nginx.pid \  
--lock-path=/var/run/nginx.lock \  
--http-log-path=/var/log/nginx/access_log \  
--sbin-path=/usr/sbin/nginx  
make  
  
%install  
rm -rf $RPM_BUILD_ROOT  
make DESTDIR=$RPM_BUILD_ROOT install  
mkdir -p $RPM_BUILD_ROOT/etc/init.d/  
mkdir -p $RPM_BUILD_ROOT/var/log/nginx  
install -m 755 nginx.init.d $RPM_BUILD_ROOT/etc/init.d/nginx  
  
%clean  
rm -rf $RPM_BUILD_ROOT  
  
%pre  
id -u nginx &> /dev/null || %{_sbindir}/useradd -c "Nginx user" -s /sbin/nologin -r -d /dev/null nginx 2>/dev/null  
  
%post  
if [ $1 = 1 ]; then	--$1　0代表卸载、1代表安装、2代表升级  
/sbin/chkconfig --add nginx  
fi  
if [ $1 = 2 ]; then  
/sbin/service %{name} upgrade  
fi  
  
%preun	--卸载前执行的脚本  
if [ $1 = 0 ]; then  
/sbin/service %{name} stop >/dev/null 2>&1  
/sbin/chkconfig --del %{name}  
fi  
  
%files  
%defattr(-,root,root)  
/usr/sbin/nginx  
/var/log/nginx  
/var/nginx/html  
/etc/nginx  
/etc/init.d/nginx  
  
%changelog  
* Sun Jan 5 2012 luowenfeng <cc@cc.com> - 1.2.2  
-nginx rpm package made by luowenfeng  
  
# rpmbuild -bb /usr/src/redhat/SPECS/nginx.spec  
# ls /usr/src/redhat/RPMS/i386/nginx-0.8.42-1.i386.rpm  
/usr/src/redhat/RPMS/i386/nginx-0.8.42-1.i386.rpm  
  
  
４、给ＲＰＭ包签名，并制作成ＹＵＭ源  
GnuPG 和 RPM签名  
你应该对由你创建的所有包签名。签名有助于系统和系统管理员确认包真实来自于你而非其他试图冒充你的人。在自动更新站点这个功能尤为重要，比如RedHat、openSuSE 、 CentOS等站点，它们提供了7x24小时的下载更新和自动更新服务，如果其更新包被伪造后果将极其严重。在你做RPM包签名之前，你需要首先生成GnuPG签名，如果你之前已经有了签名文件，默认它应该在%{HOME}/.gnupg目录中。  
  
1. RPM包应进行数字签名，以协助包的有效性检查  
2. 创建包RPM签名的步骤  
○ 创建GPG密钥对,设置~/.rpmmacros  
○ rpm --resign　packagefile  
3. 与私钥相匹配的公钥需要在被签名的RPM包安装之前导入要安装的系统中。  
4.制作yum源  
  
  
  
# gpg --gen-key	--生成gpg密钥对  
gpg: /root/.gnupg/trustdb.gpg: trustdb created  
gpg: key 6B602DD5 marked as ultimately trusted  
public and secret key created and signed.  
  
gpg: checking the trustdb  
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model  
gpg: depth: 0 valid: 1 signed: 0 trust: 0-, 0q, 0n, 0m, 0f, 1u  
pub 1024D/6B602DD5 2012-01-03  
Key fingerprint = 9DD1 C3B8 D428 6961 F196 4D7F 657A F058 6B60 2DD5  
uid luowenfeng (test) <cc@cc.com>  
sub 2048g/391AC319 2012-01-03  
  
  
  
# vim ~/.rpmmacros  
%_signature gpg  
%_gpg_path /root/.gnupg  
%_gpg_name luowenfeng (test) <cc@cc.com>  
  
  
签名(rpm resign --> ~/.rpmmacros --> ~/.gnupg/)：  
# rpm --resign *.rpm  
Enter pass phrase:	--输入私钥的加密密码  
Pass phrase is good.  
extmail-1.0-1.i386.rpm:  
gpg: WARNING: standard input reopened  
gpg: WARNING: standard input reopened  
hello-1.0-1.i386.rpm:  
gpg: WARNING: standard input reopened  
gpg: WARNING: standard input reopened  
vsftpd-2.0.5-24.i386.rpm:  
gpg: WARNING: standard input reopened  
gpg: WARNING: standard input reopened  
  
  
制作ＹＵＭ源：  
# mkdir /yum  
# cd /usr/src/redhat/RPMS/i386/  
# cp zip-2.31-2.i386.rpm nginx-0.8.42-1.i386.rpm hello-1.0-1.i386.rpm /yum  
# mount /dev/cdrom /mnt  
# cd /mnt/Server  
# rpm -ivh createrepo-0.4.11-3.el5.noarch.rpm  
# cd /yum  
# createrepo ./  
  
导出公钥存放到仓库中去：  
# gpg --list-key  
/root/.gnupg/pubring.gpg  
------------------------  
pub 1024D/9E7F6840 2012-04-12  
uid test01 (test) <test01@cc.com>  
sub 1024g/D6047D24 2012-04-12  
  
# gpg --export --armor 9E7F6840 > /yum/RPM-GPG-KEY  
# chmod +r /yum/RPM-GPG-KEY  
  
  
在客户端上测试yum源：  
# vim /etc/yum.repos.d/yum.repo  
[yum]  
name=a test yum source  
baseurl=ftp://192.168.0.200/  
gpgcheck=1  
gpgkey=ftp://192.168.0.200/RPM-GPG-KEY  
enable=1  
  
  
  
  
# yum -y install vsftpd  
Loaded plugins: rhnplugin  
Repository 'custom' is missing name in configuration, using id  
This system is not registered with RHN.  
RHN support will be disabled.  
custom | 951 B 00:00  
Setting up Install Process  
Resolving Dependencies  
--> Running transaction check  
---> Package vsftpd.i386 0:2.0.5-24 set to be updated  
--> Finished Dependency Resolution  
  
Dependencies Resolved  
  
================================================================================  
Package Arch Version Repository Size  
================================================================================  
Installing:  
vsftpd i386 2.0.5-24 custom 145 k  
  
Transaction Summary  
================================================================================  
Install 1 Package(s)  
Update 0 Package(s)  
Remove 0 Package(s)  
  
Total size: 145 k  
Downloading Packages:  
warning: rpmts_HdrFromFdno: Header V3 DSA signature: NOKEY, key ID 9e7f6840  
custom/gpgkey | 1.3 kB 00:00  
Importing GPG key 0x9E7F6840 "test01 (test) <test01@cc.com>" from ftp://192.168.0.254/custom/RPM-GPG-KEY  
Running rpm_check_debug  
Running Transaction Test  
Finished Transaction Test  
Transaction Test Succeeded  
Running Transaction  
Installing : vsftpd 1/1  
  
Installed:  
vsftpd.i386 0:2.0.5-24  
  
Complete!  
  
在rpm命令中使用 -K 参数进行签名验证：  
# rpm -K hello-1.0-1.i386.rpm  
  
使用rpm命令来导入公钥  
# rpm --import /path/to/your/gpg-pub-key  