# Venu 2S (360 x 360)

This port uses FR965's layout, artwork, sensor modules, weather, status font,
and analog/digital clocks at 360/454 scale. The complete background is composed
behind text. All sprite crops have scaled coordinates and draw through explicit
clipping. Hands rotate with bilinear filtering, preserve their original pivots,
and disable automatic palettes.

Artwork is referenced from `resources-round-454x454`; there is no duplicate
background or sprite atlas. The custom status font remains a shared resource,
and no fonts are added to `board/`.

The two native 360 x 360 always-on masks have disjoint openings. Each exposes
less than 9.5% of the circular display even over a white frame, and every pixel
is black on alternating minutes. Sleep and wake use the existing shared view.

Regenerate layout, atlas coordinates, resource declarations and AOD masks with:

    python scripts/generate_venu2s_resources.py

Python requires Pillow. Validate the masks with:

    python -m unittest discover -s tests -p test_venu2s_aod.py

Build and run the complete Connect IQ test suite with the simulator open:

    monkeyc -f monkey.jungle -d venu2s -y <developer-key.der> -t -o bin/venu2s-tests/class-l-tests.prg
    monkeydo bin/venu2s-tests/class-l-tests.prg venu2s /t

Tests exercise all atlas crops, 180 fractional hand rotations, fixed pivots,
unmodified caller transforms, awake/AOD/wake rendering and shared data handling.
