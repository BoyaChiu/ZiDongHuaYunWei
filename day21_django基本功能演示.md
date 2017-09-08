### django基础功能演示
django资料  
[django中文网](http://python.usyiyi.cn/translate/django_182/index.html)  
对于django开发，用户登录，注册，文件上传是最基本的功能，不同的业务基本上都会用到这个3个最基本的功能，我们今天来实现这3个功能   其实网络上都有，但是只有自己做过一次之后才算真正的会了  
我这边3个项目都会带大家做一次   我希望大家在动手的过程中体会django的架构是怎么实现的在一个功能的过程的，在实现的过程当中深入理解 django具体是怎么工作的 可以参考我们的图    
### views怎么传递参数以及调用我们的模板
在视图中我们返回数据的方式有两种一种是字符串(数据) 一种是模板(html)
字符串是在ajax里面才回用  ajax 是整个页面不刷新，部分刷新

在使用视图的时候我们会有这个这样的需求   怎么把一个变量给多个模板使用，在这个时候我们需要用到django上下文渲染器    
我们来看一个简单的例子  怎么把数据传给模板    
```
from django.shortcuts import render
 
def home(request):                           dict list str
    return render(request, 'home.html', {'info': 'Welcome to ziqiangxuetang.com !'})
```
那么我们就可以在home.html中打印info信息了  
调用方{{ inof }}  

一旦你创建一个template对象，你可以使用context来传递数据给它，一个context是一系列变量和它们值的集合  
context在django里表现为context类，在django。template模块里，它的构造函数有一个可选的参数，一个字典映射变量和它们的值.调用template对象的render()方法并传递context来填充模板  
这就是使用 Django 模板系统的基本规则： 写模板，创建 Template 对象，创建 Context ， 调用 render() 方法。  

* render()  结合一个给定的模板和一个给定的上下文字典，并返回一个渲染后的 HttpResponse 对象。
* render_to_response() 的第一个参数必须是要使用的模板名称。 如果要给定第二个参数，那么该参数必须是为该模板创建 Context 时所使用的字典。 如果不提供第二个参数， render_to_response() 使用一个空字典。  

* HttpResponse，它是用来向网页返回内容的，就像Python中的 print 一样，只不过 HttpResponse 是把内容显示到网页上。  
* HttpResponseRedirect Redirect(String)	将请求重定向到新 URL 并指定该新 URL。  
###  __unicode__()方法是个什么鬼？
当我们打印整个p1列表时，我们没有得到想要的有用信息，无法把````对象区分开来：  
<User: User object>  
我们可以简单解决这个问题，只需要为p1 对象添加一个方法 __unicode__() 。 __unicode__() 方法告诉Python如何将对象以unicode的方式显示出来。 为以上三个模型添加__unicode__()方法后，就可以看到效果了。
def __unicode__(self):  
      return self.name
对__unicode__()的唯一要求就是它要返回一个unicode对象 如果`` __unicode__()`` 方法未返回一个Unicode对象，而返回比如说一个整型数字，那么Python将抛出一个`` TypeError`` 错误，并提示：”coercing to Unicode: need string or buffer, int found” 。　　
```
class  User(models.Model):
    username = models.CharField(max_length = 32)
    headImg = models.FileField(upload_to='./upfile/')

    def __unicode__(self):
        return self.username
---------------------->
>>> from upfile.models import User
>>> p1 = User(username='tuoshen')
>>> p1
<User: tuoshen>
>>> exit
Use exit() or Ctrl-Z plus Return to exit
>>> exit()
---------------------->
>>> from upfile.models import User
>>> p1 = User(username='tuoshen')
>>> p1
<User: User object>
>>>
```

### methods方法
django默认只支持两种 get POST
methods定义我们http的方法
get POST只不过是浏览器定义的2种方式
在socet看来是一样的 
get 是请求数据 如果是get这个参数  如果传参数他会直接显示在URL上

post 是提交数据 
http的方法有5种GET，HEAD,POST,PUT,DELETE,OPTION今天主要介绍2种常用的GET和POST  
#GET浏览器通知服务器只获取页面上的信息并且发送回来，这是最常用的方法   
#POST浏览器通知服务器需要通过URL上提交一些信息，服务器必须保证数据被存储且只存储一次。这只html表单form通常发送数据到服务器的方法  

### form(表单)
在我们的django当中也提供了我们html中表单的模板 可以继承我们的forms类来做  
django的表单有四种写法  
{{ form.as_ul }}                        # 这是第一种写法，在<ul> 显示表单  
{{ form.as_p }}                         # 这是第二种写法，在<p> 显示表单  
{{ form.as_table }}                     # 这是第三种写法，在<table>显示表单  
{% for field in form %}                 # 这是第四种写法，以循环形式显示表单  
    {{ field.label_tag }}:{{ field }}   
{{ field.errors }}  
     {% endfor %}  
     
Form 的实例具有一个is_valid() 方法，它为所有的字段运行验证的程序。当调用这个方法时，如果所有的字段都包含合法的数据，它将：
* 返回True
* 将表单的数据放到cleaned_data 属性中。
写一个简单的例子

```
# coding:utf-8
from django import forms

from django.shortcuts import render
from django.http import HttpResponse类
class AddForm(forms.Form):
    a = forms.IntegerField()
    b = forms.IntegerField() 

 
def index(request):
    if request.method == 'POST':# 当提交表单时
     
        form = AddForm(request.POST) # form 包含提交的数据
         
        if form.is_valid():# 如果提交的数据合法
            a = form.cleaned_data['a']
            b = form.cleaned_data['b']
            return HttpResponse(str(int(a) + int(b)))
     
    else:# 当正常访问时
        form = AddForm()
    return render(request, 'index.html', {'form': form})
```
```
<form method='post'>
{% csrf_token %}
{{ form }}
<input type="submit" value="提交">
</form>
```
