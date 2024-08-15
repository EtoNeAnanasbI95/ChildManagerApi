package main

import (
	"fmt"

    "github.com/EtoNeAnanasbI95/ChildManagerApi/internal/handlers"
	"github.com/go-chi/chi"
	"github.com/go-chi/chi/v5/middleware"
)

func main() {
    fmt.Println("Server is running")
    
    r := chi.NewRouter()
    
    r.Use(middleware.Logger) // add Logger
    r.Use(middleware.Recoverer) // add Recoverer that can recover logs from panic and will give a 500 code if it possible
    
    r.Get("/users", handlers.GetUsers)
    r.Put("/users", handlers.UpdateUser)
    r.Post("/users", handlers.CreateUser)
    r.Delete("/users", handlers.Deleteuser)
}
