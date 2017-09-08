### 第一步: 去码云注册账号 
https://git.oschina.net/

### 第二步: 登录码云 创建项目

### 第三步: 在本机安装git 并生成公钥
1. 安装git
https://git-scm.com/download/win 
下载安装包 下载不下来找老师要包
一直下一步就可以了
2. 生成公钥
右键打开 Git bash here 
```
ssh-keygen -t rsa -C "xxxxx@xxxxx.com" 
# Generating public/private rsa key pair...
# 三次回车即可生成 ssh key
#查看公钥  复制下来
cat ~/.ssh/id_rsa.pub
```
![Markdown](http://i1.buimg.com/1949/345f52e59e75a48c.png)
3. 上传到码云上面
![Markdown](http://i1.buimg.com/1949/940bc35c717a3a42.png)
添加到自己的项目中去

![Markdown](http://i1.buimg.com/1949/f31f825f1a6d8cde.png)

### 第四步 使用pycharm把项目克隆下来
1. 复制码云地址
![Markdown](http://i2.kiimg.com/1949/16b06eeb1ec8091d.png)
2. 打开pycharm 添加地址
![Markdown](http://i2.kiimg.com/1949/eb21712a7a8a0cf0.png)
![Markdown](http://i2.kiimg.com/1949/4d6db60e63a6eeac.png)
3.添加完成后就可以自动同步了



