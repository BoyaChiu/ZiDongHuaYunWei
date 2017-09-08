在四层（tcp）实现负载均衡的软件：
    lvs------>重量级
    nginx------>轻量级，带缓存功能，正则表达式较灵活
    haproxy------>模拟四层转发，较灵活
    在七层（http）实现反向代理的软件：
    haproxy------>天生技能，全面支持七层代理，会话保持，标记，路径转移；
    nginx------>只在http协议和mail协议上功能比较好，性能与haproxy差不多；
    apache------>功能较差

global					#全局配置参数  
        log 127.0.0.1 local3 info	#日志级别  
        maxconn 4096  
        user haproxy  
        group haproxy  
        daemon			#设置为后台进程  
	pidfile /usr/local/haproxy/haproxy.pid	#进程的pid文件  
defaults			#默认配置，被frontend，backend，listen段继承使用  
        log global  
        mode http		#Haproxy工作模式，四层工作模式为TCP  
        option httplog  
	option forwardfor 	#使后端服务器获取客户端的真实IP  
	option redispatch	#如果cookie中写入ServerID而客户端不会刷新Cookie，那么当ServerID对应的服务器宕机后，将强制定向到其它健康的服务器上  
	option abortonclose	#当服务器负载过高时，将自动关闭队列中处理时间较长的连接请求  
	cookie SERVERID		#允许向cookie中插入SERVERID，服务器的SERVERID在后端使用cookie关键字定义  
        retries 3               #服务器连接失败后的重试次数  
        maxconn 2000            #每个进程的最大连接数  
        timeout connect 5000    #连接最大超时时间，默认毫秒  
        timeout client 30000	#客户端最大超时时间  
        timeout server 30000	#服务端超时时间  
listen haproxy_stats		#定义Haproxy监控  
        bind 0.0.0.0:8080    #设置Frontend和Backend的组合体，监控组的名称，按需要自定义名称
        mode http          #默认的模式mode { tcp|http|health }，tcp是4层，http是7层，health只会返回OK
        log global    
        stats enable        
        stats refresh 5s	#页面刷新间隔为5s  
        stats realm Haproxy\ Statistics  
        stats uri /haproxy_stats	#监控页面的URL  
        stats hide-version           #隐藏统计页面上HAProxy的版本信息
        stats auth haproxy:abc-123	#指定监控页面登陆的用户名和密码  
frontend haproxy_web		#定义客户端访问的前端服务器  
        bind 0.0.0.0:80		#定义监听的套接字  
        mode http  
        log global  
        option httplog		#启用http日志  
        option httpclose	#每次请求完毕后，关闭http通道  
	acl php_web path_end .php  #定义一个名叫php_web的acl策略，当请求的url以.php结尾时会被匹配到  
  
	use_backend php_server if php_web	#如果条件满足策略php_web时，则将请求交给后端的php_server服务器  
        default_backend servers			#设置默认的后端服务器组  
backend servers			#定义后端服务器组  
        mode http  
        option httpchk GET /index.html	#开启对后端服务器的健康检查，通过检查index.html文件来判断服务器的健康状况  
        balance roundrobin              #负载均衡算法为轮询，  
        server web1 192.168.154.162:80 check inter 2000 rise 2 fall 3  #对后端服务器的健康状况检查间隔为2000毫秒，连续2次健康检查成功，则认为是有效的，连续3次健康检查失败，则认为服务器宕机  
        server web2 192.168.154.156:80 check inter 2000 rise 2 fall 3  
backend php_server  
	mode http  
	option httpchk GET /index.php  
	server web3 192.168.154.158:80 cookie web3 check inter 2000 rise 2 fall 3 weight 2  
	
	