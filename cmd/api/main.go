package main

import (
    "log"
    "net/http"
)

func main() {
    // Set up the HTTP server
    http.HandleFunc("/health", healthCheckHandler)

    // Start the server
    log.Println("Starting server on :8080")
    if err := http.ListenAndServe(":8080", nil); err != nil {
        log.Fatalf("Could not start server: %s\n", err)
    }
}

// healthCheckHandler responds with a simple health check message
func healthCheckHandler(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("OK"))
}