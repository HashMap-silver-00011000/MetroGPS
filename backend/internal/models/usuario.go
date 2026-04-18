package models

import "github.com/google/uuid"

type Usuario struct {
	ID 			uuid.UUID  		`db:"id_usuario"	json:"id_usuario"`
	Nombre 		string			`db:"nombre" 		json:"nombre"`
	Apellidos 	string			`db:"apellidos" 	json:"apellidos"`
	rol 		string			`db:"rol" 			json:"rol"`
	email 		string			`db:"email" 		json:"email"`
	password 	string			`db:"email" 		json:"email"`
}