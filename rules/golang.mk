ifndef __golang_mk
__golang_mk=1

include $(BUILDER)/git.mk

GO           = go
GO_LINT      = golangci-lint
GO_FMT       = go run golang.org/x/tools/cmd/goimports@latest
GO_VULNCHECK = go run golang.org/x/vuln/cmd/govulncheck@latest

ifneq (,$(GIT_VERSION))
	GO_LDFLAGS = -ldflags "-X main.version=$(GIT_VERSION)"
endif

GO_BUILD = $(GO) build $(GO_LDFLAGS)

format:: go-format
lint:: go-lint go-vulncheck
test:: go-test
generate:: go-generate

.PHONY: go-build go-format go-lint go-test go-vulncheck go-generate

go-format:
	@echo "$(c.INF)$@$(c.RST)"
	@$(GO_FMT) -w .

go-lint:
	@echo "$(c.INF)$@$(c.RST)"
	@$(GO_LINT) version
ifneq ("$(wildcard .golangci.yaml)","")
	@$(GO_LINT) run
else
	@$(GO_LINT) run --config=$(BUILDER)/golangci.yaml
endif

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
