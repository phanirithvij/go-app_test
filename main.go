package main

import (
	"math/rand"

	"github.com/maxence-charriere/go-app/v9/pkg/app"
)

type hello struct {
	app.Compo

	Number int
}

func (h *hello) Render() app.UI {
	h.Number = rand.Intn(42)
	return app.H1().Body(app.Text("Hello World!"), app.Text(3892))
}

func main() {
	AppServer()
}
