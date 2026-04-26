package routes

import (
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"

	"backend/internal/repository"
	"backend/internal/service"
	"backend/internal/handlers"
	"backend/internal/server/middleware"

)

func ConfigurarRutas(db *sqlx.DB) *gin.Engine {

	r := gin.Default()

	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"POST", "GET", "OPTIONS", "PUT", "DELETE"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: false,
		MaxAge:           12 * time.Hour,
	}))

	r.Use(middleware.AuditoriaMiddleware())
	
	// INYECCIÓN DE DEPENDENCIAS 
	usuarioRepo := repository.NewUsuarioRepository(db)
	authService := service.NewUsuarioService(usuarioRepo)
	authHandler := handlers.NewAuthHandler(authService)

	// MAPEO DE RUTAS
	api := r.Group("/api")
	{
		api.POST("/login", authHandler.Login)
		api.POST("/register", authHandler.Registro)
	}

	return r
}