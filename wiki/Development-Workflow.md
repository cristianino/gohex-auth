# Development Workflow

This guide covers the daily development workflow and best practices for the GoHex Auth project.

## Daily Development Cycle

### 1. Start Your Development Session

```bash
# Pull latest changes
git pull origin develop

# Ensure dependencies are up to date
make deps

# Run a quick health check
make ci
```

### 2. Feature Development

```bash
# Create a feature branch
git checkout -b feature/your-feature-name

# Start development with live reload
make dev-run
```

The live reload will:
- Watch for `.go` file changes
- Automatically rebuild and restart the server
- Log build errors to `build-errors.log`
- Exclude test files from triggering rebuilds

### 3. Development Loop

While developing, use these commands in separate terminals:

```bash
# Terminal 1: Live reload server
make dev-run

# Terminal 2: Quick testing during development
make test-unit              # Fast unit tests
make test-integration       # Integration tests
curl localhost:8080/ping    # Manual API testing
```

### 4. Code Quality Checks

Before committing, ensure code quality:

```bash
# Format code automatically
make fmt

# Check for issues
make lint
make vet

# Run complete test suite
make test

# Or run everything at once
make ci
```

### 5. Commit and Push

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: add user authentication endpoint

- Implement JWT token generation
- Add user login validation
- Include integration tests
- Update API documentation"

# Push to your branch
git push origin feature/your-feature-name
```

## Code Quality Standards

### Formatting
- Use `gofumpt` (enhanced `gofmt`)
- Run `make fmt` before committing
- Configure your IDE to format on save

### Linting
- `golangci-lint` with configured rules
- `staticcheck` for advanced analysis
- `go vet` for standard checks
- All must pass before merge

### Testing Requirements
- Write tests for all new features
- Maintain or improve coverage
- Follow the testing strategy:
  - **Unit tests**: Test individual components
  - **Integration tests**: Test component interactions  
  - **E2E tests**: Test complete user workflows

## Branching Strategy

### Branch Types

```
main                    # Production-ready code
├── develop            # Integration branch
    ├── feature/auth   # Feature development
    ├── feature/users  # Another feature
    ├── bugfix/login   # Bug fixes
    └── hotfix/security # Critical fixes
```

### Branch Naming
- `feature/short-description` - New features
- `bugfix/short-description` - Bug fixes  
- `hotfix/short-description` - Critical fixes
- `refactor/short-description` - Code refactoring
- `docs/short-description` - Documentation updates

### Merge Process
1. Create feature branch from `develop`
2. Develop and test locally
3. Push branch and create Pull Request
4. Code review and CI checks
5. Merge to `develop` after approval
6. Delete feature branch

## Testing During Development

### Test-Driven Development (TDD)
```bash
# 1. Write failing test
make test-unit              # Should fail

# 2. Write minimal implementation  
make test-unit              # Should pass

# 3. Refactor and improve
make test-unit              # Should still pass
```

### Test Organization
```bash
tests/
├── unit/          # Fast, isolated tests
├── integration/   # Component interaction tests
└── e2e/          # End-to-end workflow tests
```

### Running Tests Efficiently
```bash
# Development: Fast feedback
make test-unit

# Before commit: Comprehensive
make test

# Coverage analysis
make test-coverage
open coverage-*.html
```

## Debugging

### Live Reload Issues
```bash
# Check build errors
cat build-errors.log

# Restart live reload
make clean
make dev-run
```

### Test Debugging
```bash
# Verbose test output
go test -v ./tests/unit

# Run specific test
go test -v -run TestSpecificFunction ./tests/unit

# Race condition detection  
go test -race ./tests/...
```

### Build Issues
```bash
# Clean artifacts
make clean

# Fresh dependency download
go mod download
go mod verify

# Rebuild
make build
```

## Performance Optimization

### Development Speed
```bash
# Use test caching
go test -count=1 ./tests/...  # Force no cache
go test ./tests/...           # Use cache

# Parallel testing
go test -parallel 4 ./tests/...

# Build with race detector only when needed
go test -race ./tests/unit    # Only for critical tests
```

### Build Optimization
```bash
# Development: Fast builds
go build -o bin/app ./cmd/api

# Production: Optimized builds  
go build -ldflags="-w -s" -o bin/app ./cmd/api
```

## Environment Management

### Development Environment
```bash
# Default development settings
export GIN_MODE=debug
export LOG_LEVEL=debug

# Start with environment
make run
```

### Configuration Files
- `.env` - Local development settings
- `.env.test` - Test environment settings
- `config/` - Application configuration

### Docker Development
```bash
# Run with Docker Compose
docker-compose up -d

# Follow logs  
docker-compose logs -f api

# Clean restart
docker-compose down
docker-compose up -d --build
```

## Code Review Guidelines

### Before Requesting Review
- [ ] `make ci` passes locally
- [ ] All tests pass
- [ ] Code is properly formatted
- [ ] Commit messages are descriptive
- [ ] Documentation is updated

### Self-Review Checklist
- [ ] Code follows project conventions
- [ ] No hardcoded values or secrets
- [ ] Error handling is comprehensive
- [ ] Tests cover edge cases
- [ ] Performance impact considered

### Reviewer Guidelines
- Review for logic, not style (automated tools handle style)
- Suggest improvements, don't just criticize
- Approve when requirements are met
- Request changes for significant issues

## Troubleshooting Common Issues

### "Command not found" errors
```bash
# Add Go bin to PATH
export PATH=$PATH:$(go env GOPATH)/bin

# Or use full paths
$(go env GOPATH)/bin/golangci-lint run
```

### Port conflicts
```bash
# Kill process on port 8080
lsof -ti:8080 | xargs kill -9

# Use different port
PORT=8081 make run
```

### Module issues
```bash
# Reset modules
go mod tidy
go mod download
go mod verify
```

---

*This workflow ensures consistent, high-quality development across the team.*
