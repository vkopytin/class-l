using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.System;

typedef DrawHandOptions as { :transform as Gfx.AffineTransform };

module lib {
    function initialize() as Void {

    }

    function drawHourHand(dc as Graphics.Dc, options as DrawHandOptions) {
        var hourHandCoords = WatchUi.loadResource(Rez.JsonData.hourCoordinates);
        var coords = options[:transform].transformPoints(hourHandCoords) as Lang.Array<Graphics.Point2D>;

        dc.setColor(0x55AAAA, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(coords);

        coords = coords.slice(0, 6);
        dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(coords);

        dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
        dc.drawCircle(cfg.minutesClockX, cfg.minutesClockY, 3);
    }

    function drawMinuteHand(dc as Graphics.Dc, options as DrawHandOptions) {
        var minuteHandCoords = WatchUi.loadResource(Rez.JsonData.minuteCoordinates);
        var coords = options[:transform].transformPoints(minuteHandCoords) as Lang.Array<Graphics.Point2D>;

        dc.setColor(0x55AAAA, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(coords);

        coords = coords.slice(0, 6);
        dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(coords);
    }

    function drawSecondsHand(dc as Graphics.Dc, options as DrawHandOptions) as Void {

        var transformedCoords = options[:transform].transformPoints(cfg.secondsHandCoordinates)
                                    as Lang.Array<Graphics.Point2D>;

        dc.setColor(0xFF5500, Graphics.COLOR_BLACK);
        dc.fillPolygon(transformedCoords);
    }

    function setBackgroundColor(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    }

    function drawBackground(dc as Graphics.Dc, dx as Lang.Number, dy as Lang.Number) as Void {
        dc.drawBitmap(0, 0, WatchUi.loadResource(Rez.Drawables.background));
    }

    function drawBackgroundAod(dc as Graphics.Dc, dx as Lang.Number, dy as Lang.Number) as Void {
        self.drawBackground(dc, dx, dy);
    }

    function drawTextXTiny(dc as Graphics.Dc, x as Lang.Number, y as Lang.Number, value as Lang.String,
                           justification as Graphics.TextJustification) as Void {
        dc.drawText(x, y, Graphics.FONT_XTINY, value, justification);
    }

    function drawMoonPhaseTile(dc as Graphics.Dc, phase as Lang.Float) as Void {
        var font = WatchUi.loadResource(Rez.Fonts.moonPhases);
        var tile = 61590 + (phase * 26).toNumber();
        dc.setColor(0xFFAA00, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cfg.moonPhaseX, cfg.moonPhaseY, font, tile.toChar(), Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawTwilightTile(dc as Graphics.Dc, twilightTile as Lang.Symbol) as Void {
        var x = cfg.twilightX;
        var y = cfg.twilightY;
        var font = WatchUi.loadResource(Rez.Fonts.twilight);
        var value = (61453).toChar();
        var color = 0xFFAA00;
        if (twilightTile == :night) {
            color = 0xAAAAFF;
            value = (61559).toChar();
        } else if (twilightTile == :day) {
            color = 0xFFAA00;
            value = (61453).toChar();
        } else if (twilightTile == :evening) {
            color = 0xFFAA00;
            value = (61511).toChar();
        } else if (twilightTile == :morning) {
            color = 0xFF5500;
            value = (61510).toChar();
        } else if (twilightTile == :twilight) {
            color = 0xAA5500;
            value = (61539).toChar();
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, value, Graphics.TEXT_JUSTIFY_CENTER);
    }


}
