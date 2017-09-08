### DJANGO Admin 
django amdin是django提供的一个后台管理页面，该管理页面提供完善的html和css，使得你在通过Model创建完数据库表之后，就可以对数据进行增删改查，而使用django admin 则需要以下步骤：
* 创建后台管理员
* 配置URL
* 注册和配置django admin后台管理页面

1. 创建后台管理员
```
python manage.py createsuperuser
```
2. 配置后台管理url
```
url(r'^admin/', include(admin.site.urls))
```
3. 注册和配置后台管理
a. 在admin中执行如下配置
```
from django.contrib import admin
   
from app01 import  models
   
admin.site.register(models.UserType)
admin.site.register(models.UserInfo)
admin.site.register(models.UserGroup)
admin.site.register(models.Asset)
```
b. 设置数据表名称
```
class UserType(models.Model):
    name = models.CharField(max_length=50)
   
    class Meta:
        verbose_name = '用户类型'
        verbose_name_plural = '用户类型'
```
C. 自定义页面展示
```
class UserInfoAdmin(admin.ModelAdmin):
    list_display = ('username', 'password', 'email')
   
   
admin.site.register(models.UserType)
admin.site.register(models.UserInfo,UserInfoAdmin)
admin.site.register(models.UserGroup)
```
注意事项：
我们可以直接使用默认的admin对象
```
from django.contrib import admin
from myproject.myapp.models import Author

admin.site.register(Author)
```
在上面的例子中，modeladmin并没有定义任何自定义的值因此系统将使用默认的admin界面，如果对于默认的admin界面足够满意，那么你根本不需要自己定义modelAdmin对象，你可以直接注册模型类而无需提供modelAdmin的描述，那么上面的例子可以简化成

这个表单是根据Question模型文件自动生成的。 
模型中不同类型的字段（DateTimeField、CharField）会对应相应的HTML输入控件。每一种类型的字段，Django管理站点都知道如何显示它们。
每个DateTimeField字段都会有个方便的JavaScript快捷方式。Date有个“Today”的快捷键和一个弹出式日历，time栏有个“Now”的快捷键和一个列出常用时间选项的弹出式窗口。
界面的底部有几个按钮：
* Save  —— 保存更改，并返回当前类型对象的变更列表界面。
* Save and continue editing —— 保存更改并且重新载入当前对象的管理界面。
* Save and add another  —— 保存更改并且载入一个当前类型对象的新的、空白的表单。
* Delete  —— 显示一个删除确认界面。

---
d. 添加页面搜索过滤等功能
```
from django.contrib import admin
   
from app01 import  models
   
class UserInfoAdmin(admin.ModelAdmin):
    list_display = ('username', 'password', 'email')
    search_fields = ('username', 'email')
    list_filter = ('username', 'email')
       
   
   
admin.site.register(models.UserType)
admin.site.register(models.UserInfo,UserInfoAdmin)
admin.site.register(models.UserGroup)
admin.site.register(models.Asset)
```

### 自定义管理表单
*默认的django显示每个对象的str()返回的内容，但有时候我们需要只显示个别的字段，我们可以使用List_display选项来实现这个功能，它是一个显示字段名称的元祖，在对象的变更列表页面上作为列显示
```
list_display = ('id','name','qq','stu_id',)
```
*搜索的功能:
search_fields = ('name',)  #两个下划线表示关联其他表的字段
这行代码在变更列表的顶部添加了一个搜索框。 当有人将搜索的内容输入搜索框，Django将在question_text字段中进行搜索。 你可以使用任意数量的字段进行搜索 ——  但由于它在后台使用LIKE进行查询，所以限制搜索字段的数量会使数据库查询更加容易。
我们可以通过这个命令来调用filter侧边栏，可以使人们通过pub_date字段对变更列表进行过滤
```
list_filter = ('publisher','publication_date')
```
*显示的过滤器类型取决于你所使用的字段类型。 由于pub_date为DateTimeField类型，所以Django将根据该类型给出相应的选项：“Any date”、“Today”、“Past 7 days”、“This month”、“This year”。


