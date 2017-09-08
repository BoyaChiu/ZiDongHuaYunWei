### djangoORM系统 

为了理解我们做项目当中的数据库结构  我们来做一个基本的书籍/出版社 类似当当网的后台 数据库结构，我们这样做事因为这是一个简单的例子，很多sql的书籍也用这个例子
我们来设计一个基本的出版社的一个数据库
* 一个作业有名有姓，以及email地址
* 出版社有名称，地址，城市，省，国家，官网
* 书籍有书名，和出版日期，它有一个或多个作者(和作者是多对多的关联关系[many-to-many],)只有一个出版社(和出版社是一对多的关联关系[one-to-many]),也对称为外键[foreign key]
准备工作
1. setting 配置数据库
2. 编写modles表结构  
3. 同步数据库 python mange.py makemigrations   python mange.py migrate
4. 编写admin.py文件让我们的数据可以在admin后台显示
5. 创建用户
6. 登录测试


项目的文件
modles.py
```
from __future__ import unicode_literals

from django.db import models

# Create your models here.
class Author(models.Model):
    first_name = models.CharField(max_length=32)
    last_name = models.CharField(max_length=32)
    email = models.EmailField()
    def __unicode__(self):
        return "<%s %s>" %(self.first_name,self.last_name)

class Publisher(models.Model):
    name = models.CharField(max_length=64,unique=True)
    address = models.CharField(max_length=128)
    city = models.CharField(max_length=64)
    state_province = models.CharField(max_length=30)
    country = models.CharField(max_length=50)
    website = models.URLField()
    def __unicode__(self):
        return "<%s>" %(self.name)


class Book(models.Model):
    name = models.CharField(max_length=64)
    authors = models.ManyToManyField(Author)
    publisher = models.ForeignKey(Publisher)
    publish_date = models.DateField(auto_now_add=True)
    def __unicode__(self):
        return "<%s--%s>" %(self.name,self.publish_date)
```
admin.py
```
from django.contrib import admin
import models
# Register your models here.
admin.site.register(models.Author)
admin.site.register(models.Book)
admin.site.register(models.Publisher)
```

