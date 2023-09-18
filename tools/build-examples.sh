#!/bin/bash
set -euxo pipefail

mkdir -p tmp
if [ ! -d "tmp/comfy" ]; then
  git clone --depth=1 git@github.com:darthdeus/comfy.git tmp/comfy
else
  echo "Directory tmp/comfy already exists, skipping clone."
fi

parent_dir="$PWD"

cd tmp/comfy

git pull origin master

mkdir -p target/generated/
rm -rf target/generated/*

template="""
+++
title = \"{{example}}\"
description = \"\"
date = 2019-11-27

[extra]
screenshot = \"/{{example}}.png\"
gh_source = \"//github.com/not-fl3/macroquad/blob/master/examples/{{example}}.rs\"
wasm_source = \"/gen_examples/{{example}}.html\"
+++
"""

for example in $(ls comfy/examples | grep -e "\.rs$" | sed "s/\.rs//"); do
  RUSTFLAGS=--cfg=web_sys_unstable_apis cargo build --target wasm32-unknown-unknown --release --example "$example"
  # cp -r examples/$1/resources target/generated/ || true
  dir="target/generated/$example"
  mkdir -p "$dir"
  sed "s/{{example}}/$example/" > "$dir/index.html" < index.html
  wasm-bindgen --out-dir "$dir" --target web "target/wasm32-unknown-unknown/release/examples/$example.wasm"
  echo "$template" | sed "s/{{example}}/$example/g" > "$parent_dir/content/examples/$example.md"
  cargo run --release --example $example --features comfy-wgpu/record-pngs
done

