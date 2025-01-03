local d = require "luci.dispatcher"
local uci = require("luci.model.uci").cursor()

mp = Map("cumt-net", translate("CUMT网络助手"))
mp.description = "定时自动连接校园网及自动配置代理"

-- 添加状态显示模板 定义了一个SimpleSection，只显示内容的页面部分（无交互功能）
mp:section(SimpleSection).template  = "cumt-net/cumt_net_status"

-- 添加一个匿名Section，上面添加服务开关选框
service_switch_section = mp:section(TypedSection, "cumt_net")
service_switch_section.anonymous=true
service_switch_section.addremove=false

-- 为服务开关Section添加选框
enable_flag = service_switch_section:option(Flag, "enabled", translate("Enable"))
enable_flag.rmempty = false
enable_flag.default = 0
enable_flag.optional = false

-- 捕获用户修改事件
function enable_flag.write(self, section, value)
    -- 更新到 UCI 配置
    uci:set("cumt-net", section, "enabled", value)
    uci:commit("cumt-net")

    -- 触发服务重载
    if value == "1" then
        os.execute("/etc/init.d/luci-app-cumt-net start")
    end
end

s = mp:section(TypedSection, "login", "自动登录规则")
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"
s.extedit = d.build_url("admin", "services", "cumt-net", "login-config", "%s")
function s.create(e, t)
    local uuid = string.gsub(luci.sys.exec("echo -n $(cat /proc/sys/kernel/random/uuid)"), "-", "")
    t = uuid
    TypedSection.create(e, t)
    luci.http.redirect(e.extedit:format(t))
end
function s.remove(e, t)
    e.map.proceed = true
    e.map:del(t)
    luci.http.redirect(d.build_url("admin", "services", "cumt-net"))
end

o = s:option(Flag, "enable", translate("Enable"))
o.width = "5%"
o.rmempty = false

o = s:option(DummyValue, "remarks", translate("Remarks"))

o = s:option(DummyValue, "action", "操作")

o = s:option(DummyValue, "isp", "运营商")

o = s:option(DummyValue, "account", "账号")

o = s:option(DummyValue, "weekdays", "启用日期")

o = s:option(DummyValue, "time", "启用时间")



s = mp:section(TypedSection, "passwall", "Passwall规则")
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"
s.extedit = d.build_url("admin", "services", "cumt-net", "passwall-config", "%s")
function s.create(e, t)
    local uuid = string.gsub(luci.sys.exec("echo -n $(cat /proc/sys/kernel/random/uuid)"), "-", "")
    t = uuid
    TypedSection.create(e, t)
    luci.http.redirect(e.extedit:format(t))
end
function s.remove(e, t)
    e.map.proceed = true
    e.map:del(t)
    luci.http.redirect(d.build_url("admin", "services", "cumt-net"))
end

o = s:option(Flag, "enable", translate("Enable"))
o.width = "5%"
o.rmempty = false

o = s:option(DummyValue, "remarks", translate("Remarks"))

o = s:option(DummyValue, "action", "操作")

o = s:option(DummyValue, "node", "节点")

o = s:option(DummyValue, "mode", "模式")

o = s:option(DummyValue, "weekdays", "启用日期")

o = s:option(DummyValue, "time", "启用时间")


return mp
