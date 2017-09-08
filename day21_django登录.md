### 目的  写一个属于自己的用户登录脚本  
网上虽然有非常多的案例可以使用，但是我希望大家可以自己写一个脚本   让自己以后在写登录注册的时候不会出现问题  
### 环境   
windows7   
python 2.7  django  
Django<1.10.5>  
---
### 创建项目和应用的基本设置  
使用pycharm创建项目    
![image](http://note.youdao.com/yws/api/personal/file/57223914D5994515A2123D779F084E2B?method=download&shareKey=6431d99a5770bf8a5fec1c422bd5f5f6)  
目录结构如下    
![image](http://note.youdao.com/yws/api/personal/file/07CEB6FE11634A6BA1EF6EB441E23333?method=download&shareKey=f9aeaf05a41144e6e8fc110f3a91f7ef)  
修改配置文件  crm/settings.py  
```
# Application definition
INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'web11',
)
……
#顺便注释csrf 
MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    #'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
)
```
### 设计model（数据库）  
修改 crm/web11/models.py   
```
from __future__ import unicode_literals
from django.db import models
from django.contrib import admin
# Create your models here.
class User(models.Model):
    username = models.CharField(max_length=50)
    password = models.CharField(max_length=50)
```
创建一个User表，有两个字段username、password   
然后，进行数据库的同步：  
![image](http://note.youdao.com/yws/api/personal/file/C2E1992AF7A14E6EB696619A5D1B82A5?method=download&shareKey=072a47f60ea389f56042c1e52ad842a3)  
---
### 配置URL  
首先配置 crm的urls  
```
from django.conf.urls import include,url
from django.contrib import admin
from web11 import views
from web11 import urls as web11_urls

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', include(web11_urls)),
]
```
再来配置web11的urls   
```
from django.conf.urls import   include, url
from django.contrib import admin
from web11 import views
admin.autodiscover()

urlpatterns = (
    # Examples:
    # url(r'^$', 'mysite5.views.home', name='home'),
    url(r'^$', views.login, name='login'),
)
```
### 启动服务    
配置启动    
![image](http://note.youdao.com/yws/api/personal/file/351E8E0A68434F48B62257C911F2F995?method=download&shareKey=4e4db52a2e3506910adf33594155643c)  
启动  
![image](http://note.youdao.com/yws/api/personal/file/4EE557DC01FC4468ADE6E0CBC74AC90D?method=download&shareKey=9674f9f1cc30c8832ebb946b9e6c9742)  

### 访问admin    
127.0.0.1:8000    
![image](http://note.youdao.com/yws/api/personal/file/2629FCDF410446D49BB23D87D64B401F?method=download&shareKey=9d2aa2e8c3603586f994c98394819832)
点击add界面添加一个用户  创建用户并save    

再次打开web11/admin.py    
```
from django.contrib import admin  
from web11 import models
 
# Register your models here.
class UserAdmin(admin.ModelAdmin):
    list_display = ('username','password')

admin.site.register(models.User,UserAdmin)
```
刷新一下后台   可以看到名字已经改变了  
---
### 创建视图   
现在我们已经生成了一个用户信息表，下面要做的就是设计用户的登录功能了  
编辑 crm/web11/views.py  
```
#coding: utf-8
from django.shortcuts import render,render_to_response
from django.http import HttpResponseRedirect
from web11.models import User
from django import forms

# Create your views here.
def index(request):
    return render(request, 'ceshi.html')
#定义表单模型
class UserForm(forms.Form):
    username = forms.CharField(label='用户名',max_length=100)
    password = forms.CharField(label='密码',widget=forms.PasswordInput())

#登录
def login(request):
    if request.method == 'POST':
        uf = UserForm(request.POST)
        if uf.is_valid():
            #获取表单用户密码
            username = uf.cleaned_data['username']
            password = uf.cleaned_data['password']
            print username
            print password
            #获取的表单数据与数据库进行比较
            user = User.objects.filter(username__exact = username, password__exact = password)
            if user:
                return render_to_response('success.html',{'username':username})
            else:
                return HttpResponseRedirect('/login/')
    else:
        uf = UserForm()
    return render_to_response('login.html',{'uf':uf})
```
上面登录的核心是比较，拿到用户填写的表单数据（用户名、密码）与数据库User表中的字段进行比较，根据比较结果，如果成功跳转到success.html页面，如果失败还留在原来页面login.html 。  
---
### 创建模板  
根据视图层的要求，我们需要创建两个页面，success.html 和login.html   
放到这个目录下面 crm/templates   
login.html  
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>登录</title>
</head>
 <style type="text/css">
    body{color:#efd;background:#453;padding:0 5em;margin:0}
    h1{padding:2em 1em;background:#675}
    h2{color:#bf8;border-top:1px dotted #fff;margin-top:2em}
    p{margin:1em 0}
 </style>
<body>
<h1>登录页面：</h1>
<form method = 'post' enctype="multipart/form-data">
    {{uf.as_p}}
    <input type="submit" value = "ok" />
</form>
</body>
</html>
```
success.html  
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>
</head>
<body>
    <h1>恭喜{{username}},登录成功！</h1>
</form>
</body>
</html>
```

访问登录页面127.0.0.1:8000/login  
注意只能用添加的用户进行测试  