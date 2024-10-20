package handler

import (
	"github.com/EtoNeAnanasbI95/ChildManagerApi/internal/service"
	"github.com/gin-gonic/gin"
)

type Handler struct {
	services *service.Service
}

func NewHandler(services *service.Service) *Handler {
	return &Handler{
		services: services,
	}
}

func (h *Handler) InitRoutes() *gin.Engine {
	router := gin.New()
	router.Use(gin.Logger())
	router.POST("users", h.Create)
	router.PUT("users", h.Update)
	router.DELETE("users", h.Delete)
	return router
}
