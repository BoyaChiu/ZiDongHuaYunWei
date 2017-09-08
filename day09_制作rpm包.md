### 制作RPM包  
#### RPM的概述及用途  
RPM包管理工具就是在linux中被广泛使用的软件包管理工具，  
#### 用途  
1. 快速安装，删除，升级和管理软件，也支持在线安装和升级软件  
2. 通过RPM包管理器能知道软件包包含哪些文件，也能知道系统中的某个文件属于哪个软件包  
3. 可以在查询系统中的软件包是否安装以及其版本  
4. 作为开发者可以把自己的程序打包为RPM包发布，减少软件安装前的配置编译所花费的时间  
5. 依赖性检查，查看是否有软件包由于不兼容扰乱了系统  

### RPM的概念  
1.RPM包: 简单来说，就是把已经编译好的二进制代码整合到一个文件里面，并且加入一些判断，依赖或冲突的软件包，安装前或后自动运行的脚本等  
2.兼容性: 由于RPM包在制作的时候，实在特定的发行版本或硬件上编译的，所以，不同发行版，或同一发行不同版本号的RPM包一般都是不能互相兼容  
3.大部分的软件作业在发布源代码的时候，也会提供rpm或.spec文件，除非没有.spec文件，否则不建议自行编写，并且在编写的时候，应使用标准宏，以提高可读性。  
  
#### rpm有两种做法  
第一种， 在rpm里面编译 make make install  
编译 也就是说我们把源代码传入rpm包 在rpm包里面编译 编译的好处在于我可以不用管安装机器的版本，比如我可以在centos 6.3-6.8都可以使用  
第二种 我拿一台机器上面安装好了二进制文件打一个包，安装到我们的rpm包里面  
一般来说同一个版本的菜可以使用centos6.2 6.3  
而且我们需要自己解决依赖关系 我们一般在初始化操作里面解决我们的依赖关系  

#### 制作nginx的rpm包  
目的：制作rpm包的目的就是把安装的过程封装起来，在执行rpm的时候会执行我们封装好的操作。  
步骤：  
1.安装rpmbuild，rpmdevtools  
yum install -y rpm-build rpmdevtools  
2.生成rpmbuild的工作目录  
rpmdev-setuptree  
目录结构：  
SOURCES ————存放源代码，补丁，图标等文件  
SPECS ————存放用于管理rpm制作过程的spec文件 打包 制作过程  
BUILD ————存放解压后的文件  
RPMS ————存放制作好的二进制包  
SRPMS ————存放由rpmbuils制作好的源码包  
3.下载源代码到SOURCES目录下  
### 使用nginx源码编译安装  
#### 手动编译一次  
去官网下载nginx-1.10.3  
再下一个pcre-8.10.tar.gz  
cd /opt  
tar xvf pcre-8.10.ta.gz  
cd pcre-8.10/  
./configure --prefix=/usr/local/services/pcre  
make && make install  
ldconfig  
* 编译NGINX  
groupadd www  
useradd -g www www -s /dev/null  
mkdir -p /data/htdocs/www  
chmod +w /data/htdocs/www  
chown -R www:www /data/htdocs/www  
cd /opt  
tar xvf nginx-1.10.3  
./configure --user=www --group=www --prefix=/usr/local/services/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre=/opt/pcre-8.10  
make && make install  
mkdir -p /data/logs  
chmod +w /data/logs  
chown -R www:www /data/logs  

#### 安装依赖  
yum -y install gcc* openssl*  
4.在SPEC目录下创建spec文件  
文件内容如下：  
Name:	nginx #软件包名称，后面可使用%{name}引用  
Version:	1.4.4 #软件的版本号，与源码包一致  
Release:	2	#发布序列号  
Summary:	for centos6.5_x86_64	#软件包的内容概要  
  
Group:	Development/Tools	#软件分组  
License:	GPL	#软件授权方式  
URL:	http://www.baidu.com	#软件的主页  
Source0:	%{name}-%{version}.tar.gz	#源代码包  
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-BuildRoot	#这个安装或编译时使用的“虚拟目录”  
Prefix: %{_prefix}	#为了解决今后安装rpm包时,并不一定把软件安装到rpm中打包的目录。必须在这里定义该标识，并在编写%install脚本的时候引用，才能实现rpm包安装时重新指定位置的功能。  
Prefix: %{_sysconfdir}  
\##%{_prefix}指/usr，而对其他的文件，例如/etc下的配置文件，则需要用%{_sysconfdir}标识。  
%define wwwpath /data/htdocs/www #后面在使用这个地址时就可以直接引用%{wwwpath}  
%define logspath /data/logs #后面在使用这个地址时就可以直接引用%{logspath}  
  
