package main

import (
	"log"

	"backend/config"
	"backend/internal/database"
)

func main(){
	
	cfg := config.LoadConfig()

	conexionDB, err := database.ConectarDB(cfg)
	if err != nil {
		log.Fatalf("Error fatal: No se pudo conectar a PostgreSQL: %v", err)
	}
	defer conexionDB.Close() // Asegura que la base de datos se cierre al apagar el servidor


}