package middleware

import (
	"log"
	"time"
	"github.com/gin-gonic/gin"
)

func AuditoriaMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// tomamos el tiempo inicial
		tiempoInicio := time.Now()
		ruta := c.Request.URL.Path
		metodo := c.Request.Method
		ipCliente := c.ClientIP()

		c.Next()

		// Después de procesar la petición
		tiempoTomado := time.Since(tiempoInicio)
		codigoEstado := c.Writer.Status()

		// Consola del servidor
		log.Printf("[AUDITORÍA] %s | %d | %s %s | IP: %s | Tiempo: %v", 
			time.Now().Format("2006-01-02 15:04:05"),
			codigoEstado,
			metodo,
			ruta,
			ipCliente,
			tiempoTomado,
		)
	}
}