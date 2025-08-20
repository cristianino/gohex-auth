# Hexagonal Architecture Implementation

This guide explains how hexagonal architecture (also known as Ports & Adapters) is implemented in the GoHex Auth project.

## Architecture Overview

Hexagonal architecture organizes code around the business domain, with external concerns (database, HTTP, etc.) as adapters that connect through well-defined ports.

```
┌─────────────────────────────────────────┐
│              External World             │
├─────────────┬─────────────┬─────────────┤
│   HTTP      │  Database   │   Redis     │
│  Adapter    │   Adapter   │  Adapter    │
├─────────────┴─────────────┴─────────────┤
│              Ports Layer                │
├─────────────────────────────────────────┤
│            Domain / Core                │
│         (Business Logic)                │
└─────────────────────────────────────────┘
```

## Project Structure Mapping

### Core Domain (`internal/core/`)
The heart of the application - business logic independent of external concerns.

```
internal/core/
├── domain/
│   ├── entities/       # Business entities (User, Auth, etc.)
│   ├── repositories/   # Repository interfaces
│   └── services/       # Business logic services
└── ports/
    ├── input/         # Inbound ports (use cases)
    └── output/        # Outbound ports (repository interfaces)
```

**Key Principles:**
- No dependencies on external frameworks
- Pure business logic
- Interfaces define contracts with external world

### Adapters (`internal/adapters/`)
Implementations that connect the core domain to external systems.

```
internal/adapters/
├── input/              # Inbound adapters
│   └── http/          # HTTP REST API
│       ├── handlers/  # HTTP request handlers
│       ├── routes/    # Route definitions
│       ├── dto/       # Data transfer objects
│       └── middleware/ # HTTP middleware
└── output/            # Outbound adapters  
    ├── persistence/   # Database implementations
    │   ├── postgres/  # PostgreSQL adapter
    │   └── migrations/ # Database migrations
    └── external/      # External service clients
```

**Key Principles:**
- Implement port interfaces from core
- Handle external system specifics
- Convert between external and domain formats

## Implementation Details

### 1. Domain Entities

**File**: `internal/core/domain/entities/user.go`
```go
package entities

import "time"

// User represents a user in the system
type User struct {
    ID        int64     `json:"id"`
    Username  string    `json:"username"`
    Email     string    `json:"email"`
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}

// NewUser creates a new user with validation
func NewUser(username, email string) (*User, error) {
    if username == "" {
        return nil, errors.New("username cannot be empty")
    }
    if email == "" {
        return nil, errors.New("email cannot be empty")
    }
    
    return &User{
        Username:  username,
        Email:     email,
        CreatedAt: time.Now(),
        UpdatedAt: time.Now(),
    }, nil
}
```

### 2. Repository Interfaces (Output Ports)

**File**: `internal/core/ports/output/user_repository.go`
```go
package output

import (
    "context"
    "github.com/cristianino/gohex-auth/internal/core/domain/entities"
)

// UserRepository defines the contract for user data persistence
type UserRepository interface {
    Create(ctx context.Context, user *entities.User) error
    GetByID(ctx context.Context, id int64) (*entities.User, error)
    GetByUsername(ctx context.Context, username string) (*entities.User, error)
    Update(ctx context.Context, user *entities.User) error
    Delete(ctx context.Context, id int64) error
}
```

### 3. Use Cases (Input Ports)

**File**: `internal/core/ports/input/user_service.go`
```go
package input

import (
    "context"
    "github.com/cristianino/gohex-auth/internal/core/domain/entities"
)

// UserService defines the contract for user business operations
type UserService interface {
    CreateUser(ctx context.Context, username, email string) (*entities.User, error)
    GetUser(ctx context.Context, id int64) (*entities.User, error)
    UpdateUser(ctx context.Context, user *entities.User) error
    DeleteUser(ctx context.Context, id int64) error
}
```

### 4. Business Logic Services

