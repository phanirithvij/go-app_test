all: run

.PHONY: run

web/app.wasm: main.go client.go
	GOARCH=wasm GOOS=js go build -ldflags="-s" -o web/app.wasm

goapptest.out: main.go server.go
	go build -buildmode=pie -trimpath -ldflags="-s -extldflags='-static'" -o goapptest.out

run: goapptest.out web/app.wasm 
	./goapptest.out

