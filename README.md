# Go REST API with Hexagonal Architecture

A clean and scalable REST API built with Go, following Hexagonal Architecture principles (Ports & Adapters). This project includes JWT authentication with bearer tokens, PostgreSQL database integration, and Redis caching.

## 🏗️ Architecture Overview

This project implements **Hexagonal Architecture** (also known as Ports & Adapters), which provides:

- **Clear separation of concerns**: Business logic isolated from external dependencies
- **Testability**: Easy to unit test core business logic
- **Flexibility**: Easy to swap implementations (databases, web frameworks, etc.)
- **Maintainability**: Well-organized code structure

## 📁 Project Structure

```
project/
├── cmd/                          # Application entry points
│   └── api/
│       └── main.go              # Main application bootstrap
├── internal/                    # Private application code
│   ├── core/                    # Business logic layer (Domain)
│   │   ├── domain/              # Core business entities and logic
│   │   │   ├── entities/        # Domain entities (User, Auth, etc.)
│   │   │   ├── repositories/    # Repository interfaces
│   │   │   └── services/        # Business logic services
│   │   └── ports/               # Interfaces for inbound/outbound communication
│   │       ├── input/           # Inbound ports (use cases)
│   │       └── output/          # Outbound ports (repositories, external services)
│   ├── adapters/                # External layer implementations
│   │   ├── input/               # Inbound adapters
│   │   │   └── http/            # HTTP REST API implementation
│   │   │       ├── handlers/    # HTTP request handlers
│   │   │       ├── middleware/  # HTTP middleware (auth, CORS, etc.)
│   │   │       ├── routes/      # Route definitions
│   │   │       └── dto/         # Data Transfer Objects
│   │   └── output/              # Outbound adapters
│   │       ├── persistence/     # Database implementations
│   │       │   ├── postgres/    # PostgreSQL implementations
│   │       │   └── migrations/  # Database migration files
│   │       └── external/        # External service clients
│   └── config/                  # Configuration management
├── pkg/                         # Public packages (can be imported by external projects)
│   ├── utils/                   # Utility functions
│   └── errors/                  # Custom error types
├── docs/                        # Documentation
├── tests/                       # Test suites
│   ├── unit/                    # Unit tests
│   ├── integration/             # Integration tests
│   └── e2e/                     # End-to-end tests
├── docker/                      # Docker configuration
│   ├── Dockerfile              # Application container
│   └── docker-compose.yml      # Multi-service setup
└── scripts/                     # Build and deployment scripts
```

### 🎯 Directory Purpose

- **`cmd/`**: Contains the main applications for this project. The directory name matches the application executable name.
- **`internal/`**: Private application and library code. This is enforced by the Go compiler.
- **`internal/core/`**: The heart of your application containing business logic, independent of external concerns.
- **`internal/adapters/`**: Implementations that adapt external concerns (HTTP, databases) to your core business logic.
- **`pkg/`**: Library code that's ok to use by external applications.
- **`tests/`**: Additional external test apps and test data.

## 🚀 Getting Started

### Prerequisites

- **Go 1.21+**
- **Docker & Docker Compose** (for containerized setup)
- **PostgreSQL 15+** (if running locally)
- **Redis 7+** (if running locally)

### 🔧 Environment Setup

1. **Clone the repository**:
```bash
git clone <repository-url>
cd <project-name>
```

2. **Copy environment file**:
```bash
cp .env.example .env
```

3. **Configure your `.env` file**:
```env
# Application
APP_NAME=hexagonal-api
APP_ENV=development
APP_PORT=8080
APP_DEBUG=true

# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=hexagonal_db
DB_SSL_MODE=disable

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0

# JWT
JWT_SECRET=your-super-secret-key-here
JWT_EXPIRY_HOURS=24

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
```

### 🐳 Running with Docker Compose (Recommended)

This is the easiest way to get started with all dependencies:

```bash
# Start all services (API, PostgreSQL, Redis)
docker-compose up -d

# View logs
docker-compose logs -f api

# Stop all services
docker-compose down

# Rebuild and start (after code changes)
docker-compose up --build -d
```

**Services will be available at:**
- **API**: http://localhost:8080
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

### 🔨 Running with Go (Development)

1. **Install dependencies**:
```bash
go mod tidy
```

2. **Start PostgreSQL and Redis** (using Docker):
```bash
# Start only databases
docker-compose up -d postgres redis
```

3. **Run database migrations**:
```bash
go run cmd/api/main.go migrate
```

4. **Start the application**:
```bash
# Development mode with hot reload (install air first)
go install github.com/cosmtrek/air@latest
air

# Or run directly
go run cmd/api/main.go serve
```

### 📊 Database Management

**Run migrations**:
```bash
# Using Go
go run cmd/api/main.go migrate

# Using Docker
docker-compose exec api go run cmd/api/main.go migrate
```

**Reset database**:
```bash
# Using Docker Compose
docker-compose down -v
docker-compose up -d
```

## 🔑 API Authentication

This API uses **JWT Bearer Token** authentication:

1. **Register/Login** to get a JWT token
2. **Include the token** in subsequent requests:
```bash
Authorization: Bearer <your-jwt-token>
```

### Example API Calls

**Register a new user**:
```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "name": "John Doe"
  }'
```

**Login**:
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

**Access protected endpoint**:
```bash
curl -X GET http://localhost:8080/api/v1/users/profile \
  -H "Authorization: Bearer <your-jwt-token>"
```

## 🧪 Testing

**Run all tests**:
```bash
go test ./...
```

**Run tests with coverage**:
```bash
go test -v -cover ./...
```

**Run specific test suite**:
```bash
# Unit tests only
go test ./tests/unit/...

# Integration tests only
go test ./tests/integration/...
```

## 🛠️ Development Tools

**Recommended tools for development**:

- **Air** - Hot reload for Go applications
  ```bash
  go install github.com/cosmtrek/air@latest
  ```

- **golang-migrate** - Database migration tool
  ```bash
  go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
  ```

## 📝 API Documentation

Once the application is running, you can access:

- **Health Check**: http://localhost:8080/health
- **API Documentation**: http://localhost:8080/docs (if Swagger is implemented)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Technologies Used

- **[Gin](https://github.com/gin-gonic/gin)** - HTTP web framework
- **[PostgreSQL](https://www.postgresql.org/)** - Primary database
- **[Redis](https://redis.io/)** - Caching and sessions
- **[JWT](https://github.com/golang-jwt/jwt)** - Authentication tokens
- **[Docker](https://www.docker.com/)** - Containerization
- **[Air](https://github.com/cosmtrek/air)** - Hot reload for development
