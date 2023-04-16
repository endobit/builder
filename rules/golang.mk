ifndef __golang_mk
__gloang_mk=1

include $(BUILDER)/git.mk

GO_LDFLAGS = -ldflags "-X main.version=$(GIT_VERSION)"
GO_BUILD = go build $(GO_LDFLAGS)

$(GOPATH)/bin:
	mkdir -p $@

$(GOPATH)/bin/golangci-lint: $(GOPATH)/bin
	curl -sSfL \
		https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | \
		sh -s -- -b $(GOPATH)/bin v1.52.2

lint:: go-lint go-vulncheck
test:: go-test

.PHONY: go-build go-format go-lint go-test go-vulncheck


go-format: ## format all go code
	go run golang.org/x/tools/cmd/goimports@latest -w .

go-lint: $(GOPATH)/bin/golangci-lint
	@echo "$(c.INF)$@$(c.RST)"
	@$(GOPATH)/bin/golangci-lint version
	@[ -e .golangci.yaml ] && $(GOPATH)/bin/golangci-lint run || true
	@[ ! -e .golangci.yaml ] && $(GOPATH)/bin/golangci-lint run --config=$(BUILDER)/golangci.yaml

go-test:
	@echo "$(c.INF)$@$(c.RST)"
	go test -v -coverprofile=coverage.out ./...

go-vulncheck: 
	@echo "$(c.INF)$@$(c.RST)"
	go run golang.org/x/vuln/cmd/govulncheck@latest ./...

dump::
	@echo "GO_LDFLAGS   $(GO_LDFLAGS)"
	@echo "GO_BUILD     $(GO_BUILD)"

endif # __golang_mk
