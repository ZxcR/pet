package main

import (
	"context"
	"os"
	"os/signal"
	"pet/internal/app/api"
	"syscall"
)

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM, syscall.SIGINT)
	defer cancel()

	app := api.New()
	app.Run(ctx)

}
