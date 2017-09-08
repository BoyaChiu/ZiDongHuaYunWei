### django登录与注册+cookie

### 环境   
windows7   
python 2.7  django  
Django<1.10.5>  
### 创建项目
通过pycharm来创建项目 以及app

### 数据库
```
from __future__ import unicode_literals

from django.db import models

# Create your models here.
class User(models.Model):
    username = models.CharField(max_length=32)
    password = models.CharField(max_length=32)
    phone = models.BigIntegerField(blank=True,null=True)
    email = models.EmailField()

    def __unicode__(self):
        return "%s,%s" % (self.username,self.email,self.phone)
```
创建数据库 创建User表，用户名，密码，手机号码，邮件
同步数据库
```
python mange.py makemigrations 
python mange.py migrate
```
生成的数据库表 我们可以通过navicat查看生成的表

### 配置URL
project/urls.py
```
from django.conf.urls import url,include
from django.contrib import admin
from login import urls as loginurls

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^login/', include(loginurls)),
]
```
app/urls.py
```
#coding: utf-8
from django.conf.urls import url
from django.contrib import admin
from login import views

urlpatterns = [
# http://127.0.0.1:8000/online/    登陆页
#
# http://127.0.0.1:8000/online/login/  登陆页
#
# http://127.0.0.1:8000/online/regist/   注册页
#
# http://127.0.0.1:8000/online/index/    登陆成功页
#
# http://127.0.0.1:8000/online/logout/   注销
    url(r'^$', views.login, name='login'),
    url(r'^login/$', views.login, name='login'),
    url(r'^regist/$', views.regist, name='regist'),
    url(r'^index/$', views.index, name='index'),
    url(r'^logout/$', views.logout, name='logout'),
]
```
### 创建视图
app/views.py
```
#coding: utf-8
from django.shortcuts import render,render_to_response
from django.http import HttpResponse,HttpResponseRedirect
from django.template import RequestContext
from django import forms
from models import User
# Create your views here.

#表单
class UserForm(forms.Form):
    username = forms.CharField(label='用户名',max_length=100)
    password = forms.CharField(label='密码',widget=forms.PasswordInput())
    phone = forms.IntegerField(label='手机号码')
    email = forms.EmailField(label='邮箱地址')
#登录表单
class LoginUserForm(forms.Form):
    username = forms.CharField(label='用户名',max_length=100)
    password = forms.CharField(label='密码',widget=forms.PasswordInput())

#注册
def regist(request):
    if request.method == 'POST':
        uf  = UserForm(request.POST)
        if uf.is_valid():
            #获取表单数据
            username = uf.cleaned_data['username']
            password = uf.cleaned_data['password']
            phone = uf.cleaned_data['phone']
            email = uf.cleaned_data['email']
            #添加到数据库
            User.objects.create(username = username,password=password,phone=phone,email=email)
            return HttpResponse('注册成功')
    else:
        uf = UserForm()
        return  render_to_response('regist.html',{'uf':uf})

#登录
def login(request):
    if request.method == 'POST':
        uf = LoginUserForm(request.POST)
        if uf.is_valid():
            username = uf.cleaned_data['username']
            password = uf.cleaned_data['password']
            #获取的表单数据与数据库进行比较
            user = User.objects.filter(username__exact= username,password__exact= password)
            if user:
                #比较成功跳转index
                response = HttpResponseRedirect('/login/index/')
                response.set_cookie('username',username,36000)
                return response
            else:
                #比较失败跳转到login
                return HttpResponseRedirect('/login/login')

    else:
        uf = LoginUserForm()
    return render_to_response('login.html',{'uf':uf})

#登录成功
def index(request):
    username = request.COOKIES.get('username','')
    return render_to_response('index.html',{'username':username})

#退出
def logout(request):
    response = HttpResponse('logout !!')
    response.delete_cookie('username')
    return response
```
这里实现了所有注册，登陆逻辑，中间用到cookie创建，读取，删除操作等。

### 创建模板
这里需要创建3个模板
regist.html
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="CONTENT-TYPE" content="text/html; charset=UTF-8" >
    <title>注册</title>
</head>
<body>
<h1>注册页面：</h1>
<form method = 'post' enctype="multipart/form-data">
    {% csrf_token %}
    {{uf.as_p}}
    <input type="submit" value = "ok" />
</form>
<br>
<a href="http://127.0.0.1:8000/login/login/">登陆</a>
</body>
</html>
```
login.html
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>登录</title>
</head>
<body>
<h1>登陆页面：</h1>
<form method = 'post' enctype="multipart/form-data">
    {{uf.as_p}}
    <input type="submit" value = "ok" />
</form>
<br>
<a href="http://127.0.0.1:8000/login/regist/">注册</a>
</body>
</html>
```
index.html
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
</head>
<body>
<h1>welcome {{username}} !</h1>
<br>
<a href="http://127.0.0.1:8000/login/logout/">退出</a>
</body>
</html>
```

测试