### 直接访问数据库里面的数据(不是原始的SQL)
我们的django为我们的模型提供了高级的python API我们不光可以通过在后台添加数据也可以通过命令的方式来添加数据
运行 ptyhon manage.py shell 并输入下面的代码试试
```
>>> from bookss.models import Publisher
>>> p1 = Publisher(name='tanzhouzhexue', address='changshadifz',
...     city='beijing', state_province='hunan', country='CHAINA',
...     website='http://www.ceshi.com/')
>>> p1.save()
>>> p2 = Publisher(name="asdsdsd", address='2323.',
...     city='123123', state_province='fff', country='asdasd',
...     website='http://www.fffff.com/')
>>> p2.save()
>>> publisher_list = Publisher.objects.all()
>>> publisher_list
<QuerySet [<Publisher: <浠€涔堜粈涔堝嚭鐗堢ぞ>>, <Publisher: <娼
窞鍑虹増绀?>, <Publisher: <tanzhouzhexue>>]>

```
这里有一个值得注意的地方，在这个例子可能并未清晰的展示，当你使用modle API创建对象时DJANGO并未将对象保存到数据库当中除非你调用了save()方法:
```
p1 = Publisher(...)
p1.save()
```
当你没有执行.save()操作的时候随时都可以修改
如果你需要进一步完成对象的创建与存储到数据库，就使用'objects.create()'方法
```
>>> p1 = Publisher.objects.create(name='ceshi',
...     address='sdfsfs',
...     city='changsha', state_province='hunan', country='changsha',
...     website='http://www.apress.com/')
>>> publisher_list = Publisher.objects.all()
>>> publisher_list
```
---
###插入和更新数据
我们先来插入创建一个实例
```
>>> p = Publisher(name='tanzhouawen',
...         address='guangdongguangzhou',
...         city='guangzhou',
...         state_province='guangdong',
...         country='China',
...         website='http://www.guangdong.com/')
>>> p.save()
```
我们这里创建了一个出版商并且把对象实例保存到数据库里面了
在sql当中应该是这样的
```
INSERT INTO books_publisher
    (name, address, city, state_province, country, website)
VALUES
    ('tanzhouawen', 'guangdongguangzhou', 'guangzhou', 'guangdong',
     'China', 'http://www.guangdong.com/');
```
因为Publisher模型里面有一个自增加的主键ID，所以第一次调用save()还多做了一件事，计算这个主键的值并把它赋值给这个对象实例
```
>>> p.id
```
那么接下来我们再调用save()将不会创建新的记录，而只是修改记录的内容(也就是执行UPDATESQL语句，而不是INSERT语句)
```
>>> p.name = 'nidongdongshishi'
>>> p.save()
```
```
UPDATE books_publisher SET
    name = 'Apress Publishing',
    address = '2855 Telegraph Ave.',
    city = 'Berkeley',
    state_province = 'CA',
    country = 'U.S.A.',
    website = 'http://www.apress.com'
WHERE id = 52;
```
注意，并不是只更新修改过的那个字段，所有的字段都会被更新。
###查找对象
当然，创建新的数据库，并更新之中的数据是必要的，但是，对于Web应用程序来说，更多的时候是在检索查询数据库。 我们已经知道如何从一个给定的模型中取出所有记录：
```
>>> Publisher.objects.all()
[<Publisher: Apress>, <Publisher: O'Reilly>]
```
SQL
```
SELECT id, name, address, city, state_province, country, website
FROM books_publisher;
select * from books_publisher;
```
注意到Django在选择所有数据时并没有使用 SELECT* ，而是显式列出了所有字段。 设计的时候就是这样：SELECT* 会更慢，而且最重要的是列出所有字段遵循了Python 界的一个信条： 明言胜于暗示。
### 数据过滤
我们很少会一次性从数据库中取出所有的数据；通常都只针对一部分数据进行操作。 在Django API中，我们可以使用`` filter()`` 方法对数据进行过滤：
```
>>> Publisher.objects.filter(name='Apress')
[<Publisher: Apress>]
```
filter() 根据关键字参数来转换成 WHERE SQL语句。 前面这个例子 相当于这样
```
SELECT id, name, address, city, state_province, country, website
FROM books_publisher
WHERE name = 'Apress';
```
你可以传递多个参数到 filter() 来缩小选取范围
```
>>> Publisher.objects.filter(country="U.S.A.", state_province="CA")
[<Publisher: Apress>]`
```
多个参数会被转换成 AND SQL从句， 因此上面的代码可以转化成这样：
```
SELECT id, name, address, city, state_province, country, website
FROM books_publisher
WHERE country = 'China'
AND state_province = 'hunan';
```
注意，SQL缺省的 = 操作符是精确匹配的， 其他类型的查找也可以使用：
```
>>> Publisher.objects.filter(name__contains="press")
[<Publisher: Apress>]
```
在 name 和 contains 之间有双下划线。和Python一样，Django也使用双下划线来表明会进行一些魔术般的操作。这里，contains部分会被Django翻译成LIKE语句：
```
SELECT id, name, address, city, state_province, country, website
FROM books_publisher
WHERE name LIKE '%ceshi%';
```
其他的一些查找类型有：icontains(大小写不敏感的LIKE),startswith和endswith, 还有range
---
# 获取单个对象
上面的例子中`` filter()`` 函数返回一个记录集，这个记录集是一个列表。 相对列表来说，有些时候我们更需要获取单个的对象， `` get()`` 方法就是在此时使用的：
```
>>> Publisher.objects.get(name="ceshi")
<Publisher: ceshi>
```
这样，就返回了单个对象，而不是列表（更准确的说，QuerySet)。 所以，如果结果是多个对象，会导致抛出异常：
```
>>> Publisher.objects.get(country="China")
Traceback (most recent call last):
    ...
