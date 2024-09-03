package handler

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *Handler) Create(c *gin.Context) {
    if err := h.services.Create(); err != nil {
        fmt.Println("Can not create new user")
        c.AbortWithStatusJSON(http.StatusInternalServerError, "Can not create new user")
    }
}

func (h *Handler) Update(c *gin.Context) {
    if err := h.services.Update(); err != nil {
        fmt.Println("Can not create new user")
        c.AbortWithStatusJSON(http.StatusInternalServerError, "Can not update new user")
    }
}


func (h *Handler) Delete(c *gin.Context) {
    if err := h.services.Delete(); err != nil {
        fmt.Println("Can not create new user")
        c.AbortWithStatusJSON(http.StatusInternalServerError, "Can not delete new user")
    }
}