* ModelAdmin.list_editable
将list_editable设置为模型上的字段名称列表，这将允许在更改列表页面上进行编辑。也就是说，list_editable中列出的字段将在更改列表页面上显示为表单小部件，允许用户一次编辑和保存多行。
注意list_editable以特定方式与其他几个选项进行交互；您应该注意以下规则：
list_editable中的任何字段也必须位于list_display中。您无法编辑未显示的字段！
同一字段不能在list_editable和list_display_links中列出 - 字段不能同时是表单和链接。
如果这些规则中的任一个损坏，您将收到验证错误。
list_editable = ('name','publication_date')

* list_per_page = 10
list_per_page 设置控制Admin 修改列表页面每页中显示多少项。默认设置为100。


* 设置list_select_related以告诉Django在检索管理更改列表页面上的对象列表时使用select_related()。这可以节省大量的数据库查询。
list_select_related = ('publisher')

filter_horizontal = ('qq',)
默认的, ManyToManyField 会在管理站点上显示一个<select multiple>.（多选框）．但是，当选择多个时多选框非常难用. 添加一个 ManyToManyField到该列表将使用一个漂亮的低调的JavaScript中的“过滤器”界面,允许搜索选项。选和不选选项框并排出现。参考filter_vertical 使用垂直界面。

raw_id_fields = ('qq',)
默认情况下，Django 的Admin 对ForeignKey 字段使用选择框表示 (<select>) 。有时候你不想在下拉菜单中显示所有相关实例产生的开销。
raw_id_fields 是一个字段列表，你希望将ForeignKey 或ManyToManyField 转换成Input Widget：

---
Admin 界面上的Action
简而言之，Django Admin 的基本流程是，“选择一个对象，然后更改它”。这适用于大多数情况下使用。然而当你一次性要对多个对象做相同的改变，这个流程是非常的单调乏味的。

在这些情况下，Django Admin 可以让你编写并注册“Action” —— 仅仅只是一个以更改列表页面上选中对象的列表为参数的回调函数。

如果你看看Admin 界面中的任何更改列表，你将看到此功能在起作用；Django 在所有的模型中自带了一个“delete selected objects” Action。
### 编写actions
我们通过例子来讲actions 
```
from django.db import models

STATUS_CHOICES = (
    ('d', 'Draft'),
    ('p', 'Published'),
    ('w', 'Withdrawn'),
)

class Article(models.Model):
    title = models.CharField(max_length=100)
    body = models.TextField()
    status = models.CharField(max_length=1, choices=STATUS_CHOICES)

    def __str__(self):              # __unicode__ on Python 2
        return self.title
```
我们可能在模型上执行的一个普遍任务是，将文章状态从“草稿”更新为“已发布”。在Admin 界面上一次处理一篇文章非常轻松，但是如果我们想要批量发布一些文章，则会非常单调乏味。所以让我们编写一个Action，可以让我们将一篇文章的状态修改为“已发布”。
* 编写actions函数
首先我们需要定义一个函数，当在admin界面上触发该actions的时候调用. actions函数，跟普通的函数一样，需要接收三个参数
* 当前的 ModelAdmin
* 表示当前请求的HttpRequest
* 含有用户所选的对象集合的QuerySet
我们用于发布这些文章的函数并不需要modeladmin和请求对象，但是我们会用到查询集
```
def make_published(modeladmin, request, queryset):
    queryset.update(status='p')
make_published.short_descriptions = "Mark selected stories as published"
```
* 添加操作到ModelAdmin
接下来，我们需要把action告诉modelAdmin 它和其他配置项的工作方式相同，所有带有action及其注册的完整的admin.py看起来像这样
```
from django.contrib import admin
from myapp.models import Article

def make_published(modeladmin, request, queryset):
    queryset.update(status='p')
make_published.short_description = "Mark selected stories as published"

class ArticleAdmin(admin.ModelAdmin):
    list_display = ['title', 'status']
    ordering = ['title']
    actions = [make_published]

admin.site.register(Article, ArticleAdmin)
```
这就是全部内容了。如果你想编写自己的Action ，你现在应该知道怎么开始了







