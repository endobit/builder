ifndef __rules_mk
__rules_mk=1

.DEFAULT_GOAL = help

.PHONY: build clean dump format generate lint nuke test
build::    ## build everything
clean::    ## remove build artifacts
dump::     ## rules debug info
format::   ## run code formatters
generate:: ## generate source code
lint::     ## run linters
nuke::     ## remove all build artifacts
test::     ## run tests

nuke:: clean

ifdef TERM
include $(BUILDER)/color.mk
endif

ifneq ($(filter go,$(RULES)),)
include $(BUILDER)/golang.mk
endif

ifneq ($(filter swift,$(RULES)),)
include $(BUILDER)/swift.mk
endif

ifneq ($(filter gatsby,$(RULES)),)
include $(BUILDER)/gatsby.mk
endif


.PHONY: build-init
builder-init: ## (re)initialize build environment
	go run endobit.io/builder@latest init

help: ## print help
	@egrep -oh '^[A-Za-z_\-]+:+ +\#\#.*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN { FS = ":+ +\#\#"} { printf "$(c.INF)%-16s$(c.RST) %s\n", $$1, $$2 }'

-include $(BUILDER)/organization.mk

COPYRIGHT = "\(c\) $(shell date +%Y) $(ORGANIZATION)"

dump::
	@echo "COPYRIGHT    $(COPYRIGHT)"


endif # __rules_mk
