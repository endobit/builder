# Builder - Copilot Instructions

## Project Overview

Builder is a Go CLI tool that installs and manages Makefile-based build systems for development projects. It embeds a collection of reusable make rules for Go, Swift, and Gatsby projects, and distributes them into target repositories via `builder init`.

### Key Architecture Concepts

- **Embedded rules**: All `.mk` files in `rules/` are embedded into the binary using `//go:embed rules`
- **Init command**: Copies embedded rules to `.builder/` directory in target projects and creates a minimal `Makefile`
- **Makefile composition**: Projects set `RULES=go` (or `swift`, `gatsby`) to include language-specific targets
- **Version injection**: Git version is injected into the binary via `-ldflags "-X main.version=$(GIT_VERSION)"` during build

## Build, Test, and Lint

This project uses its own Makefile system (dogfooding).

```bash
# Build the binary
make build
# Output: ./builder

# Run tests (full suite)
make test

# Run a single test (use standard go test)
go test -v -run TestFunctionName ./...

# Format code
make format

# Lint code
make lint
# Note: Runs golangci-lint with config from .golangci.yaml and govulncheck

# Clean build artifacts
make clean

# Remove all artifacts (includes clean)
make nuke
```

## Key Conventions

### Makefile Rule System

- **Include guards**: All `.mk` files use include guards (e.g., `ifndef __golang_mk`)
- **Double-colon targets**: Build targets use `::` to allow extension (e.g., `build::` in `Makefile` extends base `build::` from `rules.mk`)
- **Phony targets**: All build targets are `.PHONY` to prevent conflicts with files
- **Color support**: Terminal colors via `color.mk` are included only if `TERM` is set

### Rule Files Organization

- `rules.mk` - Main entry point that orchestrates all rules
- `golang.mk` - Go-specific targets (depends on `git.mk` for version info)
- `swift.mk`, `gatsby.mk` - Language-specific rules
- `git.mk` - Provides `GIT_VERSION` variable for build stamping
- `organization.mk` - Generated file containing `ORGANIZATION` variable

### Go Code Conventions

- Version is stored in a package-level `var version string` and set via ldflags or `debug.ReadBuildInfo()`
- Cobra is used for CLI structure; commands are created via `newXCmd()` factory functions
- Embedded FS operations use `fs.Sub()` to isolate the embedded subdirectory before walking files

### golangci-lint Configuration

The `.golangci.yaml` enables ~60 linters including:
- Security: `gosec`
- Performance: `prealloc`, `perfsprint`
- Style: `gocritic`, `revive`, `wsl_v5`
- Correctness: `errorlint`, `nilnesserr`, `rowserrcheck`

Notable exclusions: comments presets (redundant with enabled linters), `redefines-builtin-id` (covered by gocritic)

## Testing the Init Command

To test the init command locally without rebuilding:

```bash
# Test in a temporary directory
cd /tmp/test-project
go run /Users/mjk/src/endobit/builder init
```

Or build first and test:

```bash
make build
cd /tmp/test-project
/Users/mjk/src/endobit/builder/builder init
```
