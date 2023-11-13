package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		c.String(200, "Hello, world")
	})

	r.GET("/hello/:name", func(c *gin.Context) {
		name := c.Param("name")
		c.String(200, fmt.Sprintf("Hello,%s", name))
	})

	r.Run(":9090")
}
