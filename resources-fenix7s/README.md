# Fenix 7S resources (240x240)

Fenix 6S currently resolves to `resources-fenix5x`. Its sixteen background
tiles are joined into `background.png` with no resizing or pixel changes.
Regenerate with `python scripts/generate_fenix7s_resources.py` (Pillow).
Its battery bitmap and status font are reused directly.

Rendering uses the Fenix 7 native affine transforms, full 240x240 graphics
buffer, bitmap clock hands, sprite icons, and Garmin weather renderer.
Fenix 6S has no corresponding bitmap hands or sprite atlases, so those
assets are scaled from Fenix 7 by 12/13 in the resource compiler. Layout,
hand pivots, atlas coordinates, and clip sizes use the same scale.
Fonts remain in the build resources; no fonts are added to board/.
