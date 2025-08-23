# Go REST API with Hexagonal Architecture

This repository contains the scaffolding for a Go REST API organized using Hexagonal Architecture (Ports & Adapters). The project is prepared to support JWT authentication, PostgreSQL, Redis, and migrations, but the current `cmd/api/main.go` in this branch is a minimal implementation that starts an HTTP server with Gin and exposes a simple health endpoint.

## Quick Start

```bash
# Install dependencies and tools
make deps

# Run development checks
make ci

# Start the application
make run

# Or start with live reload
make dev-run
```

## Current State

- The application entrypoint is `cmd/api/main.go`.
- At the moment the server exposes only a health endpoint:
  - GET /ping -> { "message": "pong" }
- Features referenced elsewhere in the repository (migrations, JWT, protected endpoints, Swagger docs, etc.) are not wired up by the `main.go` in this branch and should be implemented or connected before relying on them.

## Project Structure

```
project/
├── cmd/                          # Application entry points
│   └── api/
│       └── main.go               # Main application bootstrap
├── internal/                      # Private application code
│   ├── app/                       # Application setup and configuration
│   ├── core/                      # Business logic layer (Domain)
│   │   ├── domain/                # Core business entities and logic
│   │   │   ├── entities/          # Domain entities (User, Auth, etc.)
│   │   │   ├── repositories/      # Repository interfaces
│   │   │   └── services/          # Business logic services
│   │   └── ports/                 # Interfaces for inbound/outbound communication
│   │       ├── input/             # Inbound ports (use cases)
│   │       └── output/            # Outbound ports (repositories, external services)
│   ├── adapters/                  # External implementations
│   │   ├── input/                 # Inbound adapters
│   │   │   └── http/              # HTTP REST API implementation
│   │   │       ├── handlers/
│   │   │       ├── middleware/
│   │   │       ├── routes/
│   │   │       └── dto/
│   │   └── output/                # Outbound adapters
│   │       ├── persistence/       # Database implementations
│   │       │   ├── postgres/
│   │       │   └── migrations/
│   │       └── external/          # External service clients
│   └── config/                    # Configuration management
├── pkg/                           # Public packages (reusable)
│   ├── utils/
│   └── errors/
├── tests/                         # Test suites organized by type
│   ├── unit/                      # Unit tests
│   ├── integration/               # Integration tests
│   ├── e2e/                       # End-to-end tests
│   └── README.md                  # Testing documentation
├── .github/workflows/             # CI/CD pipelines
├── Dockerfile
├── Dockerfile.dev
├── docker-compose.yml
├── Makefile                       # Build automation
├── DEVELOPMENT.md                 # Development guide
└── README.md
```

## Documentation

- **[Development Guide](DEVELOPMENT.md)** - Comprehensive development setup and workflow
- **[GitHub Wiki](https://github.com/cristianino/gohex-auth/wiki)** - Detailed project documentation and architecture guides
- **[Tools Configuration](docs/TOOLS.md)** - Development tools setup and configuration
- **[Testing Guide](tests/README.md)** - Testing strategy and organization

### Wiki Setup

To set up the GitHub Wiki with comprehensive documentation:

```bash
./scripts/setup-wiki.sh
```

## Requirements

- Go 1.23+ (installed and in PATH)
- Make (build automation)
- Docker & Docker Compose (optional — only required if you want to run Postgres/Redis via containers)

## Development

For detailed development instructions, see [DEVELOPMENT.md](DEVELOPMENT.md) or browse our comprehensive [GitHub Wiki](../../wiki).

### Documentation
- **[GitHub Wiki](../../wiki)** - Comprehensive documentation and guides
- **[Quick Start Guide](../../wiki/Quick-Start)** - Get running in 5 minutes
- **[Development Workflow](../../wiki/Development-Workflow)** - Daily development practices
- **[Architecture Guide](../../wiki/Hexagonal-Architecture)** - System design and patterns

### Quick Development Commands

```bash
# Show all available commands
make help

# Install dependencies and run quality checks
make ci

# Run the application
make run

# Run with live reload for development
make dev-run

# Run tests
make test                # All tests
make test-unit          # Unit tests only
make test-integration   # Integration tests only

# Code quality
make fmt               # Format code
make lint              # Run linter
make vet               # Static analysis
```

## API Endpoints

### Health Check

```bash
curl http://localhost:8080/ping
# Response: {"message":"pong"}
```

## Docker Usage

### Development with Live Reload

```bash
# Start development environment with live reload
make docker-dev

# Or build and start (if you made changes to Dockerfile.dev)
make docker-dev-build

# View logs
make docker-logs

# Stop services
make docker-stop
```

### Production Build

```bash
make docker-build
make docker-run
```

### Docker Compose Services

```bash
# Start all services (API, PostgreSQL, Redis)
docker-compose up

# Start only development API with live reload
docker-compose up api-dev

# Start in background
docker-compose up -d api-dev
```

## Testing

The project includes comprehensive testing at multiple levels:

- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test component interactions using httptest
- **End-to-End Tests**: Test complete workflows (may be skipped in CI environments)

```bash
# Run all tests
make test

# Run with coverage reports
make test-coverage

# Run specific test types
make test-unit
make test-integration
make test-e2e
```

See [tests/README.md](tests/README.md) for detailed testing documentation.

## Continuous Integration

The project uses GitHub Actions for CI/CD:
- Runs on push/PR to `develop` and `main` branches  
- Tests against multiple Go versions (1.23, 1.24, 1.25)
- Performs code quality checks (vet, staticcheck, golangci-lint)
- Generates coverage reports
- Builds binaries for multiple platforms

## Next Steps

- When integrating database migrations, JWT authentication, or other features, update `cmd/api/main.go` and this README with the new commands
- Keep this README synchronized with changes to the main entrypoint so it accurately reflects what the service runs
- The project is configured for easy extension with additional features and maintains clean architecture boundaries

## Contributing

1. Read the [Development Guide](DEVELOPMENT.md)
2. Follow the established project structure
3. Write tests for new features
4. Run `make ci` before committing
5. Ensure all CI checks pass
