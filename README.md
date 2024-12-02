
[luci-app-cumt-net cumt 校园网自动登录Luci界面 ](https://github.com/Akinator365/luci-app-cumt-net)
======================
### 使用方法:
需要搭配openwrt使用，在路由器系统安装[cumt-net.ipk](https://github.com/Akinator365/cumt-net)包后，再安装这个包，配置登录规则以及代理规则
### 主界面：
![image](https://github.com/Akinator365/luci-app-cumt-net/blob/master/demo-png/main.png)
### 登录规则配置：
![image](https://github.com/Akinator365/luci-app-cumt-net/blob/master/demo-png/login.png)
### Passwall规则配置：
![image](https://github.com/Akinator365/luci-app-cumt-net/blob/master/demo-png/passwall.png)
### 下载源码方法:

 ```Brach
 
    # 下载源码
	
    git clone https://github.com/Akinator365/luci-app-cumt-net package/luci-app-cumt-net
    make menuconfig
	
 ``` 
### 配置菜单

 ```Brach
    make menuconfig
	# 找到 LuCI -> Applications, 选择 luci-app-cumt-net, 保存后退出。
 ``` 
 
### 编译

 ```Brach 
    # 编译固件
    make package/luci-app-cumt-net/{clean,compile} V=s
 ```