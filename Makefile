
.PHONY: build default serve

default: build

build:
	zola build

serve:
	zola serve
