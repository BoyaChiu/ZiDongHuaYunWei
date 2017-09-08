### ModelAdmin options
* ModelAdmin.exclude   过滤属性
如果设置了这个属性，它表示应该从表单中去掉的字段列表

###  ModelAdmin.filter_horizontal
默认的, ManyToManyField 会在管理站点上显示一个<select multiple>.（多选框）．但是，当选择多个时多选框非常难用. 添加一个 ManyToManyField到该列表将使用一个漂亮的低调的JavaScript中的“过滤器”界面,允许搜索选项。选和不选选项框并排出现。
非常好用的一个多选框
filter_horizontal = ('teachers',)

###  ModelAdmin.list_display
使用list_display去控制那些字段会显示在admin的修改列表页面中
list_display = ('first_name','last_name') 
如果你没有设置list_dispaly，admin站点讲只显示以列表表示每个对象的__unicode__()（python3里面使用__str__）
在list_dispaly中，你有4种赋值方式可以使用:
1. 模型的字段 
```
class PersonAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name')
```
2. 一个接受对象实例的可调用对象，例子
```
def upper_case_name(obj):
    return ("%s %s" % (obj.first_name, obj.last_name)).upper()
upper_case_name.short_description = 'Name'

def __unicode__(self):
    return ("%s 生日: %s")  % (self.aaa,self.bbb)

class PersonAdmin(admin.ModelAdmin):
    list_display = (upper_case_name,)
```
3. 一个表示ModelAdmin 中某个属性的字符串。行为与可调用对象相同。 例如︰
```
class PersonAdmin(admin.ModelAdmin):
    list_display = ('upper_case_name',)

    def upper_case_name(self, obj):
        return ("%s %s" % (obj.first_name, obj.last_name)).upper()
    upper_case_name.short_description = 'Name'
```
4. 表示模型中某个属性的字符串。它的行为与可调用对象几乎相同，但这时的self 是模型实例。这里是一个完整的模型示例︰
```
from django.db import models
from django.contrib import admin

class Person(models.Model):
    name = models.CharField(max_length=50)
    birthday = models.DateField()

    def decade_born_in(self):
        return self.birthday.strftime('%Y')[:3] + "0's"
    decade_born_in.short_description = 'Birth decade'
    

class PersonAdmin(admin.ModelAdmin):
    list_display = ('name', 'decade_born_in')
```
list_display要注意的几个特殊的情况:
* 如果字段是一个ForeignKey，Django 将展示相关对象的__str__() （Python 2 上是__unicode__()）。
* 不支持ManyToManyField 字段， 因为这将意味着对表中的每一行执行单独的SQL 语句。如果尽管如此你仍然想要这样做，请给你的模型一个自定义的方法，并将该方法名称添加到 list_display。（list_display 的更多自定义方法请参见下文）。
* 如果该字段为BooleanField 或NullBooleanField，Django 会显示漂亮的"on"或"off"图标而不是True 或False。
* 如果给出的字符串是模型、ModelAdmin 的一个方法或可调用对象，Django 将默认转义HTML输出。如果你不希望转义方法的输出，可以给方法一个allow_tags 属性，其值为True。然而，为了避免XSS 漏洞，应该使用format_html() 转义用户提供的输入

下面是一个完整的示例模型
```
from django.db import models
from django.contrib import admin
from django.utils.html import format_html

class Person(models.Model):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    color_code = models.CharField(max_length=6)

    def colored_name(self):
        return format_html('<span style="color: #{};">{} {}</span>',
                           self.color_code,
                           self.first_name,
                           self.last_name)

    colored_name.allow_tags = True

class PersonAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'colored_name')

```
__str__()（Python 2 上是__unicode__()）方法在list_display 中同样合法，就和任何其他模型方法一样，所以下面这样写完全OK︰
```
list_display = ('__str__', 'some_other_field')
list_display = ('__unicode__', 'some_other_field')
```
list_display 中的字段名称还将作为HTML 输出的CSS 类， 形式为每个<th> 元素上具有column-<field_name>。例如这可以用于在CSS 文件中设置列的宽度。
django会尝试以下面的顺序解释list_dispaly的每个元素
1. 模型的字段
2. 可调用对象
3. 表示modeAdmin属性的字符串
4. 表示模型属性的字符串
例如， 如果first_name既是模型的一个字段有事modeladmin的一个属性，使用的将是模型字段


