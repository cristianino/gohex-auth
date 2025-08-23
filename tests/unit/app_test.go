package unit

import (
	"testing"

	"github.com/cristianino/gohex-auth/internal/app"
	"github.com/gin-gonic/gin"
)

// TestSetupRouter_RouterCreation verifies that SetupRouter returns a valid Gin engine.
func TestSetupRouter_RouterCreation(t *testing.T) {
	gin.SetMode(gin.TestMode)

	router := app.SetupRouter()

	if router == nil {
		t.Fatal("SetupRouter should return a non-nil Gin engine")
	}
}

// TestSetupRouter_Routes verifies that the router has the expected routes configured.
func TestSetupRouter_Routes(t *testing.T) {
	gin.SetMode(gin.TestMode)

	router := app.SetupRouter()

	// Get the routes from the Gin engine
	routes := router.Routes()

	// Should have at least one route (/ping)
	if len(routes) == 0 {
		t.Fatal("Router should have at least one route configured")
	}

	// Check if /ping route exists
	foundPingRoute := false
	for _, route := range routes {
		if route.Path == "/ping" && route.Method == "GET" {
			foundPingRoute = true
			break
		}
	}

	if !foundPingRoute {
		t.Error("Router should have a GET /ping route configured")
	}
}
