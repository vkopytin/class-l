using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;
using Toybox.Weather;

module srv {

    // Fenix 6 has Garmin Weather support; do not use the OpenWeather cache.
    module weather {
        var temperature = "24";
        var hasValue = false;
        var units = "°F";
        var condInfo = [];

        function update() as Void {
            self.units = System.getDeviceSettings().temperatureUnits == System.UNIT_METRIC ? "°C" : "°F";

            var clockTime = srv.digital.clockTime.hour + srv.digital.clockTime.min / 60.0 +
                            srv.digital.clockTime.sec / 3600.0;
            var night = clockTime >= srv.twilight.sunsetTime or clockTime < srv.twilight.sunriseTime;
            var cond = Weather.getCurrentConditions();
            if (cond == null) {
                return;
            }

            self.temperature = cond.temperature.format("%d");
            self.condInfo = self.conditionToIcon(cond.condition, night);
            self.hasValue = true;
        }

        function conditionToIcon(condition as Lang.Number, night as Lang.Boolean) as [Lang.String, Lang.ResourceId] {
            switch (condition) {
                case Weather.CONDITION_CLEAR:
                case Weather.CONDITION_UNKNOWN_PRECIPITATION:
                    return ["\uF00D", Rez.Fonts.weather1];
                case Weather.CONDITION_PARTLY_CLOUDY:
                case Weather.CONDITION_FAIR:
                case Weather.CONDITION_THIN_CLOUDS:
                    return ["\uF00C", Rez.Fonts.weather1];
                case Weather.CONDITION_MOSTLY_CLOUDY:
                case Weather.CONDITION_CLOUDY:
                    return ["\uF013", Rez.Fonts.weather2];
                case Weather.CONDITION_RAIN:
                case Weather.CONDITION_SCATTERED_SHOWERS:
                    return ["\uF008", Rez.Fonts.weather1];
                case Weather.CONDITION_SNOW:
                    return ["\uF01A", Rez.Fonts.weather2];
                case Weather.CONDITION_WINDY:
                case Weather.CONDITION_SQUALL:
                    return ["\uF082", Rez.Fonts.weather4];
                case Weather.CONDITION_THUNDERSTORMS:
                    return ["\uF01E", Rez.Fonts.weather2];
                case Weather.CONDITION_WINTRY_MIX:
                case Weather.CONDITION_DUST:
                case Weather.CONDITION_DRIZZLE:
                    return ["\uF063", Rez.Fonts.weather5];
                case Weather.CONDITION_FOG:
                case Weather.CONDITION_HAIL:
                    return ["\uF014", Rez.Fonts.weather2];
                case Weather.CONDITION_HAZY:
                case Weather.CONDITION_HAZE:
                case Weather.CONDITION_FLURRIES:
                    return ["\uF021", Rez.Fonts.weather3];
                case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                    return ["\uF00E", Rez.Fonts.weather1];
                case Weather.CONDITION_LIGHT_RAIN:
                case Weather.CONDITION_LIGHT_SNOW:
                case Weather.CONDITION_CHANCE_OF_SHOWERS:
                    return ["\uF00A", Rez.Fonts.weather1];
                case Weather.CONDITION_HEAVY_RAIN:
                case Weather.CONDITION_HEAVY_SNOW:
                case Weather.CONDITION_LIGHT_RAIN_SNOW:
                case Weather.CONDITION_LIGHT_SHOWERS:
                    return ["\uF019", Rez.Fonts.weather2];
                case Weather.CONDITION_HEAVY_RAIN_SNOW:
                case Weather.CONDITION_RAIN_SNOW:
                case Weather.CONDITION_TROPICAL_STORM:
                case Weather.CONDITION_ICE_SNOW:
                    return ["\uF01C", Rez.Fonts.weather2];
                case Weather.CONDITION_PARTLY_CLEAR:
                    return ["\uF002", Rez.Fonts.weather1];
                case Weather.CONDITION_MOSTLY_CLEAR:
                    return ["\uF041", Rez.Fonts.weather5];
                case Weather.CONDITION_SHOWERS:
                    return ["\uF018", Rez.Fonts.weather2];
                case Weather.CONDITION_HEAVY_SHOWERS:
                case Weather.CONDITION_ICE:
                    return ["\uF015", Rez.Fonts.weather2];
                case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                    return ["\uF016", Rez.Fonts.weather2];
                case Weather.CONDITION_MIST:
                case Weather.CONDITION_FREEZING_RAIN:
                    return ["\uF012", Rez.Fonts.weather2];
                case Weather.CONDITION_TORNADO:
                case Weather.CONDITION_HURRICANE:
                    return ["\uF056", Rez.Fonts.weather4];
                case Weather.CONDITION_SMOKE:
                case Weather.CONDITION_VOLCANIC_ASH:
                    return ["\uF062", Rez.Fonts.weather5];
                case Weather.CONDITION_SAND:
                case Weather.CONDITION_SANDSTORM:
                    return ["\uF085", Rez.Fonts.weather5];
                case Weather.CONDITION_CHANCE_OF_SNOW:
                case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                    return ["\uF009", Rez.Fonts.weather1];
                case Weather.CONDITION_SLEET:
                    return ["\uF017", Rez.Fonts.weather2];
                case Weather.CONDITION_UNKNOWN:
                default:
                    return ["\uF00D", Rez.Fonts.weather1];
            }
        }

        function draw(dc as Graphics.Dc) as Void {
            if (!self.hasValue) {
                return;
            }

            var x = cfg.weatherX - 20;
            var y = cfg.weatherY;
            if (condInfo.size() > 0) {
                dc.drawText(cfg.weatherX - 44, y, WatchUi.loadResource(condInfo[1]), condInfo[0],
                            Graphics.TEXT_JUSTIFY_LEFT);
            }

            dc.drawText(x, y, Graphics.FONT_XTINY, self.temperature, Graphics.TEXT_JUSTIFY_LEFT);
            dc.setColor(0x55AAAA, Graphics.COLOR_TRANSPARENT);
            dc.drawText(x + dc.getTextWidthInPixels(self.temperature, Graphics.FONT_XTINY), y, Graphics.FONT_XTINY,
                        self.units, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }
}
