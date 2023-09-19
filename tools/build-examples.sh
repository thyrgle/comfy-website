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

date=$(date +"%Y-%m-%d")

template="""
+++
title = \"{{example}}\"
description = \"\"
date = $date

[extra]
screenshot = \"/screenshots/{{example}}.png\"
video = \"/videos/{{example}}.webm\"
gh_source = \"//github.com/darthdeus/comfy/blob/master/examples/{{example}}.rs\"
wasm_source = \"/wasm/{{example}}/index.html\"
+++
"""

for example in $(ls comfy/examples | grep -e "\.rs$" | sed "s/\.rs//"); do
  RUSTFLAGS=--cfg=web_sys_unstable_apis cargo build --target wasm32-unknown-unknown --release --example "$example"
  # cp -r examples/$1/resources target/generated/ || true
  dir="target/generated/$example"
  mkdir -p "$dir"
  cat index.html | sed "s/{{example}}/$example/" > "$dir/index.html"
  wasm-bindgen --out-dir "$dir" --target web "target/wasm32-unknown-unknown/release/examples/$example.wasm"
  echo "$template" | sed "s/{{example}}/$example/g" > "$parent_dir/content/examples/$example.md"
done

for example in $(ls comfy/examples | grep -e "\.rs$" | sed "s/\.rs//"); do
  # cargo run --release --example $example --features comfy-wgpu/record-pngs
  cp "target/screenshots/$example.png" "$parent_dir/static/screenshots/$example.png"
  cp "target/videos/$example.webm" "$parent_dir/static/videos/$example.webm"
done

rm -rf "$parent_dir/static/wasm"
cp -R "target/generated/" "$parent_dir/static/wasm/"
