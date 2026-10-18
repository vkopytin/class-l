# Fenix 9 Pro 51mm resources (466x466)

Uses the FR965 OLED rendering logic and original bitmap assets. The
resource compiler scales each bitmap by 466/454 using explicit rounded
pixel dimensions. The background and both always-on masks are 466x466.
Layout positions, hand pivots, atlas coordinates, and crop sizes use
the same scale in src-fenix9pro51mm-466x466.

The status icon font is shared with FR965; other text uses the device's
native fonts. Fonts stay in build resources and are not added to board/.
