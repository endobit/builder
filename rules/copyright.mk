ifndef __copyright_mk
__copyright_mk=1

-include $(BUILDER)/organization.mk

COPYRIGHT = "\(c\) $(shell date +%Y) $(ORGANIZATION)"

dump::
	@echo "COPYRIGHT    $(COPYRIGHT)"

endif # __copyright_mk
