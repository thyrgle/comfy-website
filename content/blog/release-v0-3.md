+++
title = "Release v0.3: No Lifetimes, User Shaders, Text Rendering, 2.5D, LDTK
date = 2023-11-21
+++

Much like overscoping is a problem in game development, I've just realized it's
apparently also a problem in game engine development. The v0.3 release was
supposed to follow v0.2 rather quickly, but as people asked for features I just
thought "what if we just add this one more thing" ... and now here we are :)

**There's a lot new in this release, but I'd also like to include a big
disclaimer that many of these features are not fully stabilized. They do work,
but there will be limitations and potential issues. Please be mindful of using
new experimental features (they're marked as such), and if you run into any
issues please create an issue on GitHub, or ping @darth on Discord.**

I'd also like to note that despite these features being marked as experimental,
we're already using everything in our own games. Existing code should not break,
and if you're on v0.2, it shouldn't take more than a few minutes to upgrade to v0.3,
without any expected brekage.

**Detailed information about changes are [in the GitHub repo's CHANGELOG.md
file](https://github.com/darthdeus/comfy/blob/master/CHANGELOG.md).**

Here's a brief list of new and changed features:

## No more lifetimes and `GameContext`.

From the first day this has been a pain point for all users who encountered it,
and the benefits turn out to be small. We were wrong in the initial design.
Starting with `v0.3` Comfy now has a much simpler `comfy_game!(...)` macro that
doesn't need any lifetimes or `GameContext`. (See changelog for more details).

## User defined fragment shaders

User defined fragment shaders with uniforms and shader hot reloading. Right now
we only support `f32` uniforms and relatively simple shaders, but using them is
quite simple. [Take a lookt at the fragment shader
example](https://github.com/darthdeus/comfy/blob/master/comfy/examples/fragment-shader.rs)
to see more. There's likely going to be breaking changes around this feature in
the future.

## Text rendering.

Up until now Comfy used [egui](https://egui.rs/) for text rendering. This
caused many subtle issues and inflexibilities. We've added a TTF rasterizer
using [fontdue](https://docs.rs/fontdue/latest/fontdue/) for rasterization and
[etagere](https://docs.rs/etagere) for texture atlas packing. This feature is
currently considered experimental, mainly because there's a lot of unknowns
around what the API should look like, how some of the parts should be
implemented, and a few inflexibilities. For example right now Comfy reserves a
single 4k texture for all the rasterized glyhps. This is of course less than
ideal, but we didn't hit the limit in our testing, and a future release can
improve upon this without breaking any user code.

## 2.5D/3D & perspective camera.

While "3D" may sound like a big deal for an initially 2D engine, **we very much
want to avoid over-hyping this feature.** This essentially just means [using a
perspective camera with
`glam`](https://docs.rs/glam/latest/glam/f32/struct.Mat4.html#method.perspective_rh)
and a few tweaks to allow users to configure this. Comfy does support drawing
arbitrary meshes with `draw_mesh_ex`, and now with custom fragment shaders this
can probably be taken a bit further than one could expect. But the ergonomics
around 3D are very much not ready yet. For example Comfy does not support
instanced rendering, and meshes do get uploaded to the GPU on every frame. This
is fine for 2D and sprites, but for non-trivial geometry you'd likely run into
issues.

We'd like to encourage users to experiment and share what they made, but please
don't use Comfy to build your next AAA 3D game. At least not yet :)

## LDTK support

Comfy now has a very simple builtin support for the [LDTK level
editor](https://ldtk.io/). This isn't very comprehensive yet, and it probably
does much less than you would expect it to do, but there are a few nice things!

Firstly, LDTK officially provides a [generated `serde`
parser](https://ldtk.io/files/quicktype/LdtkJson.rs) for its file format. This
is great in some ways, but [`serde`](https://serde.rs/)'s procedural macros are
_incredibly_ slow to compile, and could easily add seconds to your incremental
builds if you end up triggering a rebuild of the quicktype file.

This is especially noticable if you tried to do something like
`serde_json::from_str::<LdtkJson>(...)` in your crate. In my testing this
alone easily takes a <1s build to 3-5 seconds.

A solution is surprisingly simple, we just need to define a non-generic
function that wraps serde's generic deserializer and move it into its own
crate, meaning all the ugliness that happens with serde's types happen in the
crate, and it won't be triggered on incremental builds. Comfy can now define
the following function which really just calls serde, and this takes the build
time back to <1s quite comfortably. I haven't really noticed a significant
measurable difference with using LDTK this way compared to not using it.

```rust
pub fn parse_ldtk_map(
    map: &str,
) -> Result<quicktype::LdtkJson, serde_json::Error> {
    serde_json::from_str(map)
}
```

It would be interesting to see how this would compare with
[`nanoserde`](https://docs.rs/nanoserde/latest/nanoserde/), which is
_significantly faster to compile than serde_, but it would require some changes
to the generated LDTK file and we just haven't had the time to do those yet.
That being said, Comfy would like to move away from serde in the near future if
at all possible.

On top of this, we also provide a few extension traits for LDTK's types that
make working with it a little more convenient. Please keep in mind that LDTK
support is still very early, and you are expected to do digging into LDTK's
file format if you are to use this. That being said, LDTK is very well documented
and while it does have a learning curve it's realtively easy and simple.

## Other changes

We also have a few more small changes that are listed in the changelog. Notably
there is an experimental support for custom render targets, but for this
feature to be truly useful we'll need a few more things implemented in Comfy's
renderer, most notably around ordering operations.

There are quite a few issues that were planned for `v0.3` that didn't make it
into the release, and if someone has something they need fixed sooner rather
than later feel free to ping @darth on Discord. There's a lot of stuff
happening around Comfy at the same time, and I do forget things quite often :)

As for the upcoming features,
