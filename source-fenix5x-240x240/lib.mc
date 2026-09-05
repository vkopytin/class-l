using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

module lib {

    const pieces = [
        Rez.Drawables.bg_tl_tl, Rez.Drawables.bg_tl_tr, Rez.Drawables.bg_tr_tl, Rez.Drawables.bg_tr_tr,
        Rez.Drawables.bg_tl_bl, Rez.Drawables.bg_tl_br, Rez.Drawables.bg_tr_bl, Rez.Drawables.bg_tr_br,
        Rez.Drawables.bg_bl_tl, Rez.Drawables.bg_bl_tr, Rez.Drawables.bg_br_tl, Rez.Drawables.bg_br_tr,
        Rez.Drawables.bg_bl_bl, Rez.Drawables.bg_bl_br, Rez.Drawables.bg_br_bl, Rez.Drawables.bg_br_br
    ];

    function initialize() as Void {

    }

    function drawHourHand(dc as Graphics.Dc, options as { :transform as Gfx.AffineTransform }) {
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

    function drawMinuteHand(dc as Graphics.Dc, options as { :transform as Gfx.AffineTransform }) {
        var minuteHandCoords = WatchUi.loadResource(Rez.JsonData.minuteCoordinates);
        var coords = options[:transform].transformPoints(minuteHandCoords) as Lang.Array<Graphics.Point2D>;

        dc.setColor(0x55AAAA, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(coords);

        coords = coords.slice(0, 6);
        dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(coords);
    }

    function drawSecondsHand(dc as Graphics.Dc, options as { :transform as Gfx.AffineTransform }) as Void {

        var transformedCoords = options[:transform].transformPoints(cfg.secondsHandCoordinates)
                                    as Lang.Array<Graphics.Point2D>;

        dc.setColor(0xFF5500, Graphics.COLOR_BLACK);
        dc.fillPolygon(transformedCoords);
    }

    function drawBackground(dc as Graphics.Dc, dx as Lang.Number, dy as Lang.Number) as Void {
        for (var i = 0; i < 16; i++) {
            var x = (i % 4) * 60 - dx;
            var y = (i / 4) * 60 - dy;
            dc.drawBitmap(x, y, WatchUi.loadResource(self.pieces[i]));
        }
    }

    function drawTextXTyni(dc as Graphics.Dc, x as Lang.Number, y as Lang.Number, value as Lang.String,
                           justification as Graphics.TextJustification) as Void {
        var font = WatchUi.loadResource(Rez.Fonts.segoe);
        dc.drawText(x, y, font, value, justification);
    }

    function drawMoonPhaseTile(dc as Graphics.Dc, phase as Lang.Float) as Void {
        var font = WatchUi.loadResource(Rez.Fonts.moonPhases);
        var tile = 61589 + (phase * 28).toNumber();
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

    function conditionToIcon(condition as Lang.Number, night as Lang.Boolean) as [Lang.String, Lang.ResourceId] {
        if (condition == 200 || condition == 201 || condition == 210 || condition == 221) {
            return ["\uF00E", Rez.Fonts.weather1];
        }
        if (condition == 202) {
            return ["\uF01E", Rez.Fonts.weather2];
        }
        if (condition == 211) {
            return ["\uF016", Rez.Fonts.weather2];
        }
        if (condition == 212) {
            return ["\uF005", Rez.Fonts.weather1];
        }
        if (condition == 230) {
            return ["\uF03A", Rez.Fonts.weather4];
        }
        if (condition == 231 || condition == 232) {
            return ["\uF01D", Rez.Fonts.weather2];
        }
        if (condition >= 300 && condition <= 310) {
            return ["\uF009", Rez.Fonts.weather1];
        }
        if (condition >= 311 && condition <= 314) {
            return ["\uF015", Rez.Fonts.weather2];
        }
        if (condition == 321 || condition == 500) {
            return ["\uF00A", Rez.Fonts.weather1];
        }
        if (condition == 501) {
            return ["\uF008", Rez.Fonts.weather1];
        }
        if (condition == 502 || condition == 503 || condition == 520 || condition == 522) {
            return ["\uF019", Rez.Fonts.weather2];
        }
        if (condition == 504 || condition == 531 || condition == 622) {
            return ["\uF015", Rez.Fonts.weather2];
        }
        if (condition == 511) {
            return ["\uF064", Rez.Fonts.weather5];
        }
        if (condition == 521) {
            return ["\uF018", Rez.Fonts.weather2];
        }
        if (condition == 600 || condition == 612) {
            return ["\uF01B", Rez.Fonts.weather2];
        }
        if (condition == 601 || condition == 611 || condition == 621) {
            return ["\uF01A", Rez.Fonts.weather2];
        }
        if (condition == 602 || condition == 616) {
            return ["\uF01C", Rez.Fonts.weather2];
        }
        if (condition == 613) {
            return ["\uF017", Rez.Fonts.weather2];
        }
        if (condition == 615) {
            return ["\uF018", Rez.Fonts.weather2];
        }
        if (condition == 620) {
            return ["\uF009", Rez.Fonts.weather1];
        }
        if (condition == 701) {
            return ["\uF012", Rez.Fonts.weather2];
        }
        if (condition == 711 || condition == 762) {
            return ["\uF062", Rez.Fonts.weather5];
        }
        if (condition == 721) {
            return ["\uF021", Rez.Fonts.weather3];
        }
        if (condition == 731 || condition == 761) {
            return ["\uF063", Rez.Fonts.weather5];
        }
        if (condition == 741) {
            return ["\uF014", Rez.Fonts.weather2];
        }
        if (condition == 751) {
            return ["\uF085", Rez.Fonts.weather5];
        }
        if (condition == 771) {
            return ["\uF082", Rez.Fonts.weather4];
        }
        if (condition == 781) {
            return ["\uF056", Rez.Fonts.weather4];
        }
        if (condition == 800) {
            return ["\uF00D", Rez.Fonts.weather1];
        }
        if (condition == 801) {
            return ["\uF00C", Rez.Fonts.weather1];
        }
        if (condition == 802) {
            return ["\uF002", Rez.Fonts.weather1];
        }
        if (condition == 803) {
            return ["\uF041", Rez.Fonts.weather5];
        }
        if (condition == 804) {
            return ["\uF013", Rez.Fonts.weather2];
        }
        return ["\uF00D", Rez.Fonts.weather1];
    }
}
