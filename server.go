package ChildManagerApi

import (
	"context"
	"net/http"

	"github.com/EtoNeAnanasbI95/ChildManagerApi/internal/config"
)

type Server struct {
	httpServer http.Server
}

func (s *Server) Run(cfg *config.Config, handler http.Handler) error {
	s.httpServer = http.Server{
		Addr:        cfg.Port,
		Handler:     handler,
		ReadTimeout: cfg.ReadTimeout,
		IdleTimeout: cfg.IdleTimeout,
	}
	return s.httpServer.ListenAndServe()
}

func (s *Server) Shutdown(ctx context.Context) error {
	return s.httpServer.Shutdown(ctx)
}
