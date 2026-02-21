ifndef __golang_mk
__golang_mk=1

include $(BUILDER)/git.mk

ifdef GOEXPERIMENT
	GO_VARS      += GOEXPERIMENT=$(GOEXPERIMENT)
	GO_LINT_VARS += GOEXPERIMENT=$(GOEXPERIMENT)
endif
ifdef CGO_ENABLED
	GO_VARS += CGO_ENABLED=$(CGO_ENABLED)
endif

GO           = $(strip $(GO_VARS) go)
GO_LINT      = $(strip $(GO_LINT_VARS) golangci-lint)
ifeq ("$(wildcard .golangci.yaml)","")
	GO_LINT_ARGS = --config=$(BUILDER)/golangci.yaml
endif
GO_FMT       = $(GO) run golang.org/x/tools/cmd/goimports@latest
GO_VULNCHECK = $(GO) run golang.org/x/vuln/cmd/govulncheck@latest

ifneq (,$(GIT_VERSION))
	GO_LDFLAGS = -ldflags "-X main.version=$(GIT_VERSION)"
endif

GO_BUILD = $(GO) build $(GO_LDFLAGS)

.PHONY: go-build go-format go-fix go-lint go-test go-vulncheck go-generate

fix:: go-fix
format:: go-format
generate:: go-generate
lint:: go-lint go-vulncheck
test:: go-test

go-build:
	@echo "$(c.INF)$@$(c.RST)"
	@$(GO_BUILD) .

go-fix: ## run go fix
	@echo "$(c.INF)$@$(c.RST)"
	@$(GO) fix ./...

go-format:
	@echo "$(c.INF)$@$(c.RST)"
	@$(GO_FMT) -w .

go-lint:
	@echo "$(c.INF)$@$(c.RST)"
	@$(GO_LINT) version
	@$(GO_LINT) run $(GO_LINT_ARGS)

go-test:
	@echo "$(c.INF)$@$(c.RST)"
	@go test -v -coverprofile=coverage.out ./...

go-vulncheck: 
	@echo "$(c.INF)$@$(c.RST)"
	@$(GO_VULNCHECK) ./...

go-generate:
	@echo "$(c.INF)$@$(c.RST)"
	@go generate ./...

dump::
	@echo "GO           $(GO)"
	@echo "GO_BUILD     $(GO_BUILD)"
	@echo "GO_FMT       $(GO_FMT)"
	@echo "GO_LDFLAGS   $(GO_LDFLAGS)"
	@echo "GO_LINT      $(GO_LINT)"

endif # __golang_mk
