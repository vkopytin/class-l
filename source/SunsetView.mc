import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

class SunsetView extends WatchUi.Drawable {
    private var sunriseTime = 25123.0;
    private var sunsetTime = 65123.0;
    private var arcRadius = 226;

    function setData(sunrise as Lang.Number, sunset as Lang.Number) {
        if (sunrise > sunset) {
            self.sunriseTime = sunset;
            self.sunsetTime = sunrise;
        } else {
            self.sunriseTime = sunrise;
            self.sunsetTime = sunset;
        }
    }

    function initialize(params) {
        Drawable.initialize(params);

        if (params.hasKey(:radius)) {
            self.arcRadius = params.get(:radius);
        }
    }

    function draw(dc as Dc) {

        Drawable.draw(dc);

        // sun set and sunrise arcs
        dc.setPenWidth(3);
        // night arc
        dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
        var sunriseAngle = 210 - 240 * self.sunriseTime / 86400.0;
        var sunsetAngle = 210 - 240 * self.sunsetTime / 86400.0;
        dc.drawArc(
            self.locX,
            self.locY,
            arcRadius,
            Graphics.ARC_CLOCKWISE,
            210,
            sunriseAngle
        );
        // day arc
        dc.setColor(0xFF5500, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
            self.locX,
            self.locY,
            arcRadius,
            Graphics.ARC_CLOCKWISE,
            sunriseAngle,
            sunsetAngle
        );
        // night arc
        dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
            self.locX,
            self.locY,
            arcRadius,
            Graphics.ARC_CLOCKWISE,
            sunsetAngle,
            -30
        );
    }
}
