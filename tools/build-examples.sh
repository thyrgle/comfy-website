#!/bin/bash
set -euxo pipefail

mkdir -p tmp
if [ ! -d "tmp/comfy" ]; then
  git clone --depth=1 git@github.com:darthdeus/comfy.git tmp/comfy
else
  echo "Directory tmp/comfy already exists, skipping clone."
fi

cd tmp/comfy

git pull origin master

make build-examples
