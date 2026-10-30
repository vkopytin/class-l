using Toybox.Graphics;
using Toybox.WatchUi;

module Gfx {
    function drawAlwaysOn(dc as Graphics.Dc) as Void {
        if (srv.digital.clockTime.min % 2 == 0) {
            dc.drawBitmap(0, 0, WatchUi.loadResource(Rez.Drawables.aod));
        } else {
            dc.drawBitmap(0, 0, WatchUi.loadResource(Rez.Drawables.aodAlt));
        }
    }
}