### ModelAdmin.list_display_links
使用list_display_links可以控制list_display中的字段是否应该链接到对象的“更改”页面 可以直接点击要编辑的字段进行跳转到修改页面
默认情况下，更改列表页将链接第一列 - list_display中指定的第一个字段 - 到每个项目的更改页面。但是list_display_links可让您更改此设置：
* 将其设置为None，根本不会获得任何链接
* 将其设置为要将其列转换为链接的字段列表或元组（格式与list_display相同）。
您可以指定一个或多个字段。只要这些字段出现在list_display中，Django不会关心多少（或多少）字段被链接。唯一的要求是，如果要以这种方式使用list_display_links，则必须定义list_display。

在此示例中，first_name和last_name字段将链接到更改列表页面上：
```
class PersonAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'birthday')
    list_display_links = ('first_name', 'last_name')
```
在此示例中，更改列表页面网格将没有链接：
```
class AuditEntryAdmin(admin.ModelAdmin):
    list_display = ('timestamp', 'message')
    list_display_links = None

class ClassListAdmin(admin.ModelAdmin):
    list_display = ('__unicode__','course','semester',)
    filter_horizontal = ('teachers',)
    # list_display_links = ('course', 'semester')
    list_display_links = None
```
list_display_links = ('course', 'semester')

### modeladmin.list_editable
将list_editable设置为模型上的字段名称列表，会允许在更改列表页面上进行编辑
list_editable以特定方式与其他几个选项进行交互；您应该注意以下规则
* list_editable中的任何字段也必须位于list_display中。您无法编辑未显示的字段！
* 同一字段不能在list_editable和list_display_links中列出 - 字段不能同时是表单和链接
如果这2个规则有问题 就会报错
The value of 'record' cannot be in both 'list_editable' and 'list_display_links'.   报错信息

### modelAdmin.list_filter
list_filter设置激活admin修改列表页面右侧栏中的过滤器
list_filter 应该是一个列表或元组，其每个元素应该是下面类型中的一种：
* 字段名称，其指定的字段应该是BooleanField、CharField、DateField、DateTimeField、IntegerField、ForeignKey 或ManyToManyField，例如︰

```
#也可以实现跨表之间过滤
list_filter = ("course_record__course__course","record","course_record",)

```

### ModelAdmin.list_per_page
list_per_page设置控制admin修改列表页面每页显示多少项,默认设置100页   这个就是我们的分页功能
```
list_per_page = 15
```

### ModelAdmin.list_select_related
select * from aaa where aaa=11 
aaa = Student.object.filter(id=1)
|
缓存到本地    
设置list_select_related以告诉Django在检索管理更改列表页面上的对象列表时使用select_related()。这可以节省大量的数据库查询
该值应该是布尔值，列表或元组。默认值为False。
当值为True时，将始终调用select_related()。When value is set to False, Django will look at list_display and call select_related() if any ForeignKey is present.
如果您需要更精确的控制，请使用元组（或列表）作为list_select_related的值。空元组将阻止Django调用select_related。任何其他元组将直接传递到select_related作为参数。例如：

```
class ArticleAdmin(admin.ModelAdmin):
    list_select_related = ('author', 'category')
``` 
将会调用select_related('author', 'category').
简单来说 使用这个参数后会把我们的queryset的结果保存起来  当我们进行同样的查询的时候 直接从对象中获取而不要去数据库中获取 减少数据库的查询次数
写法  可以参考mysql新建索引的写法

### ModelAdmin.save_on_top
设置save_on_top可在表单顶部添加保存按钮。
通常，保存按钮仅出现在表单的底部。如果您设置save_on_top，则按钮将同时显示在顶部和底部。 
默认情况下，save_on_top设置为False。

