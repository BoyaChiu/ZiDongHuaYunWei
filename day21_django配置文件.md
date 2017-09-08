### 项目的构建路径
添加路径
```
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
```

### 特定django安装的秘钥 
如果没有设置秘钥,django将拒绝启动  如果秘钥以及被泄露那么可能导致特权升级和远程代码执行漏洞
```
SECRET_KEY = 'b6b$w0pmop90!+^%k#-xsgpn5n2*dd=kvu2za3l%fz^92*kjar'
```

### 打开或者关闭调试模式  
* DEBUG = True  
部署网站的时候不要把DEBUG 打开.  
你明白了吗？部署网站的时候一定不要把 DEBUG 打开.  
调试模式的一个重要特性是显示错误页面的细节。当DEBUG 为 True的时候,若你的应用产生了一个异常，Django 会显示追溯细节,包括许多环境变量的元数据,   比如所有当前定义的Django设置(在settings.py中的).  
作为安全措施, Django 将 不会 包括敏感的 (或者可能会被攻击的)设置, 例如 SECRET_KEY. 特别是名字中包含下面这些单词的设置:   
* 关键字  'API' 'KEY' 'PASS' 'SECRET' 'SIGNATURE' 'TOKEN'  
不过，总有一些调试的输出你不希望展现给公众的。文件路径， 配置信息和其他，将会提供信息给攻击者来攻击你的服务器。  
另外，很重要的是要记住当你运行时 DEBUG 模式打开的话, Django 记住所有执行的 SQL 查询语句。 这在进行 DEBUG 调试时非常有用, 但这会消耗运行服务器的大量内存资源.  
最后，如果DEBUG 为False，你还需要正确设置ALLOWED_HOSTS。设置错误将导致对所有的请求返回“Bad Request (400)”。  

### ALLOWED_HOSTS   
默认值：[]（空列表）  
ALLOW_HOSTS = ['*'] 来允许所有的
代表Django站点可以提供的主机/域名的字符串列表。这是一个防御攻击者的措施，攻击会来源于缓存中毒然后密码被重置，并通过提交一个伪造了Host   header(主机头信息)的密码重置请求使得邮箱被链接到恶意主机，这是有可能发生的，即使在很多看似安全的web服务器配置中。  

列表中的值要是完全合格的名称 (e.g. 'www.example.com'), 这种情况下，他们将会正确地匹配请求的Host header   (忽略大小写，不包括端口).。开始处的英文句号能够用于作为子域名的通配符: '.example.com' 会匹配example.com, www.example.com, 以及任何example.com. 的子域名。 '*'会匹配任何的值;在这种情况中，你务必要提供你自己的Host header的验证 (也可以是在中间件中，如果这样的话，中间件要首先被列入在MIDDLEWARE_CLASSES中).。
```
ALLOWED_HOSTS = [
    '.example.com',  # Allow domain and subdomains
    '.example.com.',  # Also allow FQDN and subdomains
]
```

### INSTALLED_APPS
默认值：()（空元组）
一串字符串，指定在此Django安装中启用的所有应用程序。每个字符串应该是包含Django应用程序的Python包的完整Python路径，由django-admin.py startapp创建。
app名字必须是唯一的
在INSTALLED_APPS中定义的应用程序名称（即包含models.py的模块的路径的最终虚线部分）必须是唯一的。例如，您不能在INSTALLED_APPS中同时包含django.contrib.auth和myproject.auth。

### MIDDLEWARE(中间件)
如果要激活一个中间件就必须把中间件添加到django的配置文件 MIDOLEWARE里面来，每一个中间件都用完整的python路径
Django的程序中，中间件不是必需的 —— 只要你喜欢，MIDDLEWARE_CLASSES可以为空 —— 但是强烈推荐你至少使用CommonMiddleware。
MIDDLEWARE中的顺序非常重要，因为一个中间件可能依赖于另外一个。例如，AuthenticationMiddleware在会话中储存已认证的用户。所以它必须在SessionMiddleware之后运行。一些关于Django中间件类的顺序的常见提示，请见中间件排序。

