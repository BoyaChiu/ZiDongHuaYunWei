### 上传文件
上传文件有什么用处 ，论坛 上传头像，电商上传一些证书  
在运维当中使用比较多的就是 在运行自助更新工具的时候需要上传一些更新包  
比如我们需要更新内测服，我们自己写了一个django的网站    那么我们需要通过上传的功能把更新的内容上传到服务器上面   然后更新内测服里面的内容   
### 环境
windows7   
python 2.7  django  
Django<1.10.5>  
### 创建项目
```
django-admin.py startproject upload
cd upload
#在项目下创建一个upfiles应用
python manage.py startapp upfiles
```
### 设计model(数据库)
```
from __future__ import unicode_literals

from django.db import models

# Create your models here.
class  User(models.Model):
    username = models.CharField(max_length = 32)
    headImg = models.FileField(upload_to='./upfile/')

    def __unicode__(self):
        return self.username
```
创建2个字段  username用户名存放用户名，headImg 用户存放上传文件的路径
```
数据同步
:\Users\Administrator\PycharmProjects\ansible\django\upload>python manage.py makemigrations
Migrations for 'upfile':
  upfile\migrations\0001_initial.py:
    - Create model User

C:\Users\Administrator\PycharmProjects\ansible\django\upload>python manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, sessions, upfile
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying sessions.0001_initial... OK
  Applying upfile.0001_initial... OK
```
### 创建视图
```
from django.shortcuts import render,render_to_response
from django import forms
from django.http import HttpResponse
from upfile.models import User
# Create your views here.

class UserForm(forms.Form):
    username = forms.CharField()
    headImg = forms.FileField()

def register(request):
    if request.method == "POST":
        uf = UserForm(request.POST,request.FILES)
        if uf.is_valid():
            username = uf.cleaned_data['username']
            headImg = uf.cleaned_data['headImg']
            user = User()
            user.username = username
            user.headImg = headImg
            user.save()
            return HttpResponse('upload ok!')
    else:
        uf = UserForm()
    return render_to_response('register.html',{'uf':uf})
```
### 设置模板
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>register</h1>
<form method="post" enctype="multipart/form-data" >
{{uf.as_p}}
<input type="submit" value="ok"/>
</form>
</body>
</html>
```
### URL
```
from django.conf.urls import url
from django.contrib import admin
from upfile import views

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^upfile/', views.register),
]
```

