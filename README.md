
[luci-app-cumt-net cumt 校园网自动登录Luci界面 ](https://github.com/Akinator365/luci-app-cumt-net)
======================

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