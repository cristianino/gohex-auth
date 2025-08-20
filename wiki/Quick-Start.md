# Quick Start Guide

Get the GoHex Auth API running in 5 minutes or less.

## Prerequisites Check

Ensure you have these tools installed:

```bash
# Check Go version (1.23+ required)
go version

# Check Make is available  
make --version

# Optional: Docker for containerized services
docker --version
```

## 5-Minute Setup

### 1. Clone and Navigate
```bash
git clone https://github.com/cristianino/gohex-auth.git
cd gohex-auth
```

### 2. Install Dependencies
```bash
make deps
```
*This downloads Go modules and installs development tools*

### 3. Verify Setup
```bash
make ci
```
*Runs formatting, linting, and all tests - should pass cleanly*

### 4. Start the API
```bash
make run
```
*Starts the server on http://localhost:8080*

### 5. Test the Health Endpoint
```bash
# In another terminal
curl http://localhost:8080/ping
# Expected: {"message":"pong"}
```

🎉 **Success!** Your API is running.

## Development Mode

For active development with live reload:

```bash
make dev-run
```

This will:
- Watch for file changes
- Automatically rebuild and restart
- Show build errors in `build-errors.log`

## Next Steps

### Explore the Codebase
```bash
# View project structure
tree -I 'vendor|node_modules|tmp|bin'

# Key files to examine
ls cmd/api/                    # Entry point
ls internal/app/               # Application setup  
ls tests/                      # Test organization
```

### Run Different Test Types
```bash
make test-unit                 # Fast unit tests
make test-integration          # Component interaction tests  
make test-e2e                  # End-to-end tests
make test-coverage             # Generate coverage reports
```

### Code Quality Checks
```bash
make fmt                       # Format code
make lint                      # Run linters
make vet                       # Static analysis
```

## Common First-Time Issues

### Issue: Tools Not Found
**Problem**: `make lint` fails with "command not found"
**Solution**: 
```bash
# Install tools manually
go install honnef.co/go/tools/cmd/staticcheck@latest
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin latest
```

### Issue: Port Already in Use  
**Problem**: `make run` fails with "port already in use"
**Solution**:
```bash
# Kill process on port 8080
lsof -ti:8080 | xargs kill -9

# Or change port in code
export PORT=8081
make run
```

### Issue: Test Failures
**Problem**: `make test` shows failures
**Solution**:
```bash
# Run tests with verbose output
go test -v ./tests/...

# Check specific test type
make test-unit     # Usually fastest to debug
```

## IDE Setup (Optional)

### VS Code
Install recommended extensions:
- Go (official)
- golangci-lint
- Test Explorer

Add to `.vscode/settings.json`:
```json
{
  "go.lintTool": "golangci-lint",
  "go.formatTool": "gofumpt",
  "go.testFlags": ["-v", "-race"]
}
```

## What You Have Now

- ✅ **HTTP Server** running on port 8080
- ✅ **Health Endpoint** at `/ping`
- ✅ **Development Tools** installed and configured
- ✅ **Test Suite** passing (unit, integration, e2e)
- ✅ **Live Reload** for development
- ✅ **Code Quality** checks working

## What's Next

1. **[Development Workflow](Development-Workflow)** - Learn daily development practices
2. **[Project Structure](Project-Structure)** - Understand the codebase organization
3. **[Testing Strategy](Testing-Strategy)** - Deep dive into testing approaches
4. **[API Design](API-Design)** - Plan your API endpoints

## Getting Help

- Run `make help` for all available commands
- Check [Troubleshooting](Troubleshooting) for common issues  
- Browse the [wiki home page](Home) for complete documentation

---

*Estimated setup time: 3-5 minutes*  
*Prerequisites installation may take additional time*