**File**: `internal/core/domain/services/user_service.go`
```go
package services

import (
    "context"
    "github.com/cristianino/gohex-auth/internal/core/domain/entities"
    "github.com/cristianino/gohex-auth/internal/core/ports/output"
)

type userService struct {
    userRepo output.UserRepository
}

// NewUserService creates a new user service
func NewUserService(userRepo output.UserRepository) *userService {
    return &userService{
        userRepo: userRepo,
    }
}

func (s *userService) CreateUser(ctx context.Context, username, email string) (*entities.User, error) {
    // Business validation
    user, err := entities.NewUser(username, email)
    if err != nil {
        return nil, err
    }
    
    // Check if user already exists
    existing, _ := s.userRepo.GetByUsername(ctx, username)
    if existing != nil {
        return nil, errors.New("user already exists")
    }
    
    // Save user
    if err := s.userRepo.Create(ctx, user); err != nil {
        return nil, err
    }
    
    return user, nil
}
```

### 5. HTTP Adapter (Inbound)

**File**: `internal/adapters/input/http/handlers/user_handler.go`
```go
package handlers

import (
    "net/http"
    "strconv"
    
    "github.com/gin-gonic/gin"
    "github.com/cristianino/gohex-auth/internal/core/ports/input"
    "github.com/cristianino/gohex-auth/internal/adapters/input/http/dto"
)

type UserHandler struct {
    userService input.UserService
}

func NewUserHandler(userService input.UserService) *UserHandler {
    return &UserHandler{
        userService: userService,
    }
}

func (h *UserHandler) CreateUser(c *gin.Context) {
    var req dto.CreateUserRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    
    user, err := h.userService.CreateUser(c, req.Username, req.Email)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    
    response := dto.UserResponse{
        ID:       user.ID,
        Username: user.Username,
        Email:    user.Email,
    }
    
    c.JSON(http.StatusCreated, response)
}
```

### 6. Database Adapter (Outbound)

**File**: `internal/adapters/output/persistence/postgres/user_repository.go`
```go
package postgres

import (
    "context"
    "database/sql"
    
    "github.com/cristianino/gohex-auth/internal/core/domain/entities"
)

type userRepository struct {
    db *sql.DB
}

func NewUserRepository(db *sql.DB) *userRepository {
    return &userRepository{db: db}
}

func (r *userRepository) Create(ctx context.Context, user *entities.User) error {
    query := `
        INSERT INTO users (username, email, created_at, updated_at)
        VALUES ($1, $2, $3, $4)
        RETURNING id`
    
    return r.db.QueryRowContext(
        ctx, 
        query, 
        user.Username, 
        user.Email, 
        user.CreatedAt, 
        user.UpdatedAt,
    ).Scan(&user.ID)
}

func (r *userRepository) GetByID(ctx context.Context, id int64) (*entities.User, error) {
    user := &entities.User{}
    query := `
        SELECT id, username, email, created_at, updated_at 
        FROM users 
        WHERE id = $1`
    
    err := r.db.QueryRowContext(ctx, query, id).Scan(
        &user.ID,
        &user.Username,
        &user.Email,
        &user.CreatedAt,
        &user.UpdatedAt,
    )
    
    if err != nil {
        return nil, err
    }
    
    return user, nil
}
```

## Dependency Injection

### Application Setup

**File**: `internal/app/app.go`
```go
package app

import (
    "database/sql"
    
    "github.com/gin-gonic/gin"
    "github.com/cristianino/gohex-auth/internal/core/domain/services"
    "github.com/cristianino/gohex-auth/internal/adapters/input/http/handlers"
    "github.com/cristianino/gohex-auth/internal/adapters/output/persistence/postgres"
)

func SetupRouter(db *sql.DB) *gin.Engine {
    // Initialize repositories (adapters)
    userRepo := postgres.NewUserRepository(db)
    
    // Initialize services (business logic)
    userService := services.NewUserService(userRepo)
    
    // Initialize handlers (adapters)
    userHandler := handlers.NewUserHandler(userService)
    
    // Setup routes
    router := gin.Default()
    api := router.Group("/api/v1")
    {
        api.POST("/users", userHandler.CreateUser)
        api.GET("/users/:id", userHandler.GetUser)
    }
    
    return router
}
```

## Benefits of This Architecture

