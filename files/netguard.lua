module("luci.controller.netguard", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/netguard") then
        return
    end

    entry({"admin", "network", "netguard"}, firstchild(), _("流量守卫"), 50).dependent = false
    
    entry({"admin", "network", "netguard", "global"},
        cbi("netguard/global", {autoapply=true}),
        _("基础配置"), 10)
        
    entry({"admin", "network", "netguard", "rules"},
        arcombine(cbi("netguard/rules"), cbi("netguard/rule-detail")),
        _("规则管理"), 20)
        
    entry({"admin", "network", "netguard", "log"},
        template("netguard/log_view"),
        _("日志监控"), 30)
end
