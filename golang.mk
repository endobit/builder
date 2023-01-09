ifndef __golang_mk
__gloang_mk=1

include $(RULESDIR)/git.mk
GO_LDFLAGS = -ldflags "-X main.version=$(GIT_VERSION)"

$(GOPATH)/bin:
	mkdir -p $@

$(GOPATH)/bin/golangci-lint: $(GOPATH)/bin
	curl -sSfL \
		https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | \
		sh -s -- -b $(GOPATH)/bin v1.48.0

lint:: go-lint go-vulncheck
test:: go-test

.PHONY: go-build go-format go-lint go-test go-vulncheck

go-build: ## builds all go code
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build $(GO_LDFLAGS) ./...

go-format: ## format all go code
	go run golang.org/x/tools/cmd/goimports@latest -w .

go-lint: $(GOPATH)/bin/golangci-lint
	@echo "$(c.INF)$@$(c.RST)"
	@$(GOPATH)/bin/golangci-lint version 
	@$(GOPATH)/bin/golangci-lint run

go-test:
	@echo "$(c.INF)$@$(c.RST)"
	go test -v -coverprofile=coverage.out ./...

go-vulncheck: 
	@echo "$(c.INF)$@$(c.RST)"
	go run golang.org/x/vuln/cmd/govulncheck@latest ./...

dump::
	@echo "GO_LDFLAGS   $(GO_LDFLAGS)"

endif # __golang_mk
