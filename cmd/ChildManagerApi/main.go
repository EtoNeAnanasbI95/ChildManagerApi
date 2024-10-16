package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("Run api")
	//cfg := config.MustLoadConfig()
	//_ = cfg

	for true {
		fmt.Println("Running")
		time.Sleep(1 * time.Second)
	}
}
