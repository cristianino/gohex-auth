package main

import (
	"log"

	"github.com/cristianino/gohex-auth/internal/app"
)

func main() {
	router := app.SetupRouter()

	if err := router.Run(); err != nil {
		log.Fatalf("failed to start server: %v", err)
	}
}
