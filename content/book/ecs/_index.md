+++
title = "ECS"
weight = 5
sort_by = "weight"
template = "docs-section.html"
page_template = "docs-section.html"
insert_anchor_links = "right"
+++

While comfy does not mandate the use of ECS, it does include
[hecs](https://docs.rs/hecs/latest/hecs/) along with a few useful components
and helpers. If you don't like `hecs` and would want to use something else, you
are 100% able to do so. Currently there is no way to turn off `hecs` with a
feature flag, mainly because it hasn't been a priority for us, but is something
that we're not opposed to doing.

Everything ECS related that comfy does builds on the existing public APIs,
which means any of the ECS features that are built in could just as well be
implemented by the user.

Notably comfy provides a `Sprite`
([example](https://github.com/darthdeus/comfy/blob/master/comfy/examples/ecs_sprite.rs))
and `AnimatedSprite`
([example](https://github.com/darthdeus/comfy/blob/master/comfy/examples/ecs_topdown_game.rs))
components, as well as a `Transform` component which supports child transforms.
Note this isn't something we really use to build complex scene trees, but it
may come in handy from time to time.

You can think of `Sprite` as simply "something that makes comfy call
`draw_sprite`" every frame. The `AnimatedSprite` is similar, but it also
handles all of the animation timing and state updates, and it is probably the
main reason why you'd want to use ECS with comfy.

Note that there is nothing inherently magical about `AnimatedSprite` being tied
to ECS, and you could very well instantiate it yourself, store it in your own
data structures, and use the provided methods to draw it manually with
`draw_sprite`.

Comfy does include a few other components with builtin functionality, but as
some of the APIs aren't the most stable we're not going to document them here
for the v0.1 release. If you're feeling adventurous, browse around the codebase
and see what you can find. Note that almost nothing in comfy is hidden from the
user, and all internal state/fields are exposed. This is something we've done
intentionally to make comfy a bit more flexible without having to build complex
render graphs and other modular data structures.
