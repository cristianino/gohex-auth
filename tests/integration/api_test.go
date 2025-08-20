package integration

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/cristianino/gohex-auth/internal/app"
	"github.com/gin-gonic/gin"
)

// TestPingEndpoint verifies the /ping endpoint returns 200 and the expected JSON body.
func TestPingEndpoint(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := app.SetupRouter()

	req, err := http.NewRequest(http.MethodGet, "/ping", nil)
	if err != nil {
		t.Fatalf("failed to create request: %v", err)
	}

	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Fatalf("expected status %d; got %d", http.StatusOK, w.Code)
	}

	var body map[string]string
	if err := json.Unmarshal(w.Body.Bytes(), &body); err != nil {
		t.Fatalf("failed to parse response body: %v", err)
	}

	if body["message"] != "pong" {
		t.Fatalf("expected message 'pong'; got %q", body["message"])
	}
}

// TestNonExistentRoute verifies that non-existent routes return 404.
func TestNonExistentRoute(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := app.SetupRouter()

	req, err := http.NewRequest(http.MethodGet, "/nonexistent", nil)
	if err != nil {
		t.Fatalf("failed to create request: %v", err)
	}

	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	if w.Code != http.StatusNotFound {
		t.Fatalf("expected status %d; got %d", http.StatusNotFound, w.Code)
	}
}

// TestPingEndpointContentType verifies the content type is application/json.
func TestPingEndpointContentType(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := app.SetupRouter()

	req, err := http.NewRequest(http.MethodGet, "/ping", nil)
	if err != nil {
		t.Fatalf("failed to create request: %v", err)
	}

	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	contentType := w.Header().Get("Content-Type")
	if contentType != "application/json; charset=utf-8" {
		t.Fatalf("expected content type 'application/json; charset=utf-8'; got %q", contentType)
	}
}
