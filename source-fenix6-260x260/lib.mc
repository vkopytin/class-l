using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Weather;
using Toybox.System;

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
            var x = (i % 4) * 65 - dx;
            var y = (i / 4) * 65 - dy;
            dc.drawBitmap(x, y, WatchUi.loadResource(self.pieces[i]));
        }
    }

    function drawTextXTyni(dc as Graphics.Dc, x as Lang.Number, y as Lang.Number, value as Lang.String,
                           justification as Graphics.TextJustification) as Void {
        dc.drawText(x, y, Graphics.FONT_XTINY, value, justification);
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
        switch (condition) {
            case Weather.CONDITION_CLEAR: // clear sky
                return ["\uF00D", Rez.Fonts.weather1];
            case Weather.CONDITION_PARTLY_CLOUDY: // few clouds: 11-25%
                return ["\uF00C", Rez.Fonts.weather1];
            case Weather.CONDITION_MOSTLY_CLOUDY: // overcast clouds: 85-100%
                return ["\uF013", Rez.Fonts.weather2];
            case Weather.CONDITION_RAIN: // moderate rain
                return ["\uF008", Rez.Fonts.weather1];
            case Weather.CONDITION_SNOW: // snow
                return ["\uF01A", Rez.Fonts.weather2];
            case Weather.CONDITION_WINDY: // squalls
                return ["\uF082", Rez.Fonts.weather4];
            case Weather.CONDITION_THUNDERSTORMS: // thunderstorm with light rain
                return ["\uF01E", Rez.Fonts.weather2];
            case Weather.CONDITION_WINTRY_MIX: // sand/dust whirls
                return ["\uF063", Rez.Fonts.weather5];
            case Weather.CONDITION_FOG: // fog
                return ["\uF014", Rez.Fonts.weather2];
            case Weather.CONDITION_HAZY: // haze
                return ["\uF021", Rez.Fonts.weather3];
            case Weather.CONDITION_HAIL:
                return ["\uF014", Rez.Fonts.weather2];
            case Weather.CONDITION_SCATTERED_SHOWERS:
                return ["\uF008", Rez.Fonts.weather1];
            case Weather.CONDITION_SCATTERED_THUNDERSTORMS: // thunderstorm with light rain
                return ["\uF00E", Rez.Fonts.weather1];
            case Weather.CONDITION_UNKNOWN_PRECIPITATION:
                return ["\uF00D", Rez.Fonts.weather1];
            case Weather.CONDITION_LIGHT_RAIN: // light rain
                return ["\uF00A", Rez.Fonts.weather1];
            case Weather.CONDITION_HEAVY_RAIN: // heavy intensity rain
                return ["\uF019", Rez.Fonts.weather2];
            case Weather.CONDITION_LIGHT_SNOW: // light rain
                return ["\uF00A", Rez.Fonts.weather1];
            case Weather.CONDITION_HEAVY_SNOW: // heavy intensity rain
                return ["\uF019", Rez.Fonts.weather2];
            case Weather.CONDITION_LIGHT_RAIN_SNOW: // light intensity shower rain
                return ["\uF019", Rez.Fonts.weather2];
            case Weather.CONDITION_HEAVY_RAIN_SNOW:
                return ["\uF01C", Rez.Fonts.weather2];
            case Weather.CONDITION_CLOUDY: // overcast clouds: 85-100%
                return ["\uF013", Rez.Fonts.weather2];
            case Weather.CONDITION_RAIN_SNOW:
                return ["\uF01C", Rez.Fonts.weather2];
            case Weather.CONDITION_PARTLY_CLEAR:
                return ["\uF002", Rez.Fonts.weather1];
            case Weather.CONDITION_MOSTLY_CLEAR:
                return ["\uF041", Rez.Fonts.weather5];
            case Weather.CONDITION_LIGHT_SHOWERS:
                return ["\uF019", Rez.Fonts.weather2];
            case Weather.CONDITION_SHOWERS:
                return ["\uF018", Rez.Fonts.weather2];
            case Weather.CONDITION_HEAVY_SHOWERS:
                return ["\uF015", Rez.Fonts.weather2];
            case Weather.CONDITION_CHANCE_OF_SHOWERS:
                return ["\uF00A", Rez.Fonts.weather1];
            case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS: // thunderstorm with light rain
                return ["\uF016", Rez.Fonts.weather2];
            case Weather.CONDITION_MIST: // mist
                return ["\uF012", Rez.Fonts.weather2];
            case Weather.CONDITION_DUST:
                return ["\uF063", Rez.Fonts.weather5];
            case Weather.CONDITION_DRIZZLE:
                return ["\uF063", Rez.Fonts.weather5];
            case Weather.CONDITION_TORNADO:
                return ["\uF056", Rez.Fonts.weather4];
            case Weather.CONDITION_SMOKE:
                return ["\uF062", Rez.Fonts.weather5];
            case Weather.CONDITION_ICE:
                return ["\uF015", Rez.Fonts.weather2];
            case Weather.CONDITION_SAND:
                return ["\uF085", Rez.Fonts.weather5];
            case Weather.CONDITION_SQUALL:
                return ["\uF082", Rez.Fonts.weather4];
            case Weather.CONDITION_SANDSTORM:
                return ["\uF085", Rez.Fonts.weather5];
            case Weather.CONDITION_VOLCANIC_ASH:
                return ["\uF062", Rez.Fonts.weather5];
            case Weather.CONDITION_HAZE:
                return ["\uF021", Rez.Fonts.weather3];
            case Weather.CONDITION_FAIR:
                return ["\uF00C", Rez.Fonts.weather1];
            case Weather.CONDITION_HURRICANE:
                return ["\uF056", Rez.Fonts.weather4];
            case Weather.CONDITION_TROPICAL_STORM:
                return ["\uF01C", Rez.Fonts.weather2];
            case Weather.CONDITION_CHANCE_OF_SNOW:
                return ["\uF009", Rez.Fonts.weather1];
            case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                return ["\uF009", Rez.Fonts.weather1];
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                return ["\uF009", Rez.Fonts.weather1];
            case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                return ["\uF009", Rez.Fonts.weather1];
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                return ["\uF009", Rez.Fonts.weather1];
            case Weather.CONDITION_FLURRIES:
                return ["\uF021", Rez.Fonts.weather3];
            case Weather.CONDITION_FREEZING_RAIN:
                return ["\uF012", Rez.Fonts.weather2];
            case Weather.CONDITION_SLEET:
                return ["\uF017", Rez.Fonts.weather2];
            case Weather.CONDITION_ICE_SNOW:
                return ["\uF01C", Rez.Fonts.weather2];
            case Weather.CONDITION_THIN_CLOUDS:
                return ["\uF00C", Rez.Fonts.weather1];
            case Weather.CONDITION_UNKNOWN:
            default:
                return ["\uF00D", Rez.Fonts.weather1];
        }
    }

}
