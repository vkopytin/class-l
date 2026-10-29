import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

module Gfx {
    function createAffineTransform() as Graphics.AffineTransform { return new Graphics.AffineTransform(); }

    function createBufferedBitmap(options as { :width as Number, :height as Number })
        as Graphics.BufferedBitmap {
        return Graphics.createBufferedBitmap(options).get();
    }

    function drawAlwaysOn(dc as Graphics.Dc) as Void {
        var resource = srv.digital.clockTime.min % 2 == 0 ? Rez.Drawables.aod : Rez.Drawables.aodAlt;
        dc.drawBitmap(0, 0, WatchUi.loadResource(resource));
    }
}
