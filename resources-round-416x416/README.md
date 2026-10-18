# 416x416 OLED resources

Venu 2 uses the FR965 OLED rendering path, adapted in `src-venu2-416x416`.
The resource compiler scales the original 454x454 bitmaps by 416/454 using
explicit rounded pixel dimensions in `drawables.xml`. Hand pivots, sprite
coordinates, clip sizes, and layout positions use the same scale.

Both always-on masks are scaled to 416x416. The status icon font is shared
with FR965; native text uses the Venu 2 system fonts. Fonts stay in build
resources and are not copied into `board/`.
