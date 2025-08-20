package main

import (
	"github.com/cristianino/gohex-auth/internal/app"
)

func main() {
	router := app.SetupRouter()

	if err := router.Run(); err != nil {
		panic(err)
	}
}
