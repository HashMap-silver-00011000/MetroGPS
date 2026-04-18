package models

import "github.com/google/uuid"

type Ruta struct{
	ID 		uuid.UUID 	`db:"id_ruta" 	json:"id_ruta"`
	codigo 	string		`db:"codigo" 	json:"codigo"`
	nombre 	string		`db:"nombre" 	json:"nombre"`
	activa 	bool		`db:"activa" 	json:"activa"`
}