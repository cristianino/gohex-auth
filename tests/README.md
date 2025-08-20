# Tests

This directory contains all tests organized according to hexagonal architecture and testing types.

## Structure

```
tests/
├── unit/          # Unit tests - test individual components in isolation
├── integration/   # Integration tests - test component interactions
├── e2e/          # End-to-end tests - test complete application flows
└── README.md     # This file
```

## Test Types

### Unit Tests (`unit/`)
- Test individual functions and methods in isolation
- Use mocks for external dependencies
- Fast execution
- Example: `app_test.go` - tests router creation and configuration

### Integration Tests (`integration/`)
- Test interactions between multiple components
- May use in-memory databases or mocked services
- Example: `api_test.go` - tests HTTP endpoints using httptest

### End-to-End Tests (`e2e/`)
- Test complete application workflows
- May require real external services
- Slower but closer to real usage
- Example: `api_e2e_test.go` - tests with real HTTP server

## Commands

```bash
# Run all tests
go test ./tests/... -v

# Run only unit tests
go test ./tests/unit -v

# Run only integration tests
go test ./tests/integration -v

# Run only e2e tests
go test ./tests/e2e -v

# Run tests with coverage
go test ./tests/... -v -cover
```

## Conventions

- Each test file must end with `_test.go`
- Tests must follow the pattern `TestFunctionName`
- Use `gin.SetMode(gin.TestMode)` in tests with Gin
- Integration tests should use `httptest` to avoid starting real servers
- E2E tests may use real servers but must cleanup properly
