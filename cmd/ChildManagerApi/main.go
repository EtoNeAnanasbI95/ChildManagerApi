package childmanagerapi

import "github.com/EtoNeAnanasbI95/ChildManagerApi/internal/config"

func main() {
    cfg := config.MustLoadConfig()
    _ = cfg
}
