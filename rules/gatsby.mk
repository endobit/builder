ifndef __gatsby_mk
__gatsby_mk=1

.PHONY: gatsby-build gatsby-serve

gatsby-build:
	@echo "$(c.INF)$@$(c.RST)"
	@gatsby build

gatsby-serve: ## dynamically serve the site
	@echo "$(c.INF)$@$(c.RST)"
	@gatsby develop

build:: gatsby-build

endif # __gatsby_mk
