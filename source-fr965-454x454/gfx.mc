using Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;

module Gfx {
    function createAffineTransform() as Graphics.AffineTransform { return new Graphics.AffineTransform(); }
    function createBufferedBitmap(options as { :width as Lang.Number, :height as Lang.Number }) {
        return Graphics.createBufferedBitmap(options).get();
    }
    function drawAlwaysOn(dc as Graphics.Dc) as Void {
        if (srv.digital.clockTime.min % 2 == 0) {
            dc.drawBitmap(0, 0, WatchUi.loadResource(Rez.Drawables.aod));
        } else {
            dc.drawBitmap(0, 0, WatchUi.loadResource(Rez.Drawables.aodAlt));
        }
    }
}
