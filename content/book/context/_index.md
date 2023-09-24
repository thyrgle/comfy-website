+++
title = "Context"
weight = 4
sort_by = "weight"
template = "docs-section.html"
page_template = "docs-section.html"
insert_anchor_links = "right"
+++

A core design philosophy in comfy is that the engine should get out of
your way as much as possible. This includes things like not having to
specify 10+ different parameters in order to read input from the keyboard,
look at mouse position, and play a sound.

This is a controversial topic, and many prefer as much decoupling as possible,
but we've found that as far as building games goes, there is little value in
such separation.

Almost all game code will want to play some sounds, draw something, change
animation state and run some game logic.

Comfy's solution to the above is the `EngineContext`, a single struct which can
be passed around throughout the game and that references everything you may
want to use. _Almost_ meaning that some functionality is exposed through global
functions and does not even require using the context. These are things like
drawing, input, playing sounds, etc.

The `EngineContext` provides direct access to things like
[`egui`](https://docs.rs/egui/latest/egui/), lighting settings, ECS world and
its related command buffer, cooldowns, and more.

We've found that it is _extremely_ common to be in the middle of writing
gameplay logic and realize "oh crap I need to make an egui window to debug this
better". Being able to just write `c.egui` saves the developer from breaking
their thought process, and more importantly it makes cleanup significantly
easier.

## Game specific Context

While the `EngineContext` idea is great, we've found that going a bit further
is also extremely useful for game code. This section is by no means
prescriptive, and you can structure your comfy games however you prefer. But it
is also a pattern we've been working on for well over a year, and something
we've found increasingly more useful throughout building our games.

Firstly, let's introduce the idea of `GameState`, which is simply a struct that
stores game-related state that is global across the game. For very complicated
games one might want to use finite state machines and store state in a more
complicated way, but let's leave out AAA-size games for a while and focus on
smaller indie games, and assume we can just have our state in one place. ECS
users might find this to be the place where they store some of their `Entity`
handles if they don't want to use tag components.

Next up this is where we introduce the `GameContext`, which is a struct we'll
be using in _all_ of our game code. It will provide us access to
`EngineContext` for when we need it, but it'll also expose parts of `GameState`
and whatever else we might need.

The rest of this section roughly follows the [`physics
example`](https://github.com/darthdeus/comfy/blob/master/comfy/examples/physics.rs).

Let's say our game state looks something like this:

```rust
pub struct GameState {
    pub spawn_timer: f32,
    pub physics: Physics,
    pub ball_spawning_speed: BallSpawningSpeed,
}
```

We store a simple timer in f32, a physics engine state, and a flag telling us
how fast we want to spawn balls.

Now what should our `GameContext` look like? A simple variant should be
something along the lines of the following (lifetimes removed for now):

```rust
pub struct GameContext {
    pub state: &mut GameState,
    pub engine: &mut EngineContext,
}
```

The benefit is we don't have to write a lot of code, but the downside is now
all our code will have to do `c.state.physics` or `c.state.spawn_timer`. This
is not a huge deal, and some might prefer taking a small hit in ergonomics in game code
to save a bit of writing.

But we've found that the hardest part of making a game is _actually making the
game_, that is having good gameplay code, fun features, lots of iteration on
the game itself, etc. This is why we prefer the significantly more verbose
approach that will look ugly and redundant in the place where we define the
`GameContext`, but as will also simplify all of our game code.

```rust
pub struct GameContext<'a, 'b: 'a> {
    pub delta: f32,
    pub spawn_timer: &'a mut f32,
    pub ball_spawning_speed: &'a mut BallSpawningSpeed,
    pub physics: &'a mut Physics,
    pub engine: &'a mut EngineContext<'b>,
}
```

This time we've also included all of the necessary lifetimes. If these look
scary (especially since there's two), don't worry as these are the only two
lifetimes you'll see while using comfy :) There are a few ways around this, and
many potential tradeoffs, but again, it should be noted that a `GameContext` is
only defined once per game.

Note that we also added `delta`, which while being available on the
`EngineContext` is something that almost every bit of game code will want to
touch, and thus having a simple `c.delta` instead of `c.engine.delta` is a nice
quality of life improvement, at the cost of a few extra lines of code.

The next part could in theory be handled by a procedural macro, but comfy wants
to remain simple. As such we'll have to write a function which actually creates
this context object, which means we have to specify each field _again_. If
you're reading this and passing out from the amount of boilerplate, note that
this is entirely optional. Your game does not have to do any of this. But it is
a pattern we've been using for a while and found incredibly useful in terms of
our productivity.

Let's define the `make_context` function that will take `GameState` and
`EngineContext` and create a `GameContext`.

```rust
// An unfortunate re-apparance of the two lifetimes.
// This is the last time I promise.
fn make_context<'a, 'b: 'a>(
    state: &'a mut GameState,
    engine: &'a mut EngineContext<'b>,
) -> GameContext<'a, 'b> {
    GameContext {
        spawn_timer: &mut state.spawn_timer,
        delta: engine.delta,
        ball_spawning_speed: &mut state.ball_spawning_speed,
        egui: engine.egui,
        physics: &mut state.physics,
        engine,
    }
}
```

As a last step, comfy provides a `comfy_game!(...)` macro which can take you the rest of the way
and generate the necessary boilerplate.

```rust
comfy_game!(
    "Contexts are fun :)",
    GameContext,
    GameState,
    make_context,
    setup,
    update
);
```

Feel free to look inside the macro definition, or explore the
[`full_game_loop`](https://github.com/darthdeus/comfy/blob/master/comfy/examples/full_game_loop.rs)
example to see what this actually does, but note there is no extra magic hidden behind it.
