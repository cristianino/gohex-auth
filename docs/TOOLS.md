# Tools Configuration

This document describes the configuration and usage of development tools in the gohex-auth project.

## Overview

The project uses several automated tools to maintain code quality, formatting, and provide a smooth development experience.

## Tool Configurations

### golangci-lint

**File**: `.golangci.yml`
**Purpose**: Comprehensive Go linting with multiple rule sets

**Configuration highlights:**
- Version 2 format for latest golangci-lint releases
- Enabled linters: errcheck, govet, ineffassign, staticcheck, unused
- 5-minute timeout for large codebases
- Simplified configuration for compatibility

**Usage:**
```bash
make lint                          # Run all configured linters
$(go env GOPATH)/bin/golangci-lint run   # Direct command
```

### Air (Live Reload)

**File**: `.air.toml`
**Purpose**: Automatic rebuilding and restarting during development

**Configuration highlights:**
- Watches `.go` files for changes
- Excludes test files and vendor directories
- Builds to `./tmp/main` binary
- 500ms delay between rebuilds
- Logs build errors to `build-errors.log`

**Usage:**
```bash
make dev-run                    # Start with live reload
$(go env GOPATH)/bin/air        # Direct command
```

### Build Automation

**File**: `Makefile`
**Purpose**: Standardized build commands and development workflow

**Key targets:**
- `make help` - Show all available commands
- `make ci` - Complete CI pipeline locally
- `make dev` - Development workflow (fmt + vet + lint + test)
- `make test-*` - Various testing commands
- `make build-all` - Cross-platform builds

### GitHub Actions

**File**: `.github/workflows/go.yml`
**Purpose**: Continuous Integration and Deployment

**Pipeline stages:**
1. **Test Matrix**: Go versions 1.23, 1.24, 1.25
2. **Dependencies**: Cache Go modules, download dependencies
3. **Code Quality**: go vet, staticcheck, golangci-lint
4. **Testing**: Unit, integration, and e2e tests with race detection
5. **Coverage**: Generate and upload coverage reports
6. **Build**: Multi-platform binary generation
7. **Artifacts**: Upload built binaries

## Tool Installation

### Automatic Installation

All tools are automatically referenced with full paths in the Makefile:

```bash
# Tools are installed to $(go env GOPATH)/bin and referenced as:
$(shell go env GOPATH)/bin/golangci-lint
$(shell go env GOPATH)/bin/staticcheck
$(shell go env GOPATH)/bin/gofumpt
$(shell go env GOPATH)/bin/air
```

### Manual Installation

If you need to install tools manually:

```bash
# golangci-lint
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin latest

# staticcheck
go install honnef.co/go/tools/cmd/staticcheck@latest

# gofumpt (enhanced formatter)
go install mvdan.cc/gofumpt@latest

# air (live reload)
go install github.com/air-verse/air@latest
```

## IDE Integration

### VS Code

Recommended extensions:
- Go (official)
- golangci-lint
- Test Explorer

Settings for `.vscode/settings.json`:
```json
{
  "go.lintTool": "golangci-lint",
  "go.lintFlags": [
    "--fast"
  ],
  "go.formatTool": "gofumpt",
  "go.testFlags": ["-v", "-race"],
  "go.testTimeout": "60s"
}
```

### Other IDEs

Most Go-aware IDEs can be configured to use:
- `golangci-lint` as the linter
- `gofumpt` as the formatter
- Standard Go test runner with `-race` flag

## Troubleshooting

### Common Issues

**golangci-lint version conflicts:**
- The project uses version 2 configuration format
- If you get version errors, update golangci-lint:
  ```bash
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin latest
  ```

**Air not finding binary:**
- Ensure `$(go env GOPATH)/bin` is in your PATH
- Or use `make dev-run` which uses full path

**Build failures with live reload:**
- Check `build-errors.log` in project root
- Verify `.air.toml` paths are correct
- Run `make clean` to remove stale build artifacts

**Test timeouts:**
- Integration tests use httptest (fast)
- E2E tests may skip if they can't connect to real servers
- Use `make test-unit` for fastest feedback

### Performance Tips

**Faster linting:**
```bash
# Lint only changed files
golangci-lint run --new-from-rev=main

# Skip cache for fresh run
golangci-lint run --no-config
```

**Faster testing:**
```bash
# Run tests in parallel
go test -parallel 4 ./tests/...

# Skip long-running tests
go test -short ./tests/...
```

**Faster builds:**
```bash
# Use build cache
export GOCACHE=$(go env GOCACHE)

# Parallel builds
make -j4 build-all
```

## Configuration Updates

When updating tool configurations:

1. **Update configuration files** (`.golangci.yml`, `.air.toml`, etc.)
2. **Test locally** with `make ci`
3. **Update documentation** in this file and DEVELOPMENT.md
4. **Commit changes** and verify CI passes

## Integration with CI/CD

All tools are integrated into the GitHub Actions workflow:
- Caching is configured for Go modules
- Tools run in dependency order
- Failures stop the pipeline
- Artifacts are preserved for successful builds

The workflow matches the local `make ci` command for consistency.
