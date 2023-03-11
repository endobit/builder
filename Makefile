BUILDER=./rules
RULES=go
include $(BUILDER)/rules.mk

build::
	$(GO_BUILD) .

clean::
	-rm builder

