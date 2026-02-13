ifndef __git_mk
__git_mk=1

GIT_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null)
ifdef GIT_ROOT
	GIT_VERSION  := $(shell go run github.com/mdomke/git-semver/v6@latest . || echo none)
	GIT_BRANCH   := $(shell git symbolic-ref -q --short HEAD | tr / _)
	GIT_USERNAME := $(shell git config --get user.name)
	GIT_USERMAIL := $(shell git config --get user.email)
endif

dump::
	@echo "GIT_ROOT     $(GIT_ROOT)"
	@echo "GIT_VERSION  $(GIT_VERSION)"
	@echo "GIT_BRANCH   $(GIT_BRANCH)"
	@echo "GIT_USERNAME $(GIT_USERNAME)"
	@echo "GIT_USERMAIL $(GIT_USERMAIL)"

endif # __git_mk
