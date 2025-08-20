package app

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// SetupRouter creates and returns the Gin engine with all routes configured.
func SetupRouter() *gin.Engine {
	router := gin.Default()

	router.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})

	return router
}
