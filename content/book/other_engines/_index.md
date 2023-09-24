+++
title = "Why comfy and not X?"
weight = 10
sort_by = "weight"
template = "docs-section.html"
page_template = "docs-section.html"
insert_anchor_links = "right"
+++

There are many other great frameworks and engines in Rust. This section
goes over the most notable ones and explains how comfy differs and to an
extent why it exists.

## [macroquad](https://macroquad.rs/)

Before I started working on comfy I was using [macroquad](https://macroquad.rs/)
for my games. It works great, but a few things were missing, most notably
RGBA16F textures, which are a feature of OpenGL 3.x, and without which HDR is
not really possible. This is because macroquad targets older versions of GLES
to achieve better cross-platform support. While this is great for many use
cases, at the time I really wanted to play with HDR, bloom and tonemapping,
which lead me down the [wgpu](https://wgpu.rs/) path.

The first version of comfy actually had an API almost identical to macroquad,
where I basically copy pasted function definitions and implemented most of the
functionality on top of wgpu instead. Over time I realized I wanted a few more
things, namely built-in z-index so that my game code wouldn't have to worry
about draw order.

If you like the idea of comfy but it's not stable enough for your use case I
very highly recommend giving macroquad a try. While it is not perfect it has
helped me build a bunch of small games, and most importantly I had fun while
making them.

### Differences between `comfy` and `macroquad`

Macroquad is the biggest inspiration to comfy, and as such there are many
things which are similar, but there are quite a few differences.

**Coordinate systems:**

- Macroquad's coordinate system is `[0, 0]` in top left, `y`-down, measured in
  pixels.
- Comfy's coordinate system is `[0, 0]` in the center, `y`-up, measured in
  world units. Default camera has zoom set to `30`, which means you can see
  roughly `30` world units. In a pixel-art game with 16x16 sprites, you would
  ideally set your camera's zoom so each sprite is `1` world unit.

**Z-index built in**. In macroquad, draw calls happen in the order you call
them. In comfy, almost everything (excluding text and UI) accepts a `z_index:
i32`. This means you don't need to sort the calls yourself, comfy will do it
for you while still batching the draw calls as best it can.

**HDR render textures**: Macroquad targets GLES2/3 to support as many platforms
as possible, and as such it can't support RGBA16F textures. Comfy targets
desktop and WASM through WebGL 2, both of which allow `f16` textures, and thus
all rendering is done with HDR and tonemapped accordingly. This allows our
bloom implementation to work off of HDR colors and greatly simplify working
with lights, as the light intensity can go well beyond 1.

**Batteries included**: Comfy includes many extra things that macroquad does
not, for example egui itself is part of comfy and likely will remain this way
until a better alternative comes along. Macroquad and miniquad provide small
flexible building blocks, while comfy aims to be a full and relatively
opinionated way of making games.

There are many more subtle differences, but in principle you can think of as
comfy as "macroquad with more batteries included, built on top of wgpu, with
less cross platform capabilities". Note that because comfy builds on wgpu and
not OpenGL we don't have the same immediate mode interactions with Gthat
because comfy builds on wgpu and not OpenGL we don't have the same immediate
mode interactions with GL. This makes some things more difficult, e.g. render
targets, changing shader uniforms, etc.

Comfy intends to support all of these features, but it will take a bit more
development. Many engines (e.g. bevy and rend3) end up using render graphs in
order to expose the rendering logic to users. While these are very flexible and
offer high performance their APIs are anything but simple.

Since our intention is not to support AAA graphics the goal should be to find
some form of middle ground, where we could achieve something similar to
macroquad in terms of API simplicity, expressivity, and fun, while utilizing
all of the power wgpu has to offer.

The ultimate design goal of comfy is that most of its API should be
understandable from just looking at the type signatures, without needing to
study documentation in depth, and without excessive footguns.

## [rend3](https://rend3.rs/)

I don't have much experience with rend3 apart from digging a bit through its
code, but as a 3d renderer it fills a very different niche than comfy. If you're
building a 3d game and don't want to do PBR rendering, rend3 is probably
something you want to consider.

## [Fyrox](https://fyrox.rs/)

Fyrox seems like it is trying to fight Unity, Godot and Unreal head on by
currently being the only fully featured Rust game engine, notably also
including a full 3D scene editor. Its 3D demos are very impressive in
particular, and if you're looking for a fully featured 3D engine it's
definitely something to consider.

That being said, comfy is unapologetically focused on simple games, and as such
fills a very different niche than Fyrox.

## [bevy](https://bevyengine.org/)

Bevy is another contender for the "big Rust game engine" spot. In terms of its
2D features Bevy definitely wins on the size of community and overall crate
support and modularity, but this is something where comfy is not even attempting
to compete. comfy is designed to be opinionated, simple and pragmatic, while
Bevy's goal is to be modular, extensible and build on top of its
all-encompasing ECS.

Due to its modularity Bevy offers many more features through community asset
crates which greatly extend it, but also has a rather distributed and unstable
ecosystem.

Comfy's goal is opposite in many ways. The goal is to provide a simple, stable
and pragmatic foundation. comfy is not a platform for experimenting with Rust's
type system, ECS, or other abstractions. It's a toolkit designed for making
small games.

The only features you'll find in comfy are those which can be immediately used,
understood, and that work from day 1. If a feature is not being used in a real
game it won't appear in the engine source code.

## [ggez](https://ggez.rs/)

ggez is one of those libraries that have been around for a while, but I've
never really got a chance to use it. It does seem to have a bit of a history
with losing maintainers, which is why I never got to use it, as both times when
I was switching frameworks/engines in Rust it was unmaintained. Although in the
current version it did get upgraded to a wgpu-based backend, but I can't speak
to its quality. I would imagine it's a great alternative to macroquad.

---

There are many other frameworks/engines in Rust, but the ones above are
the only ones I've had a chance to interact with in any significant way,
hence why they're the ones in the comparison.