### ModelAdmin.search_fields
search_fields 设置启用Admin 更改列表页面上的搜索框。此属性应设置为每当有人在该文本框中提交搜索查询将搜索的字段名称的列表。
这些字段应该是某种文本字段，如CharField 或TextField。你还可以通过查询API 的"跟随"符号进行ForeignKey 或ManyToManyField 上的关联查找
```
search_fields = ('student__name','student__stu_id')
```

### djangoadmin的methods
在我们的管理后台默认就是有2个提交
一个是 modeladmin.save_model()
一个是 modeladmin.delete_model()

### djangoadmin的actions
actions  可以批量修改和删除admin当中的数据
“delete selected objects” Action 由于性能因素使用了QuerySet.delete()，这里有个附加说明：它不会调用你模型的delete()方法。

如果你想覆写这一行为，编写自定义Action，以你的方式实现删除就可以了 -- 例如，对每个已选择的元素调用Model.delete()。

### 编写action
通过例子来说明action 最为简单
actions的一个最普通的用例是模型的整体更新，考虑带有article模型的简单应用
```
class StudyRecord(models.Model):
    course_record = models.ForeignKey(CourseRecord,verbose_name=u"第几天的课程")
    student = models.ForeignKey(StudentInfo,verbose_name=u"学员")
    #choices可迭代的结构，比如列表以及我们的元祖 由迭代的元祖组成
    #默认的謦欬下就会有表格选择框，我们这个选款里面的内容就是这个元祖
    #每一个元祖中的第一个元素 是不是存到到数据库了   第二个元素 是不是显示在出来了
    record_choices = (('checked', u"已签到"),
                      ('late', u"迟到"),
                      ('noshow', u"缺勤"),
                      ('leave_early', u"早退"),
                      )
    record = models.CharField(u"上课纪录", choices=record_choices, default="checked", max_length=64)
    data = models.DateTimeField(auto_now_add=True)
    note = models.CharField(u"备注",max_length=255,blank=True,null=True)
```
这个是拿我们自己的例子来做选择   我们可以选择更新学员的出勤情况   增加4个比例更新的状态
### 编写actions函数
首先我们要定义一个函数，当在admin界面上触发该actions函数，跟普通的函数一样,需要接收3个参数
* 当前的modeladmin
* 表示当前请求的Httprequest
* 含有用户所选的对象集合的queryset
在我们去使用aciton的时候并不需要modeladmin的请求对象，但是我们会用到查询集:
```
def set_to_late(modeladmin,request,queryset):
    selected = request.POST.getlist(admin.ACTION_CHECKBOX_NAME)
    print selected
    models.StudyRecord.objects.filter(id__in=selected).update(record="late")
```
为了性能最有，我们使用个查询集的update方法，其他类型的action可能需要分别处理每个对象，这种情况我们需要对查询集遍历
编写actions的全部内容实际上就这么多了，但是我们要进行一个可选但是有用的步骤，在admin中给actions起一个友好的标婷，默认情况下，actions以 'Make published'的形式出现在在actions列表中， 讲函数名称中的所有的下划线用空额替换，这样就很好了，但是我们可以提供一个更好，更人性化的名称，通过向make_published函数添加hsort_description属性:
```
set_to_late.short_description = u"设置所选学员为--迟到"
```
这个方法跟我们list_display选择中使用同样的技巧，为这里注册的回调函数来提供人类可读的描述
### 添加操作到modelAdmin
接下来我们需要把action添加到modeladmin，它和其他配置项的工作方式相同，所有带有action及其注册的完整的amdin.py看起像这样:
```
class StudyRecordAdmin(admin.ModelAdmin):
    list_display = ('course_record','get_stu_name','get_stu_id','record','colored_record','note','data',)
    ate_hierarchy = 'data'
    actions = ["set_to_late"]
    def set_to_late(modeladmin,request,queryset):
        selected = request.POST.getlist(admin.ACTION_CHECKBOX_NAME)
        print selected
        models.StudyRecord.objects.filter(id__in=selected).update(record="late")

    set_to_late.short_description = u"设置所选学员为--迟到"
```
一个简单的actions就完成了，接下来看看一些高级的用法
在上一个例子中其实我们使用了标准化的写法 就是actions至二级绑定到studyrecordadmin对象上更有意义
```
if rows_updated == 1:
            message_bit = "1 story was"
        else:
            message_bit = "%s stories were" % rows_updated
        self.message_user(request, "%s successfully marked as published." % message_bit)
```
在这个例子当中我们返回了信息给他
这会使动作与后台在成功执行动作后做的事情相匹配这会在动作成功后返回操作信息

