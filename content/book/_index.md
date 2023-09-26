+++
title = "Comfy Book"
sort_by = "weight"
template = "docs-section.html"
insert_anchor_links = "right"
+++

_**Warning**: comfy is currently under heavy development. While there are
games already being made using comfy, the API is not yet stable and
breaking changes will happen. If you want to use comfy for your game you
may be forced to dig into the source code and possibly tweak things
manually. That being said, the source code is designed to be simple and
modifiable. If you want to make a game jam game comfy is definitely mature
enough._

Comfy is a fun 2D game engine built in Rust. It's designed to be
opinionated, productive, and easy to use. It uses [wgpu](https://wgpu.rs/)
and [winit](https://docs.rs/winit/latest/winit/), which makes it
cross-platform, currently supporting Windows, Linux, MacOS and WASM (iOS
and Android support planned _soon_). Inspired by macroquad, Raylib, Love2D
and many others, it is designed to just work and fill most of the common
use cases.

## Creating a comfy game

1. Install Rust: https://www.rust-lang.org/learn/get-started
2. From a terminal, create a new Rust project and add comfy as a dependency:

   ```sh
   cargo new my-comfy-game
   cd my-comfy-game
   cargo add comfy
   ```

3. Replace `src/main.rs` with a simple comfy game:

   ```rust
   use comfy::*;

   simple_game!("Nice red circle", update);

   fn update(_c: &mut EngineContext) {
      draw_circle(vec2(0.0, 0.0), 0.5, RED, 0);
   }
   ```

4. Run your game:

   ```sh
   cargo run
   ```

## Philosophy

The ultimate goal of comfy is to do the obvious thing as simply as
possible without unnecessray ceremony. If something is annoying to use, it
is a bug that should be fixed. We're not necessarily aiming at beginner
friendliness, but rather productive and ergonomic APIs. If you're a
beginner, comfy should be easy to pick up, but it might not be as polished
as some of the other alternatives. The goal of comfy is ultimately not
polish, cleanliness of API, clean design, type safety, extensibility, or
maximum features. It's an engine that gets out of your way so you can make
your game.

There is nothing that fundamentally prevents comfy from becoming a 3D
engine, but the last thing we want is to try to fight rend3 or bevy in
terms of PBR accuracy or skeletal animations. Comfy is not fighting
against Unreal Engine 5. It would be nice if
[simple](https://store.steampowered.com/app/824600/HROT/)
[stylized](https://store.steampowered.com/app/1055540/A_Short_Hike/)
[3D](https://store.steampowered.com/app/219890/Antichamber/)
[games](https://store.steampowered.com/app/219890/Antichamber/) were
ultimately possible, but we want to get all of the basic building blocks
for 2D first. Some internals of comfy (batching and z-sorting) will need
to be re-implemented to allow for this and ultimately more performant
rendering techniques, but this should not happen at the cost of API
clarity and ergonomics for most games.
