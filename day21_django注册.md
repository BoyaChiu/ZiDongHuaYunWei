### 写一个自己的注册系统
### 环境   
windows7   
python 2.7  django  
Django<1.10.5>  
### 创建项目
```
django-admin.py startproject zhuce
cd zhuce
#在项目下创建一个account应用
python manage.py startapp account
```
```
INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'account',
)
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
编辑 zhuce/account
```
from __future__ import unicode_literals

from django.db import models

# Create your models here.
class User(models.Model):
    username = models.CharField(max_length=50)
    password = models.CharField(max_length=50)
    email = models.EmailField()
```
按照惯例先创建数据库，创建三个字段，用户存放用户名、密码、email 地址等。

下面进行数据库的同步
```
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperusers
```
最后生成的 account_user 表就是我们models.py 中所创建的User类。Django 提供了他们之间的对应关系。
---
### 创建视图(逻辑层)
编辑 zhuce/account
```
#coding: utf-8
from django.shortcuts import render
from django import forms
from django.shortcuts import render_to_response
from django.http import HttpResponse,HttpResponseRedirect
from django.template import RequestContext
from account.models import User
# Create your views here.
class UserForm(forms.Form):
    username = forms.CharField(label='用户名:',max_length=100)
    password = forms.CharField(label='密码:',widget=forms.PasswordInput())
    email = forms.EmailField(label='电子邮件:')

def register(request):
    if request.method == "POST":
        uf = UserForm(request.POST)
        if uf.is_valid():
            #获取表单信息
            username = uf.cleaned_data['username']
            password = uf.cleaned_data['password']
            email = uf.cleaned_data['email']
            #将表单写入数据库
            user = User()
            user.username = username
            user.password = password
            user.email = email
            user.save()
            #返回注册成功页面
            return render_to_response('success.html',{'username':username})
    else:
        uf = UserForm()
    return render_to_response('register.html',{'uf':uf})
```
视图里面主要做了几个事情，首先提供给用户一个注册页面(register.html)，UserForm类定义了表单在注册页面上的显示。接受用户填写的表单信息，然后将表单信息写入到数据库，最后返回给用户一个注册成功的页面（success.html）
---
### 创建模板文件(前端页面)
在逻辑层提到了两个页面，一个注册页，一个注册成功页面。所以我们要把这两个页面创建出来。

先在zhuce/account/templates/目录下创建register.html 文件：
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>用户注册</title>
</head>
  <style type="text/css">
    body{color:#efd;background:#453;padding:0 5em;margin:0}
    h1{padding:2em 1em;background:#675}
    h2{color:#bf8;border-top:1px dotted #fff;margin-top:2em}
    p{margin:1em 0}
  </style>
<body>
<h1>注册页面：</h1>
<form method = 'post' enctype="multipart/form-data">
{{uf.as_p}}
<input type="submit" value = "ok" />
</form>
</body>
</html>
```
接着我们在zhuce/account/templates/目录下创建success.html 文件
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>
</head>
<body>
    <h1>恭喜{{username}},注册成功！</h1>
</form>
</body>
</html>
```
---
### 设置URL
打开 zhuce/zhuce/urls
```
from django.conf.urls import url,include
from django.contrib import admin
from account import urls as account_urls

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^account/', include(account_urls)),
]
```
打开 zhuce/account/urls
```
#-*- coding:utf-8 -*-
from django.conf.urls import url
from account import views

urlpatterns = (
        url(r'^$', views.register, name='register'),
        url(r'^register/$', views.register, name='register'),
        )
```
