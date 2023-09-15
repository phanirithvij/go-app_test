all: compress lint build

## Targets

web/app.wasm: main.go client.go
	GOARCH=wasm GOOS=js go build -ldflags="-s" -o web/app.wasm

web/app.wasm.gz: web/app.wasm
	 gzip -9 web/app.wasm -k -f

web/app.wasm.zst: web/app.wasm
	 zstd -z -19 web/app.wasm -f

web/app.wasm.br: web/app.wasm
	 brotli web/app.wasm -f
	 touch --reference=web/app.wasm web/app.wasm.br

goapptest.out: main.go server.go
	go build -buildmode=pie -trimpath -ldflags="-s -extldflags='-static'" -o goapptest.out

goapptest.prod.out: main.go server.go
	go build -trimpath -ldflags="-s -w" -o goapptest.prod.out
	upx --ultra-brute --strip-relocs=0 goapptest.prod.out

## Commands

.PHONY: run compress build build-prod clean kill reload lint all

compress: web/app.wasm.br web/app.wasm.zst web/app.wasm.gz

lint: Caddyfile
	caddy fmt --overwrite

build: web/app.wasm goapptest.out

build-prod: web/app.wasm goapptest.prod.out

clean:
	rm -f *.out
	rm -rf web

run: kill goapptest.out web/app.wasm 
	./goapptest.out &
	sudo caddy run

reload:
	sudo caddy adapt

kill:
	killall goapptest.out || true

