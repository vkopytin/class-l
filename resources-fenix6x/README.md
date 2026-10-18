# Fenix 6X resources

The SDK product ID is `fenix6xpro` (280x280). Its renderer is derived from
the Fenix 6 low-memory implementation: a cropped 270x270 buffer, custom
affine transforms, polygon clock hands, and font-based weather, moon,
and twilight icons. Layout and polygon coordinates are scaled by 14/13.

Background artwork comes from `resources-fenix7x/clock-example.png` and is
split into sixteen 70x70 tiles, loaded one at a time. Regenerate the tiles
with `python scripts/generate_fenix6x_resources.py` (requires Pillow).
The generator verifies that their reconstructed pixels match the source.
The battery bitmap and status icon font are referenced from the existing
Fenix 7X resource setup. Large sprite atlases and bitmap hands are not
loaded by this renderer.
