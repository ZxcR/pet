package main

import (
	"context"
	"github.com/ZxcR/pet/internal/app/api"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM, syscall.SIGINT)
	defer cancel()

	app := api.New()
	app.Run(ctx)
}
