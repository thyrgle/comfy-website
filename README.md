# Website for the [Comfy Engine](https://comfyengine.org/)

Running this website locally requires [Zola](https://www.getzola.org/).

Use `zola serve` to run the website. This won't include any of the WASM
examples.

If you want the examples, run `make build-examples`. Note that this will
clone comfy, build all the examples for WASM and desktop, and run all of
them for a few seconds to take screenshots and record video. The whole
process is automated.
