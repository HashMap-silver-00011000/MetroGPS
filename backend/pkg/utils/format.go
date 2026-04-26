package utils

import (
	"net/http"
	"github.com/gin-gonic/gin"
)

//Contenerdor principal con todas las respuestas
type Response struct{
    Success bool 		`json:"success"`
    Data interface{} 	`json:"data,omitempty"` 
    Error *ErrorInfo 	`json:"error,omitempty"`
    Meta *Meta      	`json:"meta,omitempty"`
}

//Representar errores de forma estructurada
type ErrorInfo struct {
      Code    string `json:"code"`
      Message string `json:"message"`
}

//información extra
type Meta struct {
  Page       int `json:"page,omitempty"`
  PerPage    int `json:"per_page,omitempty"`
  Total      int `json:"total,omitempty"`
  TotalPages int `json:"total_pages,omitempty"`
}

//Funcion exito

func OK(c *gin.Context, data interface{}){
	c.JSON(http.StatusOK, Response{
		Success: true,
		Data: data,
	})
}

func Fail(c *gin.Context, status int, code, message string){
	c.JSON(status, Response{
		Success: false,
		Error: &ErrorInfo{Code: code, Message: message},
	})
}