# Native hands for 390 x 390 devices

Epix Pro 42 mm and its device aliases use the original 454 x 454 hand
artwork, scaled by 390/454 and rotated with bilinear filtering. This preserves
the source alpha edges and avoids the seams of separately smoothed polygon
strips. The original Venu retains its software polygon renderer.

The source pivots are (13, 66), (10, 88), and (8, 92) for the hour, minute,
and second hands. `lib.drawHand` uses a separate cached native transform so
drawing never changes the caller's transform used for partial-update clipping.
