using Toybox.Lang;
using Toybox.Graphics;

module Gfx {
    function createAffineTransform() as Graphics.AffineTransform { return new Graphics.AffineTransform(); }
    function createBufferedBitmap(options as { :width as Lang.Number, :height as Lang.Number }) {
        return Graphics.createBufferedBitmap(options).get();
    }
    // OLED devices supply their always-on drawing in their device sources.
    (:gfx_no_aod)
    function drawAlwaysOn(dc as Graphics.Dc) as Void {}
}
