module("luci.controller.cumt-net", package.seeall) 
function index()
	if not nixio.fs.access("/etc/config/cumt-net") then
		return
	end

	entry({"admin", "services", "cumt-net"}, cbi("cumt-net/net"),_("cumt-net"))
	entry({"admin", "services", "cumt-net", "login-config"}, cbi("cumt-net/login-config")).leaf = true
	entry({"admin", "services", "cumt-net", "passwall-config"}, cbi("cumt-net/passwall-config")).leaf = true
	entry({"admin", "services", "cumt-net", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep -f cumtnet >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
