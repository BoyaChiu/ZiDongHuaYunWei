#-*- coding:utf-8 -*-
import urllib2
import sys
import json
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
#定义URL 就是zabbixAPI接口请求的地址
#从数据库里面获取所有的IP 跟zabbix里面进行对比   如果存在就修改hostname 如果不存在就ceatey一台主机

url = 'http://172.16.136.10/api_jsonrpc.php'

#定义mysql的连接信息
cmdbip     ='172.16.136.11'
cmdbport   = 3306
cmdbname   = 'ly'
cmdbpasswd = 't8HPW6^8sg'
cmdbuser   ='root'

#数据库中使用的表
# VMTABLE    ='gsys_admin_vm'
# ROLETABLE  ='gsys_admin_role'
# GAMETABLE  ='gsys_admin_db'
# PORTTABLE  ='gsys_admin_port'
DB_CONNECT_STRING = r'mysql+mysqldb://%s:%s@%s:%s/%s?charset=utf8' % (cmdbuser,cmdbpasswd,cmdbip,cmdbport,cmdbname,)
# print DB_CONNECT_STRING
engine = create_engine(DB_CONNECT_STRING, echo=False)
DB_Session = sessionmaker(bind=engine)
session = DB_Session()
def get_allip():
    sql='select distinct av_vmip from gsys_admin_vm;'
    res=session.execute(sql).fetchall()
    return res
def get_hostname(ip):
    print ip
    sql="select ar_role from gsys_admin_role where ar_vmid=(select sysid from gsys_admin_vm where av_vmip='%s');"  %  (ip)
    # sql="select sysid from gsys_admin_vm where av_vmip='%s';" % (ip)
    ress=session.execute(sql).fetchall()
    res=''
    for i in ress:
        res +=i[0]
    return res
ip=111
aaa = get_hostname(ip)
url
#通过API接口创建一个主机
def createhost(ip,auth):
    values = {
            "jsonrpc": "2.0",
            "method": "host.create",
            "params": {
                "host": "ceshi15",
                "interfaces": [
                    {
                        "type": 1,
                        "main": 1,
                        "useip": 1,
                        "ip": ip,
                        "dns": "",
                        "port": "10050"
                    }
                ],
                "groups": [
                    {
                        "groupid": "2"
                    }
                ],
                "templates": [
                    {
                        "templateid": "10115"
                    }
                ],
                "inventory_mode": 0,
                "inventory": {
                    "macaddress_a": "08:00:27:4F:B4:02",
                }
            },
            "auth": auth,
            'id': '5'
        }


    output = requestJson(url, values)
    return output
#通过api接口获取说有的主机IP
def ipgetHostsid(ip,url,auth):
    values = {'jsonrpc': '2.0',
              'method': 'host.get',
              'params': {
                  'output': [ "host" ],
                  'filter': {
                      'ip': ip
                  }
              },
              'auth': auth,
              'id': '3'
              }
    output = requestJson(url,values)
    return output

def getallip(url,auth):
    values = {'jsonrpc': '2.0',
              'method': 'host.get',
              'params': {
                  'output': ["host"],
                  "selectInterfaces": ["ip"]
              },
              'auth': auth,
              'id': '3'
              }
    output = requestJson(url, values)
    return output

def addnewuser(auth,username,password):
    values = {
    "jsonrpc": "2.0",
    "method": "user.create",
    "params": {
        "alias": username,
        "passwd": password,
        "usrgrps": [
            {
                "usrgrpid": "7"
            }
        ],
        "user_medias": [
            {
                "mediatypeid": "1",
                "sendto": "support@company.com",
                "active": '0',
                "severity": '63',
                "period": "1-7,00:00-24:00"
            }
        ]
    },
    "auth": auth,
    'id': '1'
    }
    output = requestJson(url, values)
    return output


#获取所有在zabbix里面监控的主机
def getallzabbixip(url,auth):
    values = {
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
        "output": [
            "host"
        ],
        "selectInterfaces": [
            "ip"
        ],
    },
    "id": '7',
    "auth": auth
}
    output = requestJson(url,values)
    return output

#通过api接口更新主机的hsotname
def updatehostname(hostid,hostname,url,auth):
    values = {'jsonrpc': '2.0',
              'method': 'host.update',
              'params': {
                  "hostid": hostid,
                    "name": hostname,
              },
              'auth': auth,
              'id': '4'
              }

    output = requestJson(url, values)
    # return output

#获取所有的告警信息
def getproble(url,auth):
    values = {
    "jsonrpc": "2.0",
    "method": "problem.get",
    "params": {
        "output": ["extend"],
        "selectAcknowledges": "extend",
    },
    "auth": auth,
    "id": '8'
}
    output = requestJson(url, values)
    return output

def getalert(url,auth):
    values = {
    "jsonrpc": "2.0",
    "method": "alert.get",
    "params": {
        "output": "extend",

    },
    "auth": auth,
    "id": '9'
}
    output = requestJson(url, values)
    return output

#定义通过HTTP方式访问API地址的函数，后面每次请求API的各个方法都会调用这个函数
#这个是一个通用的方法 可以用来请求zabbix 同样的也可以请求其他接口
def requestJson(url,values):
    data = json.dumps(values)
    req = urllib2.Request(url, data, {'Content-Type': 'application/json-rpc'})
    response = urllib2.urlopen(req, data)
    output = json.loads(response.read())
    output['result']
#    print output
    try:
        message = output['result']
    except:
        message = output['error']['data']
        print message
        quit()

    return output['result']

#API接口认证的函数，登录成功会返回一个Token
#大部分的接口  认证   请求的时候需要一个token  功能接口
def authenticate(url):
    values = {'jsonrpc': '2.0',
              'method': 'user.login',
              'params': {
                  'user': 'Admin',
                  'password': 'redhat'
              },
              'id': '1'
              }
    idvalue = requestJson(url,values)
    return idvalue
#得到了所有的业务库当中的ip地址
# allip=get_allip()
# print "业务库当中所有的IP"
# print allip
auth=authenticate(url)
print auth
# getalertaa=getalert(url,auth)
# print getalertaa
# getporf=getproble(url,auth)
# print getporf
# getzabbix_ip=getallzabbixip(url,auth)
# print getzabbix_ip
# username='tanzhouawen'
# password='123456'
# addnewuser(auth,username,password)
#测试代码
# ip='172.16.102.22'
# hostid=ipgetHostsid(url,auth)
# print hostid

allip=getallip(url,auth)
# print '-------->'
# print allip

# ip='172.16.83.18'

# for fiteip in allip:
#     print fiteip['interfaces'][0]['ip']
for fiteip in allip:
    print fiteip
    ip=fiteip['interfaces'][0]['ip']
    hostgetid = ipgetHostsid(ip, url, auth)
    print hostgetid
    if hostgetid:
        hostname = get_hostname(ip)
        for i in hostgetid:
            hostid = i['hostid']
            print '---------->'
            print hostid
        updatehostname(hostid,hostname,url,auth)