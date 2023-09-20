.PHONY: build default serve build-examples

# default: build
default: build-examples

build:
	zola build

serve:
	zola serve

build-examples:
	./tools/build-examples.sh

install-wasm-bindgen:
	cargo install -f wasm-bindgen-cli --version 0.2.87
