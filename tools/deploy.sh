#!/bin/bash
set -euxo pipefail

# git worktree add ../gh-pages-dir gh-pages
zola build
cp -r public/* ../gh-pages-dir/

cd ../gh-pages-dir
git add -A
git commit -m "Deploying site to GitHub Pages"
git push origin gh-pages

git worktree remove ../gh-pages-dir
