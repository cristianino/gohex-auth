## Makefile for gohex-auth project

.PHONY: help build test test-unit test-integration test-e2e test-coverage clean lint fmt vet deps dev run

# Default target
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Build targets
build: ## Build the application
	@echo "Building application..."
	@go build -o bin/gohex-auth ./cmd/api

build-all: ## Build for multiple platforms
	@echo "Building for multiple platforms..."
	@mkdir -p bin
	@GOOS=linux GOARCH=amd64 go build -o bin/gohex-auth-linux-amd64 ./cmd/api
	@GOOS=darwin GOARCH=amd64 go build -o bin/gohex-auth-darwin-amd64 ./cmd/api
	@GOOS=windows GOARCH=amd64 go build -o bin/gohex-auth-windows-amd64.exe ./cmd/api
	@echo "Binaries built in bin/ directory"

# Test targets
test: ## Run all tests
	@echo "Running all tests..."
	@go test ./tests/... -v -race

test-unit: ## Run unit tests
	@echo "Running unit tests..."
	@go test ./tests/unit -v -race

test-integration: ## Run integration tests
	@echo "Running integration tests..."
	@go test ./tests/integration -v -race

test-e2e: ## Run end-to-end tests
	@echo "Running e2e tests..."
	@go test ./tests/e2e -v -race

test-coverage: ## Run tests with coverage
	@echo "Running tests with coverage..."
	@go test ./tests/unit -v -race -coverprofile=unit.out
	@go test ./tests/integration -v -race -coverprofile=integration.out
	@go test ./tests/e2e -v -race -coverprofile=e2e.out
	@go tool cover -html=unit.out -o coverage-unit.html
	@go tool cover -html=integration.out -o coverage-integration.html
	@go tool cover -html=e2e.out -o coverage-e2e.html
	@echo "Coverage reports generated: coverage-*.html"

# Code quality targets
lint: ## Run golangci-lint
	@echo "Running golangci-lint..."
	@golangci-lint run

fmt: ## Format code
	@echo "Formatting code..."
	@go fmt ./...
	@gofumpt -w .

vet: ## Run go vet
	@echo "Running go vet..."
	@go vet ./...

staticcheck: ## Run staticcheck
	@echo "Running staticcheck..."
	@staticcheck ./...

# Development targets
deps: ## Download dependencies
	@echo "Downloading dependencies..."
	@go mod download
	@go mod verify

tidy: ## Tidy dependencies
	@echo "Tidying dependencies..."
	@go mod tidy

dev: deps fmt vet lint test ## Run development workflow

run: ## Run the application
	@echo "Starting application..."
	@go run ./cmd/api

dev-run: ## Run with live reload (requires air)
	@echo "Starting application with live reload..."
	@air

# Docker targets
docker-build: ## Build Docker image
	@echo "Building Docker image..."
	@docker build -t gohex-auth .

docker-run: ## Run Docker container
	@echo "Running Docker container..."
	@docker run -p 8080:8080 gohex-auth

# Cleanup targets
clean: ## Clean build artifacts
	@echo "Cleaning up..."
	@rm -rf bin/
	@rm -f *.out
	@rm -f coverage-*.html

# CI targets
ci: deps fmt vet lint test build ## Run CI pipeline locally
