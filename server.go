//go:build !wasm

package main

import (
	"github.com/maxence-charriere/go-app/v9/pkg/app"
	"log"
	"net/http"
)

func AppServer() {
	app.Route("/", &hello{})
	http.Handle("/", &app.Handler{
		Name:        "Hello",
		Description: "An Hello World! example",
	})

	if err := http.ListenAndServe(":8000", nil); err != nil {
		log.Fatal(err)
	}
}
