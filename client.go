//go:build wasm

package main

import "github.com/maxence-charriere/go-app/v9/pkg/app"

func AppServer() {
	app.Route("/", &hello{})
	app.RunWhenOnBrowser()
}
