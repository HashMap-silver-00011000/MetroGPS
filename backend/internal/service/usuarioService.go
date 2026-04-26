package service

import (
	"backend/internal/models"
	"backend/internal/repository"
	"errors"
)

type UsuarioService struct{
	r *repository.UsuarioRepository 
}

func NewUsuarioService (r *repository.UsuarioRepository) *UsuarioService {
	return &UsuarioService{r:r}
}

func (s *UsuarioService) NuevoUsuario(usuario *models.Usuario) error {

	err := s.r.CrearUsuario(usuario)
	return  err

}

func (s *UsuarioService) Autenticar(usuarioE *models.Usuario) (*models.Usuario, error) {

	usuario , err :=  s.r.BuscarPorEmail(usuarioE)
	
	if err != nil {
		return nil, errors.New("Credenciales no validas")
	}

	if usuario.Password != usuarioE.Password {
		return nil, errors.New("Credenciales no validas")
	}

	return usuario, nil
}
