#
# Copyright (C) 2007-2016 OpenWrt.org
# Copyright (C) 2010 Vertical Communications
# Copyright (C) 2016 prpl Foundation
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=boardfarm-coop-prep
PKG_RELEASE:=1


PKG_LICENSE:=GPL-2.0


include $(INCLUDE_DIR)/package.mk

define Package/boardfarm-coop-prep
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Preparation For Boardfarm Coop of DB-120
  VERSION:=$(PKG_RELEASE)
endef

define Package/boardfarm-coop-prep/conffiles
/etc/config/network
endef

define Package/boardfarm-coop-prep/description
 This package contains preparation for the boardfarm coop
endef

define Build/Compile/Default

endef
Build/Compile = $(Build/Compile/Default)

define Package/boardfarm-coop-prep/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/network $(1)/etc/config/
endef

define Package/boardfarm-coop-prep/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || reload_config || true
endef


$(eval $(call BuildPackage,boardfarm-coop-prep))
