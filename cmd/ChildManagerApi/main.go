package main

import (
	"github.com/EtoNeAnanasbI95/ChildManagerApi"
	"github.com/EtoNeAnanasbI95/ChildManagerApi/internal/config"
	"github.com/EtoNeAnanasbI95/ChildManagerApi/internal/handler"
	"github.com/EtoNeAnanasbI95/ChildManagerApi/internal/service"
	"log"
	"log/slog"
	"os"
)

func main() {
	os.Setenv("CONFIG_PATH", "./configs/config.yaml")
	cfg := config.MustLoadConfig()

	opt := &slog.HandlerOptions{}

	switch cfg.LogLevel {
	case "debug":
		opt.Level = slog.LevelDebug
	case "info":
		opt.Level = slog.LevelInfo
	}

	logger := slog.New(slog.NewTextHandler(os.Stdout, opt))
	logger.Info("Run api")
	logger.Info("API is running", "PORT", cfg.Port)
	srv := new(ChildManagerApi.Server)
	services := service.NewService()
	handlers := handler.NewHandler(services)
	if err := srv.Run(cfg, handlers.InitRoutes()); err != nil {
		log.Fatal("Failed to start server: ", err.Error())
	}
}
