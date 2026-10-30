import Toybox.Graphics;
import Toybox.WatchUi;

module Gfx {
    function createAffineTransform() as Graphics.AffineTransform { return new Graphics.AffineTransform(); }
    function createBufferedBitmap(options) { return Graphics.createBufferedBitmap(options).get(); }
    function drawAlwaysOn(dc as Graphics.Dc) as Void {
        var resource = srv.digital.clockTime.min % 2 == 0 ? Rez.Drawables.aod : Rez.Drawables.aodAlt;
        dc.drawBitmap(0, 0, WatchUi.loadResource(resource));
    }
}
