module("luci.controller.cumt-login", package.seeall) 
function index()
	if not nixio.fs.access("/etc/config/cumt-login") then
		return
	end

	entry({"admin", "services", "cumt-login"}, cbi("cumt-login/login"),_("cumt-login"))
	entry({"admin", "services", "cumt-login", "config"}, cbi("cumt-login/config")).leaf = true
	entry({"admin", "services", "cumt-login", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep -f cumtnet >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
