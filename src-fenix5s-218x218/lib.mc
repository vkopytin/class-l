using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.System;

typedef DrawHandOptions as { :transform as Gfx.AffineTransform };

module lib {

    const pieces = [
        Rez.Drawables.bg_tl_tl, Rez.Drawables.bg_tl_tr, Rez.Drawables.bg_tr_tl, Rez.Drawables.bg_tr_tr,
        Rez.Drawables.bg_tl_bl, Rez.Drawables.bg_tl_br, Rez.Drawables.bg_tr_bl, Rez.Drawables.bg_tr_br,
        Rez.Drawables.bg_bl_tl, Rez.Drawables.bg_bl_tr, Rez.Drawables.bg_br_tl, Rez.Drawables.bg_br_tr,
        Rez.Drawables.bg_bl_bl, Rez.Drawables.bg_bl_br, Rez.Drawables.bg_br_bl, Rez.Drawables.bg_br_br
    ];

    const backgroundOffsets = [0, 55, 109, 164];

    function initialize() as Void {}

    function drawHourHand(dc as Graphics.Dc, options as DrawHandOptions) {
        var hourHandCoords = WatchUi.loadResource(Rez.JsonData.hourCoordinates);
        var coords = options[:transform].transformPoints(hourHandCoords) as Lang.Array<Graphics.Point2D>;

        dc.setColor(0x55AAAA, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(coords);

        coords = coords.slice(0, 6);
        dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(coords);

        dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        dc.drawCircle(cfg.minutesClockX, cfg.minutesClockY, 2);
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
        for (var i = 0; i < 16; i++) {
            var x = self.backgroundOffsets[i % 4] - dx;
            var y = self.backgroundOffsets[i / 4] - dy;
            dc.drawBitmap(x, y, WatchUi.loadResource(self.pieces[i]));
        }
    }

    function drawBackgroundAod(dc as Graphics.Dc, dx as Lang.Number, dy as Lang.Number) as Void {
        self.drawBackground(dc, dx, dy);
    }

    function drawTextXTiny(dc as Graphics.Dc, x as Lang.Number, y as Lang.Number, value as Lang.String,
                           justification as Graphics.TextJustification) as Void {
        var font = WatchUi.loadResource(Rez.Fonts.segoe);
        dc.drawText(x, y, font, value, justification);
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
