all: compress run

.PHONY: run compress

web/app.wasm: main.go client.go
	GOARCH=wasm GOOS=js go build -ldflags="-s" -o web/app.wasm

web/app.wasm.gz: web/app.wasm
	 gzip -9 web/app.wasm -k -f

web/app.wasm.zst: web/app.wasm
	 zstd -z -19 web/app.wasm -f

web/app.wasm.br: web/app.wasm
	 brotli web/app.wasm -f

compress: web/app.wasm.br web/app.wasm.zst web/app.wasm.gz

goapptest.out: main.go server.go
	go build -buildmode=pie -trimpath -ldflags="-s -extldflags='-static'" -o goapptest.out

run: goapptest.out web/app.wasm 
	./goapptest.out &
	sudo caddy run
