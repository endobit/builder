ifndef __copyright_mk
__copyright_mk=1

COPYRIGHT = "\(c\) $(shell date +%Y) $(COPYRIGHT)"

dump::
	@echo "COPYRIGHT    $(COPYRIGHT)"

endif # __copyright_mk
