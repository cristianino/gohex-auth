package app

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// SetupRouter initializes a Gin engine, configures all routes, and returns the engine for use in the application.
func SetupRouter() *gin.Engine {
	router := gin.Default()

	router.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})

	return router
}
