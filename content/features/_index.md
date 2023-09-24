+++
title = "Features"
sort_by = "date"
template = "features.html"
+++

- Simple and productive API.
- Immediate mode rendering for sprites, text and shapes with automatic
  batching. If you want to draw a circle, you call a function `draw_circle`.
- 2D lighting with HDR, tonemapping and bloom.
- Built-in support for z-index, meaning you don't have to worry about the order
  of your draw calls.
- [egui](https://egui.rs/) support built in.
- Parallel asset loading with support for most image and audio formats.
- No complex ECS or abstractions to learn. Just build your game and let comfy
  get out of your way.
- Simple audio using [kira](https://docs.rs/kira/latest/kira/). If you want to
  play a sound, you call a function `play_sound`.
- Simple 2D camera.
- Particles, both simple API for individual particles & systems with lots of
  options.
- Trails with a custom mesh & scrolling texture.
- Text rendering (currently using egui).
- Lots of utilities for common tasks.

# Design goals & philosophy

- Heavy focus on ergonomics and productivity.
- No magic. The code does what it looks like it does.
- Targeted at simple games, currently only 2D.
- Opinionated and useful defaults.
- **Simple** immediate mode APIs for almost everything.
- Exposed internals for when you need more. Almost all struct fields are
  public, comfy doesn't keep things away from its user.
- Reasonable compile times. Comfy is slower to compile than macroquad, but we
  want to avoid things getting out of hand. End users are not going to be
  required to use any proc macros to use comfy.
- Global variables are nice. Comfy uses a lot of them.
- Typing less is nice. Comfy has a single context object that gets passed around everywhere.
- Constraints are nice. Comfy wants to be used for a lot of games, but not all
  of them.
- `RefCell`'s are nice. Comfy uses them a lot to work around partial borrows.
  We tried doing things without them multiple times, it was more painful.

# Non-goals

- AAA 3D support. While it's entirely possible to extend the renderer to handle
  3D, this was intentionally not done yet. There is a lot of complexity that
  comes with 3d models, materials, skeletal animations, etc. Comfy may grow to
  support simple 3d games in the future, but it is extremely unlikely it'll
  ever attempt to be competitive with big 3D engines. We want to make sure that
  the stuff we have works well and is usable before adding lots more complex
  features.
- ECS based engine. While comfy does embed [hecs](https://docs.rs/hecs) and
  provides some helpers for using it, it is by no means required or even
  optimal for most cases.
- Modularity. Comfy is not a modular engine. It's an opinionated toolkit
  with defaults that make sense for most games. There is no intention of
  having a plugin system or the ability to replace wgpu with something
  else.
- Maximum performance. Comfy is not designed to be the fastest engine out
  there. There are many tradeoffs made for the sake of ergonomics and ease of
  use, some of which affect performance. If you're looking for the fastest way
  to draw a million quads, comfy is not for you. If however you have a
  legitimate use case where the performance is not good enough, please open an
  issue. There is a lot of low hanging fruit with respect to performance, but
  as the development is driven by real world usage, unless something shows up
  in a profiler in a game, it's unlikely to be optimized further.
