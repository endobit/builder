BUILDER=./rules
RULES=go
include $(BUILDER)/rules.mk

build:: go-build

clean::
	-rm builder

