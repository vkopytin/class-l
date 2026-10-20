# Forerunner 255S (218x218)

Uses the Fenix 7 native bitmap renderer: `Graphics.AffineTransform`,
`drawBitmap2`, and `Graphics.createBufferedBitmap` with a full 218x218 buffer.
The installed FR255S SDK profile provides API 5.2 and a 128 KiB watchface budget.

The background and 29x9 battery bitmap reference `board/218x218` directly,
without resizing. Hands, weather, moon, and twilight bitmaps are scaled from
Fenix 7 by 218/260 in `drawables.xml`, with matching coordinates and hand pivots
in `src-fr255s-218x218`. Status icons reuse the Fenix 7 font.
