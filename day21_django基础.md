django 框架基础
* Model(模型)：负责业务对象与数据库的对象(ORM)
* Template(模版)：负责如何把页面展示给用户
* View(视图)：负责业务逻辑，并在适当的时候调用Model和Template
* URL Django还有一个url分发器，它的作用是将一个个URL的页面请求分发给不同的view处理，view再调用相应的Model和Template    index index 
* 其他ajax
对python web程序来说，一般会分为两部分：服务器程序和应用程序。服务器程序负责对socket服务器进行封装，并在请求到来时，对请求的各种数据进行整理。应用程序则负责具体的逻辑处理。为了方便应用程序的开发，就出现了众多的Web框架，例如：Django、Flask、web.py 等。不同的框架有不同的开发方式，但是无论如何，开发出的应用程序都要和服务器程序配合，才能为用户提供服务。这样，服务器程序就需要为不同的框架提供不同的支持。这样混乱的局面无论对于服务器还是框架，都是不好的。对服务器来说，需要支持各种不同框架，对框架来说，只有支持它的服务器才能被开发出的应用使用。这时候，标准化就变得尤为重要。我们可以设立一个标准，只要服务器程序支持这个标准，框架也支持这个标准，那么他们就可以配合使用。一旦标准确定，双方各自实现。这样，服务器可以支持更多支持标准的框架，框架也可以使用更多支持标准的服务器。
在做验证的时候  
 
前后端交付


MVC和MTV

　　MVC：Model、View、Controller

