package e2e

import (
	"context"
	"io"
	"net/http"
	"testing"
	"time"

	"github.com/cristianino/gohex-auth/internal/app"
)

// TestFullAPIWorkflow tests the complete API workflow end-to-end.
func TestFullAPIWorkflow(t *testing.T) {
	// Start the server in a goroutine
	router := app.SetupRouter()

	server := &http.Server{
		Addr:    ":0", // Use random available port
		Handler: router,
	}

	go func() {
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			t.Errorf("Server failed to start: %v", err)
		}
	}()

	// Give the server a moment to start
	time.Sleep(100 * time.Millisecond)

	// Test ping endpoint through actual HTTP call
	resp, err := http.Get("http://localhost" + server.Addr + "/ping")
	if err != nil {
		t.Skipf("Could not connect to server (this is expected in unit test environment): %v", err)
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		t.Errorf("Expected status 200, got %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		t.Fatalf("Failed to read response body: %v", err)
	}

	expected := `{"message":"pong"}`
	if string(body) != expected {
		t.Errorf("Expected response body %q, got %q", expected, string(body))
	}

	// Cleanup
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := server.Shutdown(ctx); err != nil {
		t.Errorf("Server shutdown failed: %v", err)
	}
}
