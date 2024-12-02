sys = require "luci.sys"
local d = require "luci.dispatcher"
uci = require"luci.model.uci".cursor()

function uci_get_type(type, config, default)
	local value = uci:get_first("passwall", type, config, default) or sys.exec("echo -n $(uci -q get " .. "passwall" .. ".@" .. type .."[0]." .. config .. ")")
	if (value == nil or value == "") and (default and default ~= "") then
		value = default
	end
	return value
end

function is_ip(val)
	if is_ipv6(val) then
		val = get_ipv6_only(val)
	end
	return datatypes.ipaddr(val)
end

function is_ipv6(val)
	local str = val
	local address = val:match('%[(.*)%]')
	if address then
		str = address
	end
	if datatypes.ip6addr(str) then
		return true
	end
	return false
end

function is_ipv6addrport(val)
	if is_ipv6(val) then
		local address, port = val:match('%[(.*)%]:([^:]+)$')
		if port then
			return datatypes.port(port)
		end
	end
	return false
end

function get_ipv6_only(val)
	local result = ""
	if is_ipv6(val) then
		result = val
		if val:match('%[(.*)%]') then
			result = val:match('%[(.*)%]')
		end
	end
	return result
end

function get_ipv6_full(val)
	local result = ""
	if is_ipv6(val) then
		result = val
		if not val:match('%[(.*)%]') then
			result = "[" .. result .. "]"
		end
	end
	return result
end

function get_ip_type(val)
	if is_ipv6(val) then
		return "6"
	elseif datatypes.ip4addr(val) then
		return "4"
	end
	return ""
end

function get_valid_nodes()
	local show_node_info = uci_get_type("global_other", "show_node_info") or "0"
	local nodes = {}
	uci:foreach("passwall", "nodes", function(e)
		e.id = e[".name"]
		if e.type and e.remarks then
			if e.protocol and (e.protocol == "_balancing" or e.protocol == "_shunt" or e.protocol == "_iface") then
                e["remark"] = e.type .. " " .. e.protocol .. "：" .. e.remarks
				e["node_type"] = "special"
				nodes[#nodes + 1] = e
			end
			if e.port and e.address then
				local address = e.address
				if is_ip(address) or datatypes.hostname(address) then
					local type = e.type
					if (type == "sing-box" or type == "Xray") and e.protocol then
						local protocol = e.protocol
						if protocol == "vmess" then
							protocol = "VMess"
						elseif protocol == "vless" then
							protocol = "VLESS"
						else
							protocol = protocol:gsub("^%l",string.upper)
						end
						type = type .. " " .. protocol
					end
					if is_ipv6(address) then address = get_ipv6_full(address) end
					e["remark"] = "%s：[%s]" % {type, e.remarks}
					if show_node_info == "1" then
						e["remark"] = "%s：[%s] %s:%s" % {type, e.remarks, address, e.port}
					end
					e.node_type = "normal"
					nodes[#nodes + 1] = e
				end
			end
		end
	end)
	return nodes
end

local nodes_table = {}
for k, e in ipairs(get_valid_nodes()) do
	nodes_table[#nodes_table + 1] = e
end

m = Map("cumt-net", "Passwall代理规则配置")
m.redirect = d.build_url("admin", "services", "cumt-net")

s = m:section(NamedSection, arg[1], "passwall", "")
s.addremove = false
s.dynamic = false

o = s:option(Flag, "enable", translate("Enable"))
o.default = "1"
o.rmempty = false

o = s:option(Value, "remarks", translate("Remarks"))
o.placeholder = "备注"
o.rmempty = true

o = s:option(ListValue, "action", "操作")
o:value("enable", translate("enable"))
o:value("disable", translate("disable"))
o.optional = false  -- 必填项
o.rmempty = false

o = s:option(ListValue, "node", "节点")
o:depends("action", "enable")
-- 动态添加从 nodes_table 中获取的值
for _, node in ipairs(nodes_table) do
    -- 假设每个节点有 id 和 remark 字段
    -- 如果你需要在列表中显示 `remark`，可以将其作为值显示
    o:value(node.id, node.remark or node.id)
end
-- o:value("cumt", "校园网")
-- o:value("unicom", "联通")
-- o:value("cmcc", "移动")
-- o:value("telecom", "电信")
o.optional = false  -- 必填项
o.rmempty = false   -- 禁止为空

o = s:option(ListValue, "mode", "模式")
o:depends("action", "enable")
o:value("global", "全局")
o:value("rule", "规则")
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