### 增加一个全局的操作
如果一些操作对管理站点的任何对象都可用的话，是非常不错的，上面所定义的导出操作是个不错的备选方案，你可以使用adminsite.add_action()让一个操作在全局都可以使用
例如:
from django.contrib import admin
admin.site.add_action(export_selected_objects)
这样 export_selected_objects操作可以在全局使用，名称为 "export_selected_objects" 你可以显示指定actions的名称  如果你想以编程的方式删除这个actions是非常有用的  通过向adminsite.add_actions传递第二个参数 
admin.site.add_action(export_selected_objects,'export_selected')

### 禁用操作
有时候你需要禁用特定的操作，尤其是注册站点级操作，对于特定的对象，你可以使用一些方法来禁用操作
禁用整个站点的操作
adminsite.disable_actions(name)
例如你可以使用这个方法来移除内奸的 "删除选中的对象"操作
```
admin.site.disable_action('delete_selected')
```

一旦你执行了上面的代码，这个操作对整个站点启动
如果你只需要对特定的模型重启启动在全局禁用的对象，把它显示放在modeladmin.actions列表中就可以了
```
admin.site.disable_action('delete_selected')

class ClassListAdmin(admin.ModelAdmin):
    list_display = ('__unicode__','course','semester',)
    filter_horizontal = ('teachers',)
    # list_display_links = ('course', 'semester')
    list_display_links = None
    list_editable = ('course', 'semester')
    actions = ["delete_selected"]


class StudyRecordAdmin(admin.ModelAdmin):
    list_display = ('course_record','get_stu_name','get_stu_id','record','colored_record','note','data',)
    ate_hierarchy = 'data'
    actions = ["set_to_late"]
    def set_to_late(modeladmin,request,queryset):
        selected = request.POST.getlist(admin.ACTION_CHECKBOX_NAME)
        print selected
        models.StudyRecord.objects.filter(id__in=selected).update(record="late")
```

### 为特定的modeladmin禁用所有的操作modeladmin
actions = None
这样会告诉modeladmin 不要展示或允许任何操作 包括站点及操作

### 按需启用或禁用
modeladmin.get_actions(request)
最后你可以通过覆写modeladmin.get_actions()，对每个请求按需求开启或禁用操作
这个函数返回包含允许操作的字典，字典的键是操作的名称，值是(functions,name,short_description)元祖
多数情况下，你会按需使用这个方法，来从超类中的列表移除操作，列入，如果我只希望名称以A开头的用户可以批量删除对象，我可以执行下面的代码
```
    def get_actions(self, request):
        actions = super(StudyRecordAdmin, self).get_actions(request)
        if request.user.username[0].upper() != 'A':
            if 'delete_selected' in actions:
                del actions['delete_selected']
        return actions
```
下面这个脚本就不判断用户了  是给特定的模块来显示需要的动作
```
    def get_actions(self, request):
        actions = super(StudyRecordAdmin, self).get_actions(request)

        if 'delete_selected' in actions:
            del actions['delete_selected']
        return actions
```
admin_order_field   允许字段可以排序
admin.ACTION_CHECKBOX_NAME   获得被打钩的checkbox对应的对象
entry.objects.filter(id__in=(1,2,3) in方法等效于
select * from whewre id in (1,2,3)
select * from entry where id in (1,2,3)

get_record_display


### 保留
* ModelAdmin.date_hierarchy
把 date_hierarchy 设置为在你的model 中的DateField或DateTimeField的字段名，然后更改列表将包含一个依据这个字段基于日期的下拉导航。
例如: 导入一个datafiled字段会生成一个导航  可以过滤   1.10.5自动添加日期的模式好像不行
date_hierarchy = 'date'