+++
title = "Release v0.4: Improved Performance (4x), Sprite Culling, Screenshot Capture, and more"
date = 2024-05-03
+++

This release is all about performance improvements, as well as many quality of life features and general capabilities and stability, none of which are particularly flashy, but that we found important in our own game development.

Comfy's code was never the fastest, but during our playtesting we found that it was starting to become a bottleneck. After
some non-trivial internal restructuring and optimizations, we're now able to draw 120000 sprites at 60 FPS, which is a **4x improvement** over the previous version. This is a very rough estimate, and many other things were sped up. Those that really care can explore the [comfy benchmark](https://github.com/darthdeus/comfy-benchmark).

There's also now a built-in sprite culling mechanism which will automatically skip drawing sprites that are outside of the
camera's viewport. This is enabled by default, and can be toggled at runtime with `set_cull_sprites(false)`. Games that
really need performance should perform their own culling and skip calling `draw_sprite(...)` for things outside of the viewport, as that can be significantly cheaper than Comfy's internal culling, but for games that don't need absolute
fastest performance, this feature should basically give a free speedup. Note that Comfy can't do the optimal thing out of the box, because it doesn't know how you store your data when you call `draw_sprite(...)`. If you need a spatial data structure to decide what should be drawn, consider using [Comfy's builtin `SpatialHash`](https://docs.rs/comfy/latest/comfy/spatial_hash/struct.SpatialHash.html). This implementation is far from optimal, but should be more than fast enough for most use cases.

Another feature that we found useful is the ability to capture screenshots at runtime. This is useful e.g. for marketing purposes. You can set `c.renderer.screenshot_params.record_screenshots = true` and optionally set `screenshot_interval_n` and `history_length` to take a screenshot every `n` frames, keeping up to `history_length` screenshots in memory. The whole screenshot buffer can then be saved by calling `save_screenshots_to_folder`. This is a very rough implementation, and there are many things that could be improved, but as usual, if you need something like this it should be good enough. This feature
should be considered experimental, as there hasn't really been a lot of testing around it, and only been used during development. If you need something more sophisticated, fork Comfy and do it yourself :) The code should be simple enough to understand for those who know what they need.

This is also the last release of Comfy that uses [wgpu](https://wgpu.rs/). We already have a work in progress port to [Macroquad](https://macroquad.rs/), which will effectively replace the `comfy-wgpu` crate.

There's more than one reason for this migration. Fundamentally, the reason why Comfy had its own renderer is that Macroquad didn't support f16 textures, which are necessary for HDR rendering. [This is no longer the case](https://github.com/not-fl3/miniquad/commit/04c0c76547dbaac2985bc3263fcef34739a210e6#diff-34b433796cb09381278b47772e25e075eec7fc7115447b0735b3a19aee3f3c4f), which means we can just migrate without losing anything. Another benefit is that Macroquad has by far the largest device support in the Rust ecosystem, which means Comfy will run on many more devices than it does now, basically for free. This will also significantly simplify Comfy's codebase, as we should be able to just remove a lot of the current boilerplate for setting up the renderer.

If all goes well, current release `v0.4.0` will be the last Comfy release to run on wgpu, with `v0.5.0` being released one the migration is completed.

The goal of the whole migration is to affect user code as little as possible. We're not planning on changing any APIs that are related to drawing, and the only thing that will likely be affected are custom shaders.

Lastly, I should note that we at [LogLog Games](https://loglog.games/) are no longer going to be making games in Rust. We recently released our main Comfy game, [Unrelaxing Quacks](https://store.steampowered.com/app/2331980/Unrelaxing_Quacks/) on Steam, and published an [excruciatingly detailed article on why we're stopping with Rust for game development](https://loglog.games/blog/leaving-rust-gamedev/). This probably isn't good news for anyone who was hoping to see more games made with Comfy. I do want to say that this doesn't mean Comfy is being abandoned, it's just not going to be actively in use by us.

The Macroquad migration is already in progress, and has been for some time. By removing wgpu the whole codebase will be simplified by quite a bit, easing on the maintenance burden, and also making it easier for others to contribute. Hopefully it should also reduce the number of graphics issues that users run into. We've definitely had a few with our game.

---

A few people have asked what's the reason for Comfy to even exist once it's migrated to Macroquad. Comfy's value was never in just `draw_sprite_pro(...)`, even though that is probably its most commonly used function. Macroquad is a lower level API than Comfy, and we'll retain some nice quality of life features:

- **y-sorting** with `set_y_sort(layer, true)`.
- **z_index** built into all draw calls, allowing users to draw things out of order.
- builtin support for animated sprites
- particle systems
- 2d lighting
- egui, ldtk, hecs, and other simple integrations
- more drawing primitives (arc, outlines, etc)

Note that none of these are particularly groundbreaking, and people should _not_ be discouraged from using Macroquad directly. Comfy exists mainly because we built it on top of Macroquad internally, and it was only opensourced later. The wgpu backend also existed only because we wanted HDR and f16 textures, and Macroquad didn't support that at the time, so we ended up writing it for ourselves.

Comfy's development has been 100% dogfooded, and every feature that exists is something we used for building one of our games. This means that it's not a groundbreakingly unique engine with flexible features, but it is something that can and has been to ship a full game. Those that want such things can use it, and those that don't value these things can use something else :)

---

There are many other changes in this release, following is the full [CHANGELOG](https://github.com/darthdeus/comfy/blob/master/CHANGELOG.md):


- Greatly improved sprite batching performance. [Comfymark] was previously
  running at ~15 FPS drawing 120000 Comfys, and with v0.4 this is now at
  stable 60 FPS on my machine, meaning **at least 4x improvement in sprite
  drawing performance**.
- Added automated screenshot capture mechanism with a fixed history, meaning you can
  now simply set `c.renderer.screenshot_params.record_screenshots = true` (and optionally
  `screenshot_interval_n` and `history_length`) to take a screenshot every `n` frames,
  keeping up to `history_length` screenshots in memory. The whole screenshot buffer can
  then be saved by calling `save_screenshots_to_folder`. Note that just enabling screenshot
  capture has a _significant_ performance overhead (around 20ms per frame in fullhd on my machine), meaning you probably don't want this turned on in release builds. It is however
  very useful for capturing interesting moments in your game e.g. for marketing purposes,
  since you can just play and hit a "save" hotkey a bit later, while still being able to pick
  the perfect screenshot. There is a [`screenshot_history example`](https://github.com/darthdeus/comfy/blob/master/comfy/examples/screenshot_history.rs) that showcases this, together with
  how one can copy the screenshots back into a `TextureHandle` on each frame to display them.
  Note that none of this is optimal, and many things could be improved.
- `Mesh` now has a new `origin` field. This shouldn't affect most users as
  it's only exposed through `draw_mesh`.
- Simplified `draw_mesh_ex` params, now accepting `BlendMode` instead of
  `TextureParams` containing only `BlendMode`. There will be further breaking changes
  around this API in the future, but none that should be complex for users to migrate.
- Greatly improved performance of blood canvas when a large number of writes are perfomed.
  Also greatly improved performance of `blood_canvas_blit_at` by roughly 5x, depending
  on the blitted sprite.
- Added sprite culling for `draw_sprite_pro`, `Sprite` and `AnimatedSprite`. This is now
  enabled by default and uses the `main_camera().viewport` to determine if the sprite
  is visible. The check is performed a bit conservatively to avoid issues. If you want to
  disable this for whatever reason, simply `set_cull_sprites(false)`. This can be toggled
  at runtime as much as you want and won't affect performance. You can get the current value
  with `get_sprite_culling`, e.g. if you wish to build an inspector window to control this.
- Added `enable_child_transforms` on `GameConfig` allowing the user to disable child/parent
  transform update. If you have a lot of entities (10k+) but aren't using child transforms,
  setting this to false may give you extra few percent of free performance. This is enabled
  by default.
- Added `flip_x/y` and `blood_canvas_blit_at_pro` which allows blitting sprites with arbitrary
  flipping. Note that this also fixes a long standing bug when in some cases sprites would be
  blitted flipped upside down.
- Fix linear vs sRGB tinting in blood canvas, see [this commit](https://github.com/darthdeus/comfy/commit/80a0ee8e81d036aadf3da56c2a6ecb3750306dff) for more details.
- Removed implicitly enabled pause system that would toggle `is_paused` on `EngineContext` when
  Esc is pressed. This was never really intended and was an oversight.
- Removed a few components that were never intended to be part of Comfy (e.g. `Health`, `DamagedCallback`, `Damage`).
  Users who need them can re-implement e.g. `pub struct Damage(pub f32)`, as all of these are trivial types.
- Allow changing `game_config_mut().target_framerate` during gameplay. Previously this was only possible
  at initialization, but Comfy will now update its frame timer at the end of each frame, allowing this
  to be configurable at will.
- Added `max_distance` to `Particle` allowing particles to only travel a set maximum distance.
- Added `spawn_particle_fan_ex` with more flexible parameters for max particle distance.
- Upgraded `wgpu: 0.18 -> 0.19.3, winit: 0.28 -> 0.29, egui: 0.24 -> 0.26`.
- Made `wgpu::PowerPreference` configurable & default to `None`, with the hope of fixing a potential
  issue where users have their dedicated GPU disabled on a dual GPU setup.
- Added option to override `max_texture_dimension_2d` in `GameConfig`, this is useful for games that want to support
  resolutions higher than 4K. It's not entirely clear to me whether we can safely just raise this and still work
  on all machines, hence why it becomes an optional override. We're doing some more testing on this in our
  game, and if it'll be safe we'll also change the default.
- Added `mouse_input_this_frame()` and `mouse_moved_this_frame()` for determining whether the mouse had any input
  in the current frame, or whether it was moved. This can be useful for switching between mouse and gamepad input.
