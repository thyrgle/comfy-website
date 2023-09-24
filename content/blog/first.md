+++
title = "Hello Comfy!"
date = 2023-09-24
+++

This post introduces Comfy, a new fun 2D rust game engine built on top of wgpu.
Comfy is designed to be opinionated, productive and easy to use. It's free and
open source under MIT and Apache 2 licenses.

Today we're releasing the first version of Comfy, `v0.1`, which is just the
very beginning of its journey.

Comfy is a product of our work at [LogLog Games](https://loglog.games/), where
we've been using it for almost a year now, and have currently a few games in
progress that are it. Internally, we have well over 20k lines of game code
using using Comfy.

While still in its infancy, Comfy provides a solid foundation for making 2D
games in Rust. It offers an immediate mode style API for drawing and audio
(similar to macroquad), and a small ECS foundation that builds on top of it.

Comfy is not prescriptive in how you build your games. It's not an ECS based
engine, nor is it a macro-heavy engine. It's a pragmatic toolkit that lets you
focus on your game. We didn't aim to create the fastest engine, or the most
performant renderer, the most flexible render graph, or the most powerful ECS.

We're not trying to compete with Unity, Unreal, Godot, or even Bevy. If you're
looking for state of the art usage of Rust's type system, a fully featured PBR
renderer, or the most extensible and performant solution, Comfy is not for you.

Our goal was to build an engine where if you're making a 2D game, you can just
run `cargo new game`, and start writing game code. Comfy does not require you
to study its internals, watch tutorials, or read lots of documentation. Comfy
does not want you to do things in any specific way. You're free to structure
your game however you want.

If you want to draw a sprite, you just call `draw_sprite`. If you want to play
a sound, you just call `play_sound`. If you want to access the ECS command
buffer, you don't need to use dependency injection or macros, you just call
`c.commands()`. If you want to create an [egui](https://www.egui.rs/) window,
you access the `egui::Context` simply as `c.egui`. Comfy uses a single `c: &mut
EngineContext` passed around your code which can be used to access all of its
functionality.

Comfy also uses global variables for state internally. This is intentional, as
we haven't really found performance gains from using implicitly parallel ECS in
our past experiments with other engines. We prefer to use data parallelism
(e.g. with [rayon](https://docs.rs/rayon/latest/rayon/)) where necessary, while
keeping the core engine single threaded. This may be suboptimal, but it also
massively simplifies everything.

We also use `RefCell`s, which to many may seem like an anti-pattern, but it
also greatly simplifies game code as it lets us work around limitations with
partial borrows.

Despite the above, Comfy is still very fast. It's not as fast as some of the
alternatives, and you will 100% be able to create a benchmark that will make it
look bad. But game development is not a competition about who can render 100k
sprites the fastest. It's about making games. Comfy has a builtin integration
with [the Tracy profiler](https://github.com/wolfpld/tracy), and we use it
heavily throughout our development to make sure our games run fast enough.

The hardest part of making a game engine is actually making the game. Comfy
tries to take reasonable sacrifices and just allow its users on the game
itself.

By game we mean _something a small team of indie developers can make and ship
in a reasonable amount of time_. Comfy will not power the next AAA game, it
won't help you build a 3D MMO, or an infinite voxel world. It won't help you
beating UE5's Nanite in benchmarks, we don't even have a 3D perspective camera
(yet).

But it might help you make a small 2D game in the next few months, release it
on Steam, and have real players enjoy it. If that is something that you aspire
to, Comfy might be a good fit. We're still very very early on our journey, but
the foundation is solid, and games can already be made. There are many rough
edges and incomplete features, but we're in this for the long term. Comfy is
not an experiment, it's a real game engine meant to be used in real games.

While Comfy has many examples, the code remains currently undocumented. It's
something we want to fix very soon, but the core APIs as presented in the
examples are very simple and should be understandable without any
documentation. The core concepts of Comfy are explained in [the comfy
book](https://comfyengine.org/book/). The code itself is also far from clean,
as we've been focusing our efforts on making the engine functional for our games,
and only now that Comfy is becoming opensource more people are going to see it.

If you'd like to see the future direction of Comfy, check out [our
Roadmap](https://comfyengine.org/book/roadmap/).

It should also be noted that LogLog games is only two people, me
[@darthdeus](https://github.com/darthdeus) and my wife
[@shosanna](https://github.com/shosanna), where basically all of the
engine was just built by me, while my wife focused on the games. This is
just to set expectations around the engine, as while we may be making
games for a few years, we're not a big studio with a team of people
dedicated to building the next AAA game engine. We've dedicated a lot of
time to Comfy and our games, and will continue to support it, but we
also both have jobs and other responisbilities. Please be kind in your
expectations :)

That being said, feedback is _very_ welcome. The best way to learn Comfy is by
writing code, so if you found the above interesting or even exciting, check out
[our examples](https://github.com/darthdeus/comfy/tree/master/comfy/examples)
and [the comfy book](https://comfyengine.org/book/). If you have any questions,
feel free to reach out on our [Discord](https://discord.gg/M8hySjuG48), and if
you run into any problems please do [open an issue on
GitHub](https://github.com/darthdeus/comfy/issues).
