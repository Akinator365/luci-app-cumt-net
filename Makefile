# Copyright (C) 2016 Openwrt.org
# Copyright (C) 2020-2021 sirpdboy <herboy2008@gmail.com>
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for cumt-net
#LUCI_DEPENDS:=+cumtnet
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-cumt-net
PKG_VERSION:=1.0
PKG_RELEASE:=20241121

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

