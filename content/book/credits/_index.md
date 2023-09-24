+++
title = "Credits"
weight = 200
sort_by = "weight"
template = "docs-section.html"
page_template = "docs-section.html"
insert_anchor_links = "right"
+++

Comfy would not be possible without the Rust ecosystem. We build on the
shoulders of giants, notably (in no particular order)
[wgpu](https://wgpu.rs/), [winit](https://docs.rs/winit/latest/winit/),
[glam](https://docs.rs/glam/latest/glam/),
[hecs](https://docs.rs/hecs/latest/hecs/), [egui](https://www.egui.rs/),
[macroquad](https://macroquad.rs/) and [bevy](https://bevyengine.org/).

Despite not always agreeing with the design decisions of some of these,
it should be explicitly pointed out that we greatly appreciate the efforts
that go into these projects and the people behind them.

Macroquad has been an amazing inspiration in how a simple and pragmatic
ecosystem can be born, and how the complexity of Rust can be reduced to
APIs which are so simple that one can _just use them_.

Comfy initially started as a copy-paste of macroquad function headers with only
the internals changed to use wgpu, and only over time evolved into something
different.

Bevy has been a great inspiration in how a community can be built around a
unified vision, and how such a project can grow to a scale many would not think
was possible. While we may not agree with Bevy on many things in terms of what
a game engine should do, it would be foolish not to recognize its achievement,
both in designing great and innovative ECS APIs, as well as pushing Rust as a
language to its limits.

Comfy uses bits of code borrowed from Bevy, notably tonemapping shaders, bits
of logic around bloom, and a few utility functions (notably timers).
