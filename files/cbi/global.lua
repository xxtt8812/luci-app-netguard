-- 智能模式选择器
local m = Map("netguard", translate("流量守卫全局配置"), 
    translate("全网流量智能管控中枢，支持时间/协议/内容多维度控制"))

-- 主开关配置段
local s = m:section(NamedSection, "policy", "global", translate("核心策略"))
s.addremove = false

-- 启用开关
o = s:option(Flag, "enable", translate("启用服务"))
o.default = 0
o.rmempty = false

-- 模式选择器（智能/黑名单/白名单）
o = s:option(ListValue, "mode", translate("过滤模式"))
o:value("smart", translate("智能模式（自动学习流量特征）"))
o:value("blacklist", translate("黑名单模式（仅禁止列表生效）"))
o:value("whitelist", translate("白名单模式（仅允许列表生效）"))
o.default = "smart"

-- 日志等级选择
o = s:option(ListValue, "log_level", translate("日志详细度"))
o:value("0", translate("无日志"))
o:value("1", translate("基础日志（阻断记录）"))
o:value("2", translate("详细日志（全量记录）"))
o.default = "1"

-- 时间段动态配置
o = s:option(DynamicList, "active_time", translate("生效时间段"),
    translate("格式：HH:MM-HH:MM，例：09:00-18:00"))
o.datatype = "time_range"
o.placeholder = "00:00-23:59"

return m
