local uci = luci.model.uci.cursor()
local m = Map("netguard", translate("流量规则管理"), 
    translate("支持域名/IP/MAC三维度精准控制"))

-- 规则列表展示表格
local s = m:section(TypedSection, "rule", translate("生效规则列表"))
s.template = "cbi/tblsection"
s.addremove = true
s.sortable = true
s.anonymous = false

-- 目标类型选择器
o = s:option(ListValue, "target", translate("目标类型"))
o:value("domain", translate("域名匹配（支持通配符）"))
o:value("ip", translate("IP地址（CIDR格式）"))
o:value("mac", translate("MAC地址"))
o.rmempty = false

-- 模式输入验证
o = s:option(Value, "pattern", translate("匹配模式"))
o.datatype = function(self, value)
    local target = self.section:get("target")
    if target == "ip" then
        return "cidr4"
    elseif target == "mac" then
        return "macaddr"
    else
        return "maxlength(253)"
    end
end

-- 动作选择器（允许/阻断）
o = s:option(ListValue, "action", translate("执行动作"))
o:value("allow", translate("允许流量"))
o:value("block", translate("阻断流量"))
o.default = "block"

-- 时间组动态加载
local time_groups = {}
uci:foreach("netguard", "time_group", function(s)
    time_groups[s[".name"]] = s[".name"].." ("..table.concat(s.time_range, ", ")..")"
end)

o = s:option(ListValue, "schedule", translate("生效时间"))
o:value("always", translate("全天生效"))
for k,v in pairs(time_groups) do
    o:value(k, translate("时间组：")..v)
end

-- 备注字段
o = s:option(Value, "comment", translate("规则描述"))
o.placeholder = "输入业务描述，如'禁止社交媒体'"

-- 表单提交自动处理
m.on_after_commit = function(self)
    luci.sys.call("/etc/init.d/netguard reload >/dev/null 2>&1")
end

return m