### ROOT_URLCONF
默认值：没有定义
一个字符串，表示根URLconf 的完整Python 导入路径。例如："mydjangoapps.urls"。每个请求可以覆盖它，方法是设置进来的HttpRequest 对象的urlconf属性

### TEMPLATES
默认:: []（空列表） 
设置模板路径   格式是字典的格式

### WSGI_APPLICATION
默认值：None
Django的内置服务器（例如runserver）将使用的WSGI应用程序对象的完整Python路径。The django-admin startproject management command will create a simple wsgi.py file with an application callable in it, and point this setting to that application.

如果未设置，将使用django.core.wsgi.get_wsgi_application()的返回值。在这种情况下，runserver的行为将与以前的Django版本相同。

### DATABASES(数据库设置)
默认：{} （空字典）
一个字典，包含Django 将使用的所有数据库的设置。它是一个嵌套的字典，其内容为数据库别名到包含数据库选项的字典的映射。  
DATABASES 设置必须配置一个default 数据库；可以同时指定任何数目的额外数据库。  
最简单的配置文件可能是使用SQLite 建立一个数据库。这可以使用以下配置：  
如果是测试 不需要更改  如果是线上才需要更改数据库设置
当连接其他数据库后端，比如MySQL、Oracle 或PostgreSQL，必须提供更多的连接参数。关于如何指定其他的数据库类型，参见后面的ENGINE 设置。下面的例子用于PostgreSQL：
```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'mydatabase',
        'USER': 'mydatabaseuser',
        'PASSWORD': 'mypassword',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}
```

###  AUTH_PASSWORD_VALIDATORS(密码验证器)
django1.10开始提供秘钥验证，以防止用户使用弱密码，django中默认包含4个验证器 可以执行最小长度，将密码与用户的属性（如其名称）进行比较，确保密码不是完全数字的，或者检查包含的常见密码列表。您可以组合多个验证器，一些验证器具有自定义配置选项。例如，您可以选择提供常用密码的自定义列表。每个验证器提供帮助文本以向用户解释其要求。
默认情况下，不执行热河验证，所有密码都被接收，所以如果没有设置AUTH_PASSWORD_VALIDATORS，你将看不到任何更改，一般不需要修改

### LANGUAGE_CODE
默认值：'en-us'
表示此安装的语言代码的字符串。这应该是标准的language ID format。例如，美国英语是"en-us"。另请参阅语言标识符列表和Internationalization and localization。 USE_I18N必须处于活动状态才能使此设置生效
* 如果区域中间件未使用，则会决定向所有用户提供哪个翻译。
* 如果区域中间件处于活动状态，则它会提供后备语言，以防用户的首选语言无法确定或网站不支持。当用户的首选语言不存在给定文字的翻译时，它还提供后备翻译。

### USE_I18N¶
默认值：True
这是一个布尔值，它指定Django的翻译系统是否被启用。它提供了一种简单的方式去关闭翻译系统。如果设置为 False, Django 会做一些优化，不去加载翻译机制

### USE_L10N
默认值：False
是一个布尔值，用于决定是否默认进行日期格式本地化。如果此设置为True，例如Django将使用当前语言环境的格式显示数字和日期

### USE_TZ
默认: True
这是一个布尔值,用来指定是否使用指定的时区(TIME_ZONE)的时间.若为 True, 则Django 会使用内建的时区的时间否则, Django 将会使用本地的时间

### STATIC_URL
默认值: None
引用位于STATIC_ROOT中的静态文件时使用的网址。

示例："/static/"或"http://static.example.com/"

如果不是None，则将用作asset definitions（Media类）和staticfiles app

如果设置为非空值，它必须以斜杠结尾。

您可能需要configure these files to be served in development，并且肯定需要在生产中执行in production


