# SPDX-License-Identifier: GPL-3.0-only
#
# This is free software, licensed under the GPL-3.0-only License.
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for cumt-net
#LUCI_DEPENDS:=+cumtnet
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-cumt-net
PKG_VERSION:=1.1
PKG_RELEASE:=20241201

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

