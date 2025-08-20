# Go REST API with Hexagonal Architecture

This repository contains the scaffolding for a Go REST API organized using Hexagonal Architecture (Ports & Adapters). The project is prepared to support JWT authentication, PostgreSQL, Redis, and migrations, but the current `cmd/api/main.go` in this branch is a minimal implementation that starts an HTTP server with Gin and exposes a simple health endpoint.

Quick summary of the current state

- The application entrypoint is `cmd/api/main.go`.
- At the moment the server exposes only a health endpoint:
  - GET /ping -> { "message": "pong" }
- Features referenced elsewhere in the repository (migrations, JWT, protected endpoints, Swagger docs, etc.) are not wired up by the `main.go` in this branch and should be implemented or connected before relying on them.

Project structure

```
project/
├── cmd/                          # Application entry points
│   └── api/
│       └── main.go               # Main application bootstrap
├── internal/                      # Private application code
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
├── tests/                         # Test suites (unit, integration, e2e)
├── Dockerfile
├── Dockerfile.dev
├── docker-compose.yml
└── README.md
```

Requirements

- Go 1.21+ (installed and in PATH)
- Docker & Docker Compose (optional — only required if you want to run Postgres/Redis via containers)

Run locally (development)

1. Install module dependencies:

```bash
go mod tidy
```

2. Run the application:

```bash
go run cmd/api/main.go
```

Gin will listen on `:8080` by default, so the health endpoint will be available at:

- http://localhost:8080/ping

Example:

```bash
curl http://localhost:8080/ping
# response: { "message": "pong" }
```

Run with Docker Compose (optional)

If you want to run any services defined in `docker-compose.yml` (for example Postgres or Redis), use:

```bash
# Start services in the background
docker-compose up -d

# Follow API logs
docker-compose logs -f api

# Stop and remove containers
docker-compose down
```

Testing

Run all tests with:

```bash
go test ./...
```

Run tests with coverage:

```bash
go test -v -cover ./...
```

Notes and next steps

- When integrating database migrations, JWT authentication, or other features, update `cmd/api/main.go` and this README with the new commands (for example `migrate`, `serve`, etc.).
- Keep this README synchronized with changes to the main entrypoint so it accurately reflects what the service runs.
- For local development with automatic reloads you can use `air` (install with `go install github.com/cosmtrek/air@latest`) and run `air` from the project root if you add an `air` configuration.

If you want, I can expand the README with details about the migration tool, environment variables, Dockerfile usage, or the expected API surface once those features are implemented.
