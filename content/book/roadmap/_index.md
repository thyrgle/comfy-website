+++
title = "Roadmap"
weight = 20
sort_by = "weight"
template = "docs-section.html"
page_template = "docs-section.html"
insert_anchor_links = "right"
+++

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
