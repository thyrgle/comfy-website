+++
title = "Games Using Comfy"
weight = 100
sort_by = "weight"
template = "docs-section.html"
page_template = "docs-section.html"
insert_anchor_links = "right"
+++

We have been building Comfy internally at [LogLog Games](https://loglog.games/)
almost a year now. As such, we have a few games that are using it.

The two bigger examples are

{{ games_using_comfy() }}

We also have a small unconventional example of using comfy to do 2D CPU based
raytracing
[https://logloggames.itch.io/bitmob-1-bit-jam](https://logloggames.itch.io/bitmob-1-bit-jam),
which will be opensourced soon. It's a relatively small game, but hopefully
will serve as a nice illustration of non-conventional ways to make games.
Specifically, the whole game is a single texture where every pixel is copied
over from other textures, and lighting calculated using simple raytracing.

