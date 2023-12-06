+++
title = "Releasing Your Game"
weight = 30
sort_by = "weight"
template = "docs-section.html"
page_template = "docs-section.html"
insert_anchor_links = "right"
+++

This section covers the general steps to take when you want to release your
game to players, be it just for playtesting, or for a final release on a
platform like Steam or Itch.io.

## Release builds

By default Comfy might turn on some debug features, such as the FPS performance
window. You can enable a `ci-release` feature with `cargo` that should be
viewed as _do what makes sense for a release build_. The reason it's named
`ci-release` is that `cargo` already has a `--release` flag, and it's likely
you might want to create release builds in CI anyway :)

To build a release build, run the following

```bash
cargo run --release --features comfy/ci-release
```

The `--release` flag enables release optimizations with the Rust compiler,
which will make your game run a bit faster depending on your dev config. If you
haven't enabled any optimizations in development (say with `opt-level = 1`)
this will end up being _significantly_ faster than your debug builds. Note that
building with `--release` takes noticably longer.

After this, you should have a `game-name.exe` under `target/release`, where `game-name`
is the name of your binary crate.

If you're using `include_bytes!(...)` or Comfy's parallel asset loader you
don't need to distribute any other file, as everything will be packed into the
executable :)

If you're loading assets/shaders by hand using `std::fs::read` or similar
you'll have to make sure you pack and distribute your assets with the built
binary.

## WASM (Web) builds with Itch.io

Comfy does natively support web builds with Web Assembly (WASM) with a little bit of setup.
Firstly, you'll need to install the `wasm32-unknown-unknown` target with `rustup`

```bash
rustup target add wasm32-unknown-unknown
```

After that we need to actually build the game. There's quite a few options for
WASM, but the easiest right now seems to be using
[Trunk](https://trunkrs.dev/). If you have some other preference feel free to
use it instead :) If you run into issues, please report it as a bug on GitHub.
Everything should mostly "just work". Only thing to note is that Comfy will
attach the canvas to a HTML element with the id `wasm-body`. This will become
configurable in the future, but for now this should be good enough for most use
cases.

To install `trunk` run the following:

```bash
cargo install --locked trunk
```

Next up, you'll need to add a `index.html` to your project. There's a few
things that are required, notably Comfy uses a HTML element with the id
`wasm-body` to attach the canvas it renders into.

If you don't want to bother with any of this, [you can use the `index.html`
from one of our demo
games](https://github.com/darthdeus/comfy-demos/blob/master/bitmob/index.html)
which already has everything setup. The other nice thing this file does is
correctly handle audio sources on the web, since web browsers won't allow
websites to play audio until the user has interacted with the page, and the
`index.html` linked above handles this correctly.

Lastly, you just need to use `trunk` to build the distribution package, which is as simple as

```bash
$ trunk build --release --features comfy/ci-release
```

This will create a `dist/` folder that you can just upload to your web server
or itch.io. Note that if you're using itch.io you might need to enable
`SharedArrayBuffer` support on itch.io. [This page describes some of the common
errors](https://itch.io/docs/creators/html5#common-pitfalls).
