ifndef __pkg_mk
__pkg_mk=1

include $(BUILDER)/git.mk

PKG_DIR      := .package
PKG_ROOT     := $(GIT_ROOT)
PKG_VERSION  := $(GIT_VERSION)
PKG_ARCH     := $(ARCH)
PKG_OS       := $(OS_NAME)
PKG_BASENAME := $(notdir $(PKG_ROOT))
PKG_NAME     ?= $(PKG_BASENAME)_$(PKG_OS)_$(PKG_ARCH)_$(PKG_VERSION).tgz

$(PKG_DIR):
	[[ -d $(PKG_DIR) ]] || mkdir -p $(PKG_DIR)

# To use the package target define a rule for $(PKG_NAME) that copies files into
# the $(PKG_DIR) directory. For example:
#
#   $(PKG_NAME):
#	    cp app $(PKG_DIR)/

package:: ## bundle into a tarball
package:: build $(PKG_DIR) $(PKG_NAME) 
	@(cd $(PKG_DIR) ; tar czf ../$(PKG_NAME) .)
	@echo "$(c.INF)Created package$(c.RST) $(PKG_NAME):"
	@tar -tzf $(PKG_NAME)

clean::
	rm -f  $(PKG_NAME)
	rm -rf $(PKG_DIR)

dump::
	@echo "PKG_DIR      $(PKG_DIR)"
	@echo "PKG_ROOT     $(PKG_ROOT)"
	@echo "PKG_OS       $(PKG_OS)"
	@echo "PKG_NAME     $(PKG_NAME)"

endif # __pkg_mk
