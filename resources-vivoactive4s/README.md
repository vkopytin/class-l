# Vivoactive 4S (218x218)

Uses Fenix 6X low-memory rendering scaled by 218/280: a cropped 210x210
buffer, software affine transforms, polygon hands, and font-based weather,
moon, and twilight icons. The Vivoactive 4S SDK profile is MIP, API 3.3.

The native `board/218x218/background.png` is split into sixteen tiles with
edges at 0, 55, 109, 164, and 218. The background is not resized. The battery
bitmap is scaled from Fenix 7X to 26x9. Status icons reuse the Fenix 7 font;
other icons use the shared fonts. No fonts are added to `board/`.

Run `python scripts/generate_vivoactive4s_resources.py` (requires Pillow)
to regenerate the bitmaps and verify exact background reconstruction.
