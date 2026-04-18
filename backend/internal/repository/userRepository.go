package repository

import (

	"log"

	"github.com/jmoiron/sqlx"
	"backend/internal/models"
)


type UsuarioRepository struct{
	db *sqlx.DB
}

func NewUsuarioRepository(db *sqlx.DB) *UsuarioRepository{

	if db == nil {
		panic("No puedes crear un repositorio sin una base de datos")
	}
	return &UsuarioRepository{db:db}
}

func (r *UsuarioRepository) CrearUsuario(usuario *models.Usuario) error {

	_ ,err := r.db.NamedExec(`INSERT INTO usuario (nombre, apellidos, rol, email, password)
				VALUES (:nombre, :apellidos, :rol, :email, :password)`, usuario)

    log.Printf("Error creating user: %v", err)
    return err
    

}