### 1. Testability
```go
// Easy to mock dependencies for testing
type mockUserRepository struct{}

func (m *mockUserRepository) Create(ctx context.Context, user *entities.User) error {
    // Mock implementation
    return nil
}

func TestUserService_CreateUser(t *testing.T) {
    mockRepo := &mockUserRepository{}
    service := services.NewUserService(mockRepo)
    
    user, err := service.CreateUser(context.Background(), "test", "test@example.com")
    assert.NoError(t, err)
    assert.NotNil(t, user)
}
```

### 2. Flexibility
- Swap database implementations (PostgreSQL → MongoDB)
- Change HTTP frameworks (Gin → Echo)
- Add new adapters (gRPC, GraphQL)
- Business logic remains unchanged

### 3. Independence
- Business logic has no external dependencies
- External changes don't affect core domain
- Can develop business logic before choosing implementations

## Common Patterns

### 1. Error Handling
```go
// Domain errors
type DomainError struct {
    Code    string
    Message string
}

func (e *DomainError) Error() string {
    return e.Message
}

// Convert domain errors to HTTP responses
func handleDomainError(err error, c *gin.Context) {
    if domainErr, ok := err.(*DomainError); ok {
        switch domainErr.Code {
        case "USER_NOT_FOUND":
            c.JSON(http.StatusNotFound, gin.H{"error": domainErr.Message})
        case "VALIDATION_ERROR":
            c.JSON(http.StatusBadRequest, gin.H{"error": domainErr.Message})
        default:
            c.JSON(http.StatusInternalServerError, gin.H{"error": domainErr.Message})
        }
        return
    }
    
    c.JSON(http.StatusInternalServerError, gin.H{"error": "internal server error"})
}
```

### 2. Data Transfer Objects (DTOs)
```go
// HTTP layer DTOs
type CreateUserRequest struct {
    Username string `json:"username" binding:"required"`
    Email    string `json:"email" binding:"required,email"`
}

type UserResponse struct {
    ID       int64  `json:"id"`
    Username string `json:"username"`
    Email    string `json:"email"`
}

// Convert between DTOs and domain entities
func (r *CreateUserRequest) ToDomain() (*entities.User, error) {
    return entities.NewUser(r.Username, r.Email)
}

func FromDomain(user *entities.User) *UserResponse {
    return &UserResponse{
        ID:       user.ID,
        Username: user.Username,
        Email:    user.Email,
    }
}
```

### 3. Repository Patterns
```go
// Generic repository interface
type Repository[T any] interface {
    Create(ctx context.Context, entity *T) error
    GetByID(ctx context.Context, id int64) (*T, error)
    Update(ctx context.Context, entity *T) error
    Delete(ctx context.Context, id int64) error
}

// Specific repository with domain methods
type UserRepository interface {
    Repository[entities.User]
    GetByUsername(ctx context.Context, username string) (*entities.User, error)
    GetByEmail(ctx context.Context, email string) (*entities.User, error)
}
```

## Testing Strategy

### 1. Unit Tests (Domain Layer)
Test business logic in isolation:
```go
func TestUser_NewUser(t *testing.T) {
    user, err := entities.NewUser("testuser", "test@example.com")
    
    assert.NoError(t, err)
    assert.Equal(t, "testuser", user.Username)
    assert.Equal(t, "test@example.com", user.Email)
}
```

### 2. Integration Tests (Adapters)
Test adapter implementations:
```go
func TestPostgresUserRepository_Create(t *testing.T) {
    db := setupTestDB(t)
    repo := postgres.NewUserRepository(db)
    
    user, _ := entities.NewUser("testuser", "test@example.com")
    err := repo.Create(context.Background(), user)
    
    assert.NoError(t, err)
    assert.NotZero(t, user.ID)
}
```

### 3. End-to-End Tests
Test complete workflows:
```go
func TestAPI_CreateUser(t *testing.T) {
    router := setupTestRouter(t)
    
    body := `{"username":"testuser","email":"test@example.com"}`
    req := httptest.NewRequest(http.MethodPost, "/api/v1/users", strings.NewReader(body))
    w := httptest.NewRecorder()
    
    router.ServeHTTP(w, req)
    
    assert.Equal(t, http.StatusCreated, w.Code)
}
```

---

*This architecture ensures maintainable, testable, and flexible code that can evolve with changing requirements.*
