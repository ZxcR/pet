package api

import (
	"context"
	"fmt"
)

type App struct {
}

func New() *App {
	return &App{}
}
func (a *App) Run(ctx context.Context) {
	fmt.Println("App started")
}
