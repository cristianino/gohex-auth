# GoHex-Auth Repository Instructions for Copilot

## Repository Overview

**What this repository does:** This is a Go REST API template implementing Hexagonal Architecture (Ports & Adapters) with JWT authentication, PostgreSQL database integration, and Redis caching. It's designed as a production-ready microservice template.

**Technical specifications:**
- **Language:** Go 1.23
- **Framework:** Gin HTTP web framework
- **Architecture:** Hexagonal (Ports & Adapters)
- **Database:** PostgreSQL 15+ with migrations
- **Caching:** Redis 7+
- **Containerization:** Docker & Docker Compose
- **Project size:** Small-medium (~50 files, organized in hexagonal architecture)

## Build, Test, and Validation Instructions

### Prerequisites
Always ensure you have Go 1.23+ installed before working with this repository.

### Essential Commands (tested and verified working)

**Install dependencies (always run first):**
```bash
go mod download
go mod verify
```

**Build the project:**
```bash
go build -v ./...
```

**Run all validation tools (in this order):**
```bash
go vet ./...                    # Go static analysis
staticcheck ./...              # Advanced static analysis (requires: go install honnef.co/go/tools/cmd/staticcheck@latest)
golangci-lint run              # Comprehensive linting (see .golangci.yml config)
```

**Run tests (validated working):**
```bash
# Unit tests
go test ./tests/unit/... -v -race -coverprofile=unit.out

# Integration tests  
go test ./tests/integration/... -v -race -coverprofile=integration.out

# E2E tests (will skip in CI environments)
go test ./tests/e2e/... -v -race -coverprofile=e2e.out
```

**Generate coverage report:**
```bash
go install github.com/wadey/gocovmerge@latest
gocovmerge unit.out integration.out e2e.out > coverage.out
```

**Cross-platform builds (for releases):**
```bash
mkdir -p bin/
GOOS=linux GOARCH=amd64 go build -o bin/gohex-auth-linux-amd64 ./cmd/api
GOOS=darwin GOARCH=amd64 go build -o bin/gohex-auth-darwin-amd64 ./cmd/api
GOOS=windows GOARCH=amd64 go build -o bin/gohex-auth-windows-amd64.exe ./cmd/api
```

**Run with Docker (verified working):**
```bash
docker-compose up -d          # Start all services
docker-compose logs -f api    # View logs
docker-compose down           # Stop all services
```

### Important Notes
- **Always run `go mod download && go mod verify` before building**
- E2E tests expect a running server and will skip in CI (expected behavior)
- The Dockerfile uses Go 1.23 - do not change this without updating go.mod
- Build artifacts (bin/, *.out files) are automatically ignored by .gitignore

## Project Architecture and Layout

### Directory Structure
```
cmd/api/main.go                 # Application entry point
internal/                       # Private application code (Go compiler enforced)
  ├── core/                     # Business logic (domain layer)
  ├── adapters/                 # External integrations
  │   ├── input/http/           # HTTP handlers, middleware, routes
  │   └── output/persistence/   # Database implementations
  └── config/                   # Configuration management
pkg/                           # Public packages for external use
tests/                         # Test suites
  ├── unit/                    # Unit tests
  ├── integration/             # Integration tests
  └── e2e/                     # End-to-end tests
docker/                        # Docker configuration files
scripts/                       # Build and deployment scripts
```

### Key Configuration Files
- **go.mod/go.sum:** Go 1.23 with Gin framework dependencies
- **.golangci.yml:** Linting configuration (timeout: 5m, enabled: errcheck, govet, ineffassign, staticcheck, unused)
- **.env.example:** Environment template (copy to .env for local development)
- **docker-compose.yml:** Multi-service setup (API, PostgreSQL, Redis)
- **Dockerfile:** Go 1.23 container build

### GitHub Actions CI/CD Pipeline
Located in `.github/workflows/go.yml` - runs on push/PR to develop/main:

**Test job matrix:** Go 1.21, 1.22, 1.23
**Build job:** Cross-platform builds for Linux, macOS, Windows
**Validation steps:**
1. Dependencies download/verify
2. go vet
3. staticcheck
4. golangci-lint (v1.59.1)
5. Build validation
6. Test execution (unit, integration, e2e)
7. Coverage reporting
8. Artifact generation

### Key Implementation Details
- **Entry point:** `cmd/api/main.go` - minimal Gin setup with /ping endpoint
- **Router setup:** `internal/app/app.go` contains SetupRouter() function
- **Test organization:** Tests are properly isolated in their respective directories
- **Docker setup:** Uses multi-stage build with Go 1.23 base image

### Common Patterns
- Import path: `github.com/cristianino/gohex-auth`
- All tests use testify framework (`github.com/stretchr/testify`)
- HTTP responses use Gin's JSON binding
- Configuration follows 12-factor app principles

### Troubleshooting
If you encounter Go version issues, ensure consistency across:
- go.mod (currently: go 1.23)
- Dockerfile (currently: FROM golang:1.23) 
- GitHub Actions workflow (currently: 1.21, 1.22, 1.23)

Trust these instructions and only search the codebase if information appears incomplete or incorrect.