%description	#软件包详述 doc  
nginx [engine x] is a HTTP and reverse proxy server, as well as a mail proxy server  
%prep	#软件编译之前的处理，如解压。  
%setup -q	#打开软件包，加选项对软件包进行解压处理 去我们的SOURCE目录去找到源码包并解压  
  
%install 安装软件执行语句  
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"	##查看BUILDROOT目录是否为空，不为空时删除里面的内容  
mkdir -p $RPM_BUILD_ROOT/%{_prefix}	#在BUILDROOT目录中创建/usr目录  
cp -ar ./* $RPM_BUILD_ROOT%{_prefix} #将当前目录中的所有文件及属性全部复制到这个目录下  
  
  
%post	#rpm安装后执行的脚本  
mkdir -p %{wwwpath}	#创建/data/htdocs/www目录  
mkdir -p %{logspath}	#创建/data/logs目录  
groupadd www #创建新的用户组  
useradd -g www www -s /dev/null	#创建新用户到指定的用户组及用户目录  
mv %{_prefix}/nginx %{_prefix}/local/services/ #将nginx文件移动到/usr/local/services/目录下  
mv %{_prefix}/index.html %{wwwpath}	#将index.html文件移动到/data/htdocs/www目录下  
mv %{_prefix}/check.php %{wwwpath}	#将check.php文件移动到/data/htdocs/www目录下  
mv %{_prefix}/infor.php %{wwwpath}	#将infor.php文件移动到/data/htdocs/www目录下  
mv %{_prefix}/init/nginx %{_sysconfdir}/init.d/	#将/usr/init/nginx移动到/etc/init.d/目录下  
ln -s %{_prefix}/local/services/nginx/sbin/* %{_prefix}/local/sbin/ #创建软链接  
chmod +w %{wwwpath}	#给/data/htdocs/www目录赋予写权限  
chown -R www:www %{wwwpath}	#修改/data/htdocs/www的所有者和所属组的  
chmod +w %{logspath}	#给/data/logs目录赋予写权限  
chmod +x %{_sysconfdir}/init.d/nginx #给/etc/init.d/nginx文件赋予执行权限 4 r 2 w 1 x  
chown -R www:www %{logspath}	#修改/data/logs的所有者和所属组的  
chkconfig nginx on	#设置开机启动  
sed -i "s/ytios_admin/`hostname`/g" /usr/local/services/nginx/conf/nginx.conf #将这个文件中的ytios_admin替换为hostname  
  
  
%postun	#卸载后执行的操作  
%{_sysconfdir}/init.d/nginx stop	#让服务暂停  
sleep 2	#休眠2秒  
rm -f %{_prefix}/local/sbin/nginx #删除/usr/local/sbin/nginx文件  
%{__rm} -rf %{_prefix}/local/services/nginx #删除/usr/local/services/nginx文件  
%{__rm} -rf %{_sysconfdir}/init.d/nginx #删除/etc/init.d/nginx文件  
userdel www -r >/dev/null 2>&1 #删除www这个用户  
  
%files #定义那些文件或目录会放入rpm中 这里会在虚拟根目录下进行，千万不要写绝对路径，而应用宏或变量表示相对目录  
%defattr(-,root,root) #指定包装文件的属性 分别是（mode,owner，group） -表示默认值，对文本文件是0644 可执行文件为0755  
%{_prefix}/nginx  
%{_prefix}/index.html  
%{_prefix}/check.php  
%{_prefix}/infor.php  
%{_prefix}/init  
  
%clean #删除临时目录  
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"  
rm -rf $RPM_BUILD_DIR/%{name}-%{version}  
  
%changelog #变更日志  
* Wed Apr 16 2014 Tianwen  
- Create the spec file and rebuild,first  
- 修改  
  
5. 编译RPM包  
在/root/rpmbuild/SOURCE创建文件夹以及把编译好的文件放进去  
拷贝一个启动脚本 以及我们的测试文件  
cd /root/rpmbuild/SOURCE  
mkdir nginx-1.10.3  
cp /usr/local/services/nginx ./ -ar  
cp /opt/check.php ./  
cp /opt/index.html ./  
cp /opt/init ./ -ar  
进入编译目录 /root/rpmbuild/SPECE  
rpmbuild -bb nginx.spec  
好了 我们的工作以及完成现在可以检验我们的成果了  
cd /root/rpmbuild/RPMS  
  
  
  
  
  
  