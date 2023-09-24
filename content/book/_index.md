+++
title = "Comfy Book"
sort_by = "weight"
template = "docs-section.html"
insert_anchor_links = "right"
+++

Comfy is a fun 2D game engine built in Rust. It's designed to be
opinionated, productive, and easy to use. It uses [wgpu](https://wgpu.rs/)
and [winit](https://docs.rs/winit/latest/winit/), which makes it
cross-platform, currently supporting Windows, Linux, MacOS and WASM.
Inspired by macroquad, Raylib, Love2D and many others, it is designed to
just work and fill most of the common use cases.

**Warning**: comfy is currently under heavy development. While there are
games already being made using comfy, the API is not yet stable and
breaking changes will happen. If you want to use comfy for your game you
may be forced to dig into the source code and possibly tweak things
manually. That being said, the source code is designed to be simple and
modifiable. If you want to make a game jam game comfy is definitely mature
enough.

> `comfy` is named comfy, because it is very comfy to use.

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

# Features

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

# Getting started

The repository contains many examples under the `comfy/examples` folder.
While there is currently no documentation, the API is simple enough that
just reading the examples should explain things.


---

There are many other frameworks/engines in Rust, but I haven't had a chance to
interact with those in any significant way, hence why they're not in this
comparison.

# Roadmap

The following goals are not in any particular order, but should come reasonably
soon. Comfy is not an aetheral project that will only materialize in 2 years.
Only features that require maximum few weeks of work are listed here.

- Improved lighting. Right now we do have 2d lights, but they're basic,
  ugly in some scenarios, and not very flexible.
- Configurable bloom. Currently bloom is hard-coded to simplify a few things
  and always enabled. We don't want to delay the release to fix this since it
  does make games look better by default, but it is one of the first few things
  that will get fixed after v0.1 release.
- Configurable post processing.
- Custom shaders/materials.
- Render targets.
- Gamepad & touchpad support.
- Antialiasing.
- 2D shadowcasters with soft shadows.
- Asset packing without `include_dir`. Right now comfy relies on either its
  builtin use of [include_dir](https://github.com/darthdeus/include_dir) (a
  small fork with a few extra features), or the user handling asset loading
  manually. There are many other ways of packing assets, and it would be cool
  to support those, but we don't currently because for reasonably (<1GB) sized
  assets `include_dir` works well enough.
- Text rendering without egui. Right now all text (drawn with `draw_text` and
  friends) is rendered using `egui`'s painter on a separate layer. This gives
  us a lot of features in terms of text rendering, but also comes with some
  limitations. The goal is to implement text rendering on top of just wgpu.
  We've tried a few different approaches (e.g. `glyphon`) but ultimately found
  none to be easy enough to just replace what we have in `egui`, and since no
  games were yet blocked on more flexible rendering this remains a relatively
  low priority problem.
- Overall engine/renderer code cleanup. The code in comfy is not beautiful as
  it developed organically while building multiple games. There are some
  features that could be better exposed, and some remains of what our games
  needed. The provided examples should serve as a foundation to make sure comfy
  is flexible enough, but it is an ongoing effort to improve the codebase. That
  being said, almost everything you find in comfy should work to a reasonable
  extent.
- Reduce re-borrows & `RefCell`s. Right now we use _a lot_ of `RefCell`
  for almost everything. While this helps in a few places there are many
  places where it is not necessary, and where we also excessively borrow
  and re-borrow multiple times per frame. Currently we haven't noticed any of
  this impacting performance, but it is something that should be cleaned up.
  There's also a few things which use a `Mutex` unnecessarily.

While comfy is ready to use, the codebase is far from clean. The engine
evolves rapidly as we work on our games, and there are many parts that can
and will be improved. Comfy is being released before it is 100% perfect,
because even in its current state it can be very well used to make 2D games.

There may be a few oddities you may run into, and some internals are
planned to be re-done, but anything covered by the examples should 100%
work. We have been using comfy internally for over 6 months, and a large
part of its codebase has been ported from our previous OpenGL based
engine. This doesn't mean the engine is mature, but we have had real
players play our games made with comfy.


# License

comfy is free and open source and dual licensed under MIT and Apache 2.0 licenses.

# Games using comfy

Comfy is being used by [LogLog Games](https://loglog.games/), and currently
used in a few of our games, two of which you can check out on Steam.

- [NANOVOID](https://store.steampowered.com/app/2326430/NANOVOID) - 2d top down tactical space shooter.
- [BITGUN Survivors](https://store.steampowered.com/app/2081500/BITGUN_Survivors) - open world take on the vampire survivors genre, a spiritual successor to our last big Rust game [BITGUN](https://store.steampowered.com/app/1673940/BITGUN).

We've also used comfy in a few smaller games, e.g. our [1-bit jam
entry](https://logloggames.itch.io/bitmob-1-bit-jam) where we experimented with
CPU textures and 2D raytracing.

