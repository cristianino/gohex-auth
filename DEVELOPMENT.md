# Development Guide

This guide covers the development workflow, tools, and commands available for the gohex-auth project.

## Prerequisites

Before you begin, ensure you have the following tools installed:

- **Go 1.23+** - The Go programming language
- **Make** - Build automation tool
- **Docker** (optional) - For containerized development

## Quick Start

1. Clone the repository and navigate to the project directory
2. Install dependencies and tools:
   ```bash
   make deps
   ```
3. Run the development pipeline to ensure everything works:
   ```bash
   make ci
   ```
4. Start the application:
   ```bash
   make run
   ```

## Development Tools

### Automatic Tool Installation

The project uses several development tools that are automatically managed:
- **golangci-lint** - Comprehensive Go linter
- **staticcheck** - Static analysis tool
- **gofumpt** - Enhanced Go formatter
- **air** - Live reload tool for development

All tools are installed in `$(go env GOPATH)/bin` and referenced automatically in the Makefile.

## Available Commands

Use `make help` to see all available commands:

### Build Commands

```bash
# Build the application for current platform
make build

# Build for multiple platforms (Linux, macOS, Windows)
make build-all
```

### Testing Commands

```bash
# Run all tests
make test

# Run specific test types
make test-unit         # Unit tests only
make test-integration  # Integration tests only
make test-e2e         # End-to-end tests only

# Generate coverage reports
make test-coverage
```

### Code Quality Commands

```bash
# Format code using go fmt + gofumpt
make fmt

# Run go vet (static analysis)
make vet

# Run staticcheck (advanced static analysis)
make staticcheck

# Run golangci-lint (comprehensive linting)
make lint
```

### Development Workflow Commands

```bash
# Complete development workflow (deps + fmt + vet + lint + test + build)
make dev

# Run CI pipeline locally
make ci

# Download and verify dependencies
make deps

# Clean up build artifacts
make tidy
```

### Runtime Commands

```bash
# Run the application
make run

# Run with live reload (watches for file changes)
make dev-run
```

### Docker Commands

```bash
# Build images
make docker-build         # Production image  
make docker-build-dev      # Development image with Air

# Run containers
make docker-run           # Production container
make docker-dev           # Development with live reload
make docker-dev-build     # Build and run development

# Docker Compose operations  
make docker-logs          # View development logs
make docker-stop          # Stop all services
```

### Docker Live Reload Development

The development Docker setup includes Air for live reload:

- **Configuration**: `.air.docker.toml` - Optimized for Docker containers
- **Features**: Automatic rebuilds, file watching, Docker-specific settings
- **Port**: Application runs on `localhost:8080`
- **Volume mapping**: Code changes are automatically detected

**Usage:**
```bash
# Start with live reload
make docker-dev

# Make code changes - they'll be automatically rebuilt!
# View logs in real-time
make docker-logs
```

### Cleanup Commands

```bash
# Remove build artifacts and coverage reports
make clean
```

## Development Workflow

### Daily Development

1. **Start your development session:**
   ```bash
   make dev-run  # Starts with live reload
   ```

2. **Before committing changes:**
   ```bash
   make ci       # Run complete CI pipeline locally
   ```

3. **Quick testing during development:**
   ```bash
   make test-unit        # Fast unit tests
   make test-integration # Integration tests
   ```

### Code Quality Checks

The project enforces code quality through several tools:

- **gofumpt**: Enhanced Go formatting
- **go vet**: Built-in Go static analysis
- **staticcheck**: Advanced static analysis
- **golangci-lint**: Comprehensive linting with multiple rules

### Testing Strategy

Tests are organized into three categories:

- **Unit Tests** (`tests/unit/`): Test individual components in isolation
- **Integration Tests** (`tests/integration/`): Test component interactions using httptest
- **End-to-End Tests** (`tests/e2e/`): Test complete workflows (may be skipped in CI)

### Live Reload Development

Use `make dev-run` to start the application with live reload. The configuration in `.air.toml` will:
- Watch for changes in `.go` files
- Exclude test files and vendor directories
- Automatically rebuild and restart the application
- Log build errors to `build-errors.log`

## Continuous Integration

The GitHub Actions workflow (`.github/workflows/go.yml`) runs on:
- Push to `develop` or `main` branches
- Pull requests to `develop` or `main` branches

### CI Pipeline Stages

1. **Test Matrix**: Tests against Go versions 1.23, 1.24, and 1.25
2. **Dependencies**: Downloads and caches Go modules
3. **Code Quality**: Runs `go vet`, `staticcheck`, and `golangci-lint`
4. **Testing**: Runs all test suites with race detection
5. **Coverage**: Generates and uploads coverage reports to Codecov
6. **Build**: Creates binaries for multiple platforms

## Configuration Files

- **`.golangci.yml`**: Linter configuration
- **`.air.toml`**: Live reload configuration
- **`Makefile`**: Build automation commands
- **`.gitignore`**: Git ignore patterns
- **`.github/workflows/go.yml`**: CI/CD pipeline

## Troubleshooting

### Common Issues

**Build failures:**
```bash
make clean
make deps
make build
```

**Linting errors:**
```bash
make fmt      # Auto-fix formatting
make lint     # Check remaining issues
```

**Test failures:**
```bash
make test-unit  # Run fastest tests first
```

**Live reload not working:**
- Check that `air` is installed: `which $(go env GOPATH)/bin/air`
- Verify `.air.toml` configuration
- Check `build-errors.log` for build issues

### Getting Help

- Run `make help` for available commands
- Check build logs in `build-errors.log` when using live reload
- Review test output for specific failure details
- Ensure all prerequisites are installed and up to date
