# Instinct 3 AMOLED 50 mm (416x416)

Instinct 3 AMOLED 50 mm uses the shared renderer in `src-venu2-416x416`.
The resource compiler scales the original 454x454 bitmaps by 416/454 using
explicit rounded pixel dimensions in `drawables.xml`. Hand pivots, sprite
coordinates, clip sizes, and layout positions use the same scale.

Both always-on masks are scaled to 416x416. The status icon font is shared
with FR965; native text uses the device's system fonts. Fonts stay in build
resources and are not copied into `board/`.

This device has no enhanced graphics support. Every bitmap passed to
`drawBitmap2` (clock hands, weather, moon, and twilight atlases) sets
`automaticPalette="false"` to retain the native color format required by
cropping and transforms. The compiler's default automatic palette reduction
otherwise causes `Source must be native color format` at runtime. Background,
battery, and always-on masks use `drawBitmap`, so they retain palette reduction.

The shared 416x416 renderer clears the frame buffer to opaque black and paints
the complete dial before drawing text and sprites. This gives translucent
edges the actual dial colors to blend against, including outside the clock's
background redraw region.

Build with `monkeyc -f monkey.jungle -d instinct3amoled50mm -y <developer-key>
-o bin/instinct3amoled50mm-test.prg -t`, then run
`monkeydo bin/instinct3amoled50mm-test.prg instinct3amoled50mm /t`.
The shared tests cover atlas crops, hand transforms, full rendering, partial
updates, and always-on rendering.
