# GoHex Auth

Welcome to the GoHex Auth project wiki! This is a comprehensive guide for developers working on or with the GoHex Auth API.

## 🚀 Quick Links

- **[Quick Start Guide](Quick-Start)** - Get running in 5 minutes
- **[Development Workflow](Development-Workflow)** - Daily development practices  
- **[API Documentation](API-Design)** - REST API reference
- **[Architecture Overview](Hexagonal-Architecture)** - System design principles

## 📋 Project Overview

GoHex Auth is a Go REST API built with hexagonal architecture (ports & adapters pattern) designed for:

- **JWT Authentication** - Secure token-based auth
- **PostgreSQL Integration** - Robust data persistence
- **Redis Caching** - Performance optimization
- **Clean Architecture** - Maintainable and testable code
- **Comprehensive Testing** - Unit, integration, and e2e tests
- **Docker Support** - Containerized deployment

## 🏗️ Current Status

**Branch**: `feature/add-develop-config`  
**Current Implementation**: Basic HTTP server with health endpoint  
**Planned Features**: JWT auth, user management, database integration

### Available Endpoints

- `GET /ping` → `{"message": "pong"}` - Health check

## 🛠️ Development Quick Start

```bash
# Clone and setup
git clone https://github.com/cristianino/gohex-auth.git
cd gohex-auth

# Install dependencies and run checks
make deps
make ci

# Start development
make dev-run  # With live reload
# or
make run      # Standard mode
```

## 📚 Documentation Structure

### For New Developers
1. [Installation Guide](Installation) - Complete setup instructions
2. [Project Structure](Project-Structure) - Codebase organization
3. [Development Workflow](Development-Workflow) - Daily practices

### For Contributors  
1. [Code Style Guide](Code-Style-Guide) - Coding standards
2. [Testing Strategy](Testing-Strategy) - Testing approach
3. [Contributing Guide](Contributing-Guide) - Contribution process

### For Architects
1. [Hexagonal Architecture](Hexagonal-Architecture) - Design patterns
2. [Domain Design](Domain-Design) - Business logic structure
3. [API Design](API-Design) - REST conventions

## 🔧 Essential Commands

| Command | Purpose |
|---------|---------|
| `make help` | Show all available commands |
| `make ci` | Run complete CI pipeline locally |
| `make test` | Run all tests |
| `make lint` | Code quality checks |
| `make dev-run` | Start with live reload |

## 🏛️ Architecture Principles

- **Domain-Driven Design** - Business logic as core
- **Dependency Inversion** - Abstractions over implementations  
- **Clean Testing** - Separated by test type and purpose
- **Configuration Management** - Environment-specific settings
- **Observability** - Logging, metrics, and tracing ready

## 🤝 Getting Help

- **Issues**: Use GitHub Issues for bugs and feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Wiki**: Check relevant wiki pages for detailed guides
- **Code**: Well-commented code with examples

## 🚦 Project Status

- ✅ **Basic Structure** - Hexagonal architecture setup
- ✅ **Development Tools** - Linting, testing, live reload
- ✅ **CI/CD Pipeline** - GitHub Actions workflow
- ✅ **Documentation** - Comprehensive guides
- 🔄 **Authentication** - JWT implementation (planned)
- 🔄 **Database** - PostgreSQL integration (planned)
- 🔄 **Caching** - Redis integration (planned)

---

*Last updated: August 19, 2025*
