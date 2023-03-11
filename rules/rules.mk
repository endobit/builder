ifndef __rules_mk
__rules_mk=1

.DEFAULT_GOAL = help

.PHONY: generate build lint test clean nuke dump
generate:: ## generate source code
build:: ## build everything
lint:: ## run linters
test:: ## run tests
clean:: ## remove build artifacts
nuke:: ## remove all build artifacts
dump:: ## rules debug info

ifneq ($(TERM),)
include $(BUILDER)/color.mk
endif

ifneq ($(filter go,$(RULES)),)
include $(BUILDER)/golang.mk
endif

help: ## print help
	@egrep -oh '^[A-Za-z_\-]+:+ \#\#.*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN { FS = ":+ \#\#"} { printf "$(c.INF)%-16s$(c.RST) %s\n", $$1, $$2 }'

-include $(BUILDER)/organization.mk
COPYRIGHT     = "\(c\) $(shell date +%Y) $(ORGANIZATION)"

dump::
	@echo "COPYRIGHT    $(COPYRIGHT)"


endif # __rules_mk
