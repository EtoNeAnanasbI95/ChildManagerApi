package config

import (
	"log"
	"os"
	"time"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	Port        string        `yaml:"port"         json:"port"         env-default:"8080"`
	ReadTimeout time.Duration `yaml:"read_timeout" json:"read_timeout" env-default:"15s"`
	IdleTimeout time.Duration `yaml:"idle_timeout" json:"idle_timeout" env-default:"30s"`
}

func MustLoadConfig() *Config {
	configPath := os.Getenv("CONFIG_PATH")
	if configPath == "" {
		log.Fatal("CONFIG_PATH isn't set")
	}
	if _, err := os.Stat(configPath); os.IsNotExist(err) {
		log.Fatal("Path is incorrect")
	}
	var cfg Config
	if err := cleanenv.ReadConfig(configPath, &cfg); err != nil {
		log.Fatal("Sometimes went error, can't read config")
	}
	return &cfg
}