　　MTV：Model、Template、View
WSGI（Web Server Gateway Interface）是一种规范，它定义了使用python编写的web app与web server之间接口格式，实现web app与web server间的解耦。
django是怎么工作的 
![image](http://note.youdao.com/yws/api/personal/file/848717C81CEF4C8282C667A4400FC9E3?method=download&shareKey=f6d11b632cca5b2f96432037fa98bfe6)    
![image](http://images.cnitblog.com/blog2015/311516/201503/272244545369594.jpg)


python标准库提供的独立WSGI服务器称为wsgiref。
一、创建django程序

　　1、终端：django-admin startproject sitename

　　2、IDE创建Django程序时，本质上都是自动执行上述命令

常用命令：

　　python manage.py runserver 0.0.0.0   启动django项目  
　　python manage.py startapp appname    创建一个djangoapp  
　　python manage.py syncdb              同步数据库  1.7.4之前的版本  
　　python manage.py makemigrations      基于当前的model创建新的迁移策略文件  简单来说 就是生成sql  
　　python manage.py migrate             用于执行迁移动作    执行sql  
　　python manage.py createsuperuser     创建第一个用户

二、Django程序目录  

setting： 全局的配置文件  
urls: 一个URL对应一个视图函数  
wsgi: web服务网关接口 创建socket对象  
template: 存放模板的位置  
tests: 单元测试  
--- 
三配置文件  
1.数据库  
```
DATABASES = {
    'default': {
    'ENGINE': 'django.db.backends.mysql',
    'NAME':'dbname',
    'USER': 'root',
    'PASSWORD': 'xxx',
    'HOST': '',
    'PORT': '',
    }
}
```
2. 模板
```
TEMPLATE_DIRS = (
        os.path.join(BASE_DIR,'templates'),
    )
```
3. 静态文件
```
STATICFILES_DIRS = (
        os.path.join(BASE_DIR,'static'),
    )
```
四.路由系统  
1、每个路由规则对应一个view中的函数
```
#动态路由  查看第一页内容  查看第二个内容 
url(r'^news/(\d*)(\d*)', views.news),   #添加一个匹配数字的 ()分组匹配
#获取这个值有什么用类   我们可以根据这个值来获取数据  所有的正则表达式都是支持的 
#?P<name> 指定形式参数的名字  可以通过名字来调用
#我们可以指定位置来获取数据  而不是按照传进来的参数来分
url(r'^manage/(?P<name>\w*)/(?P<id>\d*)', views.manage),
url(r'^manage/(?P<name>\w*)', views.manage,{'id':333}),
```
2、根据app对路由规则进行一次分类
```
#二级路由
url(r'^web/',include('web.urls')),
```
django中的路由系统和其他语言的框架有所不同，在django中每一个请求的url都要有一条路由映射，这样才能将请求交给对一个的view中的函数去处理。其他大部分的Web框架则是对一类的url请求做一条路由映射，从而是路由系统变得简洁。  
总结
1. 静态路由
2. 动态路由
    按照顺序，第n个匹配的数据，交给函数的第n个参数，严格按照顺序
    模板的方法，将匹配的参数，传给指定的形式参数
3. 二级路由
    ceshi.url.py  首先在ceshiapp里面定义一个urls文件 写法跟urls一样的
    include(ceshi.url)  然后在project里面定义一个includeceshiapp下面的urls
    然后在用户访问ceshiapp的时候会进行一个转发的功能
---
五. 模型     
到目前为止，当我们的程序涉及到数据库相关操作时一般做一下几个操作：    

* 创建数据库，设计表结构和字段  
* 使用 MySQLdb 来连接数据库，并编写数据访问层代码  
* 业务逻辑层去调用数据访问层执行数据库操作  
django为使用一种新的方式，即：关系对象映射（Object Relational Mapping，简称ORM）。 code frist 代码优先  
自己写类 --> 数据库表  
默认支持admin后台登录   如果输入用户名密码 它是不是要进行比较   它进行比较是不是跟某一个数据库里面的某一个字段进行比较  
django自己创建表 并且知道表的结构  有数据的支撑 django默认会创建几张表  
配置数据库在settings里面  
默认不配置的情况下会放到sqllite3   
生产数据库需要执行命令  1. makemigrations #生成配置文件  
                        2. migrate        #根据配置文件创建数据库相关  

　　PHP：activerecord    

　　Java：Hibernate   

  　C#：Entity Framework  

django中遵循 Code Frist 的原则，即：根据代码中定义的类来自动生成数据库表。    
a. 创建类  
b. 使用命令生成  


1、创建Model，之后可以根据Model来创建数据库表    
```
from django.db import models
 
class userinfo(models.Model):
    name = models.CharField(max_length=30)
    email = models.EmailField()
    memo = models.TextField()
```
字段  
```
1、models.AutoField　　自增列 = int(11)
　　如果没有的话，默认会生成一个名称为 id 的列，如果要显示的自定义一个自增列，必须将给列设置为主键 primary_key=True。
2、models.CharField　　字符串字段
　　必须 max_length 参数
3、models.BooleanField　　布尔类型=tinyint(1)
　　不能为空，Blank=True
4、models.ComaSeparatedIntegerField　　用逗号分割的数字=varchar
　　继承CharField，所以必须 max_lenght 参数
5、models.DateField　　日期类型 date
　　对于参数，auto_now = True 则每次更新都会更新这个时间；auto_now_add 则只是第一次创建添加，之后的更新不再改变。
6、models.DateTimeField　　日期类型 datetime
　　同DateField的参数
7、models.Decimal　　十进制小数类型 = decimal
　　必须指定整数位max_digits和小数位decimal_places
8、models.EmailField　　字符串类型（正则表达式邮箱） =varchar
　　对字符串进行正则表达式
9、models.FloatField　　浮点类型 = double
10、models.IntegerField　　整形
11、models.BigIntegerField　　长整形
　　integer_field_ranges = {
　　　　'SmallIntegerField': (-32768, 32767),
　　　　'IntegerField': (-2147483648, 2147483647),
　　　　'BigIntegerField': (-9223372036854775808, 9223372036854775807),
　　　　'PositiveSmallIntegerField': (0, 32767),
　　　　'PositiveIntegerField': (0, 2147483647),
　　}
12、models.IPAddressField　　字符串类型（ip4正则表达式）
13、models.GenericIPAddressField　　字符串类型（ip4和ip6是可选的）
　　参数protocol可以是：both、ipv4、ipv6
　　验证时，会根据设置报错
14、models.NullBooleanField　　允许为空的布尔类型
15、models.PositiveIntegerFiel　　正Integer
16、models.PositiveSmallIntegerField　　正smallInteger
17、models.SlugField　　减号、下划线、字母、数字
18、models.SmallIntegerField　　数字
　　数据库中的字段有：tinyint、smallint、int、bigint
19、models.TextField　　字符串=longtext
20、models.TimeField　　时间 HH:MM[:ss[.uuuuuu]]
21、models.URLField　　字符串，地址正则表达式
22、models.BinaryField　　二进制<br>23、models.ImageField   图片<br>24、models.FilePathField 文件
```
字段参数
```
1、null=True
　　数据库中字段是否可以为空
2、blank=True
　　django的 Admin 中添加数据时是否可允许空值
3、primary_key = False
　　主键，对AutoField设置主键后，就会代替原来的自增 id 列
4、auto_now 和 auto_now_add
　　auto_now   自动创建---无论添加或修改，都是当前操作的时间
　　auto_now_add  自动创建---永远是创建时的时间
5、choices
GENDER_CHOICE = (
        (u'M', u'Male'),
        (u'F', u'Female'),
    )
gender = models.CharField(max_length=2,choices = GENDER_CHOICE)
6、max_length
7、default　　默认值
8、verbose_name　　Admin中字段的显示名称
9、name|db_column　　数据库中的字段名称
10、unique=True　　不允许重复
11、db_index = True　　数据库索引
12、editable=True　　在Admin里是否可编辑
13、error_messages=None　　错误提示
14、auto_created=False　　自动创建
15、help_text　　在Admin中提示帮助信息
16、validators=[]
17、upload-to
```
---
数据库中表与表之间的关系：   
* 一对多，models.ForeignKey(ColorDic)  
* 一对一，models.OneToOneField(OneModel)  
* 多对多，authors = models.ManyToManyField(Author)  
2、数据库操作  
在视图里面执行函数的时候直接创建
```
    #增加
    #models.userinfo.objects.create(username='aaa',password='123',age=73)
    #dic = {"username":'awen',"password":'123',"age":73}
    #models.userinfo.objects.create(**dic)
    #删除
    #models.userinfo.objects.filter(username='awen').delete()
    #models.userinfo.objects.filter(username='awen',password='123').delete()  
    where username='awen'  and password='123'
    #修改
    #models.userinfo.objects.all().update(age=18)
    #查找 都是userinfo的对象
    #models.userinfo.objects.all()
    #models.userinfo.objects.filter(age=18)
    #models.userinfo.objects.filter(age=18).first()
```
*　增加：创建实例，并调用save  
*　更新：a.获取实例，再sava；b.update(指定列)  
*　删除：a. filter().delete(); b.all().delete()  
*　获取：a. 单个=get(id=1)；b. 所有 = all()
*　过滤：filter(name='xxx');filter(name__contains='');(id__in = [1,2,3]) ;
*　icontains(大小写无关的LIKE),startswith和endswith, 还有range(SQLBETWEEN查询）'gt', 'in', 'isnull', 'endswith', 'contains', 'lt', 'startswith', 'iendswith', 'icontains','range', 'istartswith'
*　排序：order_by("name") =asc ；order_by("-name")=desc
*　返回第n-m条：第n条[0]；前两条[0:2]
*　指定映射：values
*　数量：count()
*　聚合：from django.db.models import Min,Max,Sum objects.all().aggregate(Max('guest_id'))
*　原始SQL
```
cursor = connection.cursor()
cursor.execute('''SELECT DISTINCT first_name ROM people_person WHERE last_name = %s""", ['Lennon'])
row = cursor.fetchone() 
```
上传文件实例
```
class FileForm(forms.Form):
    ExcelFile = forms.FileField()

from django.db import models

class UploadFile(models.Model):
    userid = models.CharField(max_length = 30)
    file = models.FileField(upload_to = './upload/')
    
    date = models.DateTimeField(auto_now_add=True)
    
def UploadFile(request):
    uf = AssetForm.FileForm(request.POST,request.FILES)
    if uf.is_valid():
            upload = models.UploadFile()
            upload.userid = 1
            upload.file = uf.cleaned_data['ExcelFile']
            upload.save()
            
            print upload.file
```
六.模板
1、模版的执行

　　模版的创建过程，对于模版，其实就是读取模版（其中嵌套着模版标签），然后将 Model 中获取的数据插入到模版中，最后将信息返回给用户。  
```
def current_datetime(request):
    now = datetime.datetime.now()
    html = "<html><body>It is now %s.</body></html>" % now
    return HttpResponse(html)

from django import template
t = template.Template('My name is {{ name }}.')
c = template.Context({'name': 'Adrian'})
print t.render(c)

import datetime
from django import template
import DjangoDemo.settings
 
now = datetime.datetime.now()
fp = open(settings.BASE_DIR+'/templates/Home/Index.html')
t = template.Template(fp.read())
fp.close()
html = t.render(template.Context({'current_date': now}))
return HttpResponse(html

from django.template.loader import get_template
from django.template import Context
from django.http import HttpResponse
import datetime
 
def current_datetime(request):
    now = datetime.datetime.now()
    t = get_template('current_datetime.html')
    html = t.render(Context({'current_date': now}))
    return HttpResponse(html)
    
return render_to_response('Account/Login.html',data,context_instance=RequestContext(request))
```
注意：当数据POST的时候，Django做了跨站请求伪造  
2. 模板语言  
2、模版语言  

　　模板中也有自己的语言，该语言可以实现数据展示  

{{ item }}  
{% for item in item_list %}  <a>{{ item }}</a>  {% endfor %}  
　　forloop.counter  
　　forloop.first  
　　forloop.last   
{% if ordered_warranty %}  {% else %} {% endif %}  
母板：{% block title %}{% endblock %}  
子板：{% extends "base.html" %}  
　　　{% block title %}{% endblock %}  
帮助方法：  
{{ item.event_start|date:"Y-m-d H:i:s"}}  
{{ bio|truncatewords:"30" }}  
{{ my_list|first|upper }}  
{{ name|lower }}  
通过simple_tag实现模版语言中的帮助方法  

a、在app中创建templatetags文件夹  

b、创建任意 .py 文件，如：xx.py  
```  
#!/usr/bin/env python
#coding:utf-8
from django import template
from django.utils.safestring import mark_safe
from django.template.base import resolve_variable, Node, TemplateSyntaxError
 
register = template.Library()
 
@register.simple_tag
def my_simple_time(v1,v2,v3):
@register.simple_tag
def my_input(id,arg):
    result = "<input type='text' id='%s' class='%s' />" %(id,arg,)
    return mark_safe(result)
```
c、在使用自定义simple_tag的html文件中导入之前创建的 xx.py 文件名  
{% load xxx %}  
d、使用simple_tag  
{% my_simple_time 1 2 3%}  
{% my_input 'id_username' 'hide'%}  
e、再settings中配置当前app，不然django无法找到自定义的simple_tag  
INSTALLED_APPS = (  
    'django.contrib.admin',  
    'django.contrib.auth',  
    'django.contrib.contenttypes',  
    'django.contrib.sessions',  
    'django.contrib.messages',  
    'django.contrib.staticfiles',  
    'app01',  
)  