MultipleObjectsReturned: get() returned more than one Publisher --
    it returned 2! Lookup parameters were {'country': 'China'}
```
如果查询没有返回结果也会抛出异常
```
>>> Publisher.objects.get(name="ceshi2222")
Traceback (most recent call last):
    ...
DoesNotExist: Publisher matching query does not exist.
```
这个 DoesNotExist 异常 是 Publisher 这个 model 类的一个属性，即 Publisher.DoesNotExist。在你的应用中，你可以捕获并处理这个异常，像这样：
```
try:
    p = Publisher.objects.get(name='Apress')
except Publisher.DoesNotExist:
    print "Apress isn't in the database yet."
else:
    print "Apress is in the database."
```
### 数据排序
在运行前面的例子中，你可能已经注意到返回的结果是无序的。 我们还没有告诉数据库 怎样对结果进行排序，所以我们返回的结果是无序的。
在你的 Django 应用中，你或许希望根据某字段的值对检索结果排序，比如说，按字母顺序。 那么，使用order_by() 这个方法就可以搞定了。
```
>>> Publisher.objects.order_by("name")
[<Publisher: Apress>, <Publisher: O'Reilly>]
```
跟以前的 all() 例子差不多，SQL语句里多了指定排序的部分：
```
SELECT id, name, address, city, state_province, country, website
FROM books_publisher
ORDER BY name;
```
我们可以对任意字段进行排序：
```
>>> Publisher.objects.order_by("address")
[<Publisher: O'Reilly>, <Publisher: Apress>]
 
>>> Publisher.objects.order_by("state_province")
[<Publisher: Apress>, <Publisher: O'Reilly>]　
```
如果需要以多个字段为标准进行排序（第二个字段会在第一个字段的值相同的情况下被使用到），使用多个参数就可以了，如下：
```
>>> Publisher.objects.order_by("state_province", "address")
 [<Publisher: Apress>, <Publisher: O'Reilly>]
```
我们还可以指定逆向排序，在前面加一个减号 - 前缀：
```
>>> Publisher.objects.order_by("-name")
[<Publisher: O'Reilly>, <Publisher: Apress>]
```
尽管很灵活，但是每次都要用 order_by() 显得有点啰嗦。 大多数时间你通常只会对某些 字段进行排序。 在这种情况下，Django让你可以指定模型的缺省排序方式：
```
class Publisher(models.Model):
    name = models.CharField(max_length=30)
    address = models.CharField(max_length=50)
    city = models.CharField(max_length=60)
    state_province = models.CharField(max_length=30)
    country = models.CharField(max_length=50)
    website = models.URLField()
 
    def __unicode__(self):
        return self.name
 
    class Meta:
        ordering = ['name']
```
现在，让我们来接触一个新的概念。 class Meta，内嵌于 Publisher 这个类的定义中（如果 class Publisher 是顶格的，那么 class Meta 在它之下要缩进4个空格－－按 Python 的传统 ）。你可以在任意一个 模型 类中使用Meta 类，来设置一些与特定模型相关的选项。Meta 还可设置很多其它选项，现在，我们关注ordering 这个选项就够了。 如果你设置了这个选项，那么除非你检索时特意额外地使用了 order_by()，否则，当你使用 Django 的数据库 API 去检索时，Publisher对象的相关返回值默认地都会按 name 字段排序。
### 连锁查询
我们已经知道如何对数据进行过滤和排序。 当然，通常我们需要同时进行过滤和排序查询的操作。 因此，你可以简单地写成这种“链式”的形式：
```
>>> Publisher.objects.filter(country="U.S.A.").order_by("-name")
[<Publisher: O'Reilly>, <Publisher: Apress>]
```
转换成SQL查询就是 WHERE 和 ORDER BY 的组合：
```
SELECT id, name, address, city, state_province, country, website
FROM books_publisher
WHERE country = 'U.S.A'
ORDER BY name DESC;
```
### 限制返回数据
另一个常用的需求就是取出固定数目的记录。 想象一下你有成千上万的出版商在你的数据库里， 但是你只想显示第一个。 你可以使用标准的Python列表裁剪语句：
```
>>> Publisher.objects.order_by('name')[0]
<Publisher: Apress>
```
SQL:
```
SELECT id, name, address, city, state_province, country, website
FROM books_publisher
ORDER BY name
LIMIT 1;
```
类似的，你可以用Python的range-slicing语法来取出数据的特定子集：
```
>>> Publisher.objects.order_by('name')[0:2]
```
这个例子返回两个对象，等同于以下的SQL语句：
```
SELECT id, name, address, city, state_province, country, website
FROM books_publisher
ORDER BY name
OFFSET 0 LIMIT 2;
```
注意，不支持Python的负索引(negative slicing)：
```
>>> Publisher.objects.order_by('name')[-1]
Traceback (most recent call last):
  ...
AssertionError: Negative indexing is not supported.
```
虽然不支持负索引，但是我们可以使用其他的方法。 比如，稍微修改 order_by() 语句来实现：
```
>>> Publisher.objects.order_by('-name')[0]
```

更新多个对象
在“插入和更新数据”小节中，我们有提到模型的save()方法，这个方法会更新一行里的所有列。 而某些情况下，我们只需要更新行里的某几列。
例如说我们现在想要将Apress Publisher的名称由原来的”Apress”更改为”Apress Publishing”。若使用save()方法，如：
```
>>> p = Publisher.objects.get(name='Apress')
>>> p.name = 'Apress Publishing'
>>> p.save()
```
SQL:
```
SELECT id, name, address, city, state_province, country, website
FROM books_publisher
WHERE name = 'ceshi';
 
UPDATE books_publisher SET
    name = 'ceshi111',
    address = 'changsha',
    city = 'changsha',
    state_province = 'hunan',
    country = 'China',
    website = 'http://www.baidu.com'
WHERE id = 34;
```
在这个例子里我们可以看到Django的save()方法更新了不仅仅是name列的值，还有更新了所有的列。 若name以外的列有可能会被其他的进程所改动的情况下，只更改name列显然是更加明智的。 更改某一指定的列，我们可以调用结果集（QuerySet）对象的update()方法： 示例如下：
```
>>> Publisher.objects.filter(id=52).update(name='ceshi111')
```
与之等同的SQL语句变得更高效，并且不会引起竞态条件
```
UPDATE books_publisher
SET name = 'Apress Publishing'
WHERE id = 52;
```
update()方法对于任何结果集（QuerySet）均有效，这意味着你可以同时更新多条记录。 以下示例演示如何将所有Publisher的country字段值由’U.S.A’更改为’USA’：
```
Publisher.objects.all().update(country='China')
```
update()方法会返回一个整型数值，表示受影响的记录条数。 在上面的例子中，这个值是2。
## 删除对象
删除数据库中的对象只需调用该对象的delete()方法即可：
```
>>> p = Publisher.objects.get(name="ceshi")
>>> p.delete()
>>> Publisher.objects.all()
[<Publisher: ceshi>]
```
同样我们可以在结果集上调用delete()方法同时删除多条记录。这一点与我们上一小节提到的update()方法相似：
```
>>> Publisher.objects.filter(country='USA').delete()
>>> Publisher.objects.all().delete()
>>> Publisher.objects.all()
```
删除数据时要谨慎！ 为了预防误删除掉某一个表内的所有数据，Django要求在删除表内所有数据时显示使用all()。 比如，下面的操作将会出错：
```
>>> Publisher.objects.delete()
Traceback (most recent call last):
  File "<console>", line 1, in <module>
AttributeError: 'Manager' object has no attribute 'delete'　
```
而一旦使用all()方法，所有数据将会被删除
```
>>> Publisher.objects.all().delete()
```
如果只需要删除部分的数据，就不需要调用all()方法。再看一下之前的例子：
```
>>> Publisher.objects.filter(country='USA').delete()
```








