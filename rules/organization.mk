ifndef __organization_mk
__organization_mk=1

ORGANIZATION ?= endobit
COPYRIGHT     = "\(c\) $(shell date +%Y) $(ORGANIZATION)"

dump::
	@echo "COPYRIGHT    $(COPYRIGHT)"

endif # __organization_mk
