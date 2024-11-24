local d = require "luci.dispatcher"

m = Map("cumt-login", "规则配置")
m.redirect = d.build_url("admin", "services", "cumt-login")

s = m:section(NamedSection, arg[1], "config", "")
s.addremove = false
s.dynamic = false

o = s:option(Flag, "enable", translate("Enable"))
o.default = "1"
o.rmempty = false

o = s:option(Value, "remarks", translate("Remarks"))
o.placeholder = "备注"
o.rmempty = true

o = s:option(ListValue, "action", "操作")
o:value("login", translate("login"))
o:value("logout", translate("logout"))
o.optional = false  -- 必填项
o.rmempty = false

o = s:option(Value, "account", "账号")
o:depends("action", "login")
o.optional = false  -- 必填项
o.rmempty = false   -- 禁止为空

password = s:option(Value, "password", translate("Password"))
password:depends("action", "login")
password.password = true  -- 将输入框设置为密码框
password.optional = false  -- 必填项
password.rmempty = false   -- 禁止为空

o = s:option(ListValue, "isp", "运营商")
o:value("cumt", "校园网")
o:value("unicom", "联通")
o:value("cmcc", "移动")
o:value("telecom", "电信")
o:depends("action", "login")
o.optional = false  -- 必填项
o.rmempty = false   -- 禁止为空

o = s:option(MultiValue, "weekdays", "启用日期")
o:value("1", translate("Monday"))
o:value("2", translate("Tuesday"))
o:value("3", translate("Wednesday"))
o:value("4", translate("Thursday"))
o:value("5", translate("Friday"))
o:value("6", translate("Saturday"))
o:value("0", translate("Sunday"))
o.optional = false  -- 必填项
o.rmempty = false   -- 禁止为空

-- 添加一个时间选择框
time_select = s:option(Value, "time", "启用时间")
time_select.placeholder = "HH:MM:SS"  -- 提示用户输入格式
time_select.optional = false  -- 必填项
time_select.rmempty = false   -- 禁止为空
-- 自定义时间格式校验
function time_select.validate(self, value, section)
    if not value or value == "" then
        return nil, "时间不能为空！请输入时间，例如：08:15:00"
    end
    if value:match("^%d%d:%d%d:%d%d$") then
        local h, m, s = value:match("^(%d%d):(%d%d):(%d%d)$")
        h, m, s = tonumber(h), tonumber(m), tonumber(s)
        if h < 24 and m < 60 and s < 60 then
            return value  -- 格式正确，返回原值
        end
    end
    return nil, "时间格式错误！时间格式为 HH:MM:SS (24小时制) 例如：08:15:00"
end

return m
