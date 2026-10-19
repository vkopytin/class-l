# Original Venu (390x390)

The Venu SDK profile provides pressure history and API 3.3, without the
native bitmap transforms used by FR965. This port retains the scaled FR965
OLED layout, copied artwork, status font, weather, and alternating AOD masks.

Clock hands are derived from the scaled FR965 PNGs as colored rectangles
and rotated with software affine transforms. Background tiles and individual
moon, twilight, and weather icons keep transient bitmap memory bounded.
The frame buffer includes the complete opaque background so Venu blends
anti-aliased text edges against the artwork instead of transparent pixels.
Always-on masks are generated at 390x390 rather than rescaled from FR965.
Each exposes at most 9.1% of the circular screen even over an entirely white
frame, and their openings are disjoint so each pixel turns off every other
minute. Run `python -m unittest discover -s tests -p 'test_venu_aod_masks.py'`
to check the shipped masks against both OLED limits.
Regenerate the artwork with `python scripts/generate_venu_resources.py`
(requires Pillow). Original-sized sprite atlases are not loaded at runtime.

Vivoactive 5 and 6 remain disabled. Fonts are not added to board/.
