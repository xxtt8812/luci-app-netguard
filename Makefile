include $(TOPDIR)/rules.mk

PKG_NAME:=netguard
PKG_VERSION:=2025.02
PKG_RELEASE:=1
PKG_MAINTAINER:=OpenWrt_Dev

include $(INCLUDE_DIR)/package.mk

define Package/netguard
    SECTION:=net
    CATEGORY:=Network
    TITLE:=下一代智能流量守卫
    DEPENDS:=+nftables +luci-compat +libubox
    PKGARCH:=all
endef

define Package/netguard/install
    # 部署核心文件
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
    $(INSTALL_DATA) ./files/netguard.lua $(1)/usr/lib/lua/luci/controller/
    
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/netguard
    $(INSTALL_DATA) ./files/cbi/*.lua $(1)/usr/lib/lua/luci/model/cbi/netguard/
    
    $(INSTALL_DIR) $(1)/etc/init.d
    $(INSTALL_BIN) ./files/netguard.init $(1)/etc/init.d/netguard
    
    $(INSTALL_DIR) $(1)/etc/config
    $(INSTALL_CONF) ./files/netguard.config $(1)/etc/config/netguard
    
    $(INSTALL_DIR) $(1)/usr/share/netguard
    $(INSTALL_BIN) ./src/time_parser.sh $(1)/usr/share/netguard/
endef

$(eval $(call BuildPackage,netguard))
