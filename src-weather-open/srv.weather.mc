using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;

module srv {

    // Fenix 5 does not provide Toybox.Weather, so use the OpenWeather data
    // saved by WeatherServiceDelegate.
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
            var temp = Application.Storage.getValue("temp");
            var condition = Application.Storage.getValue("cond");

            if (temp != null && condition != null) {
                self.temperature = temp.format("%d");
                self.condInfo = self.conditionToIcon(condition, night);
                self.hasValue = true;
            }
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
            dc.drawText(x + dc.getTextWidthInPixels(self.temperature, Graphics.FONT_XTINY), y,
                        Graphics.FONT_XTINY, self.units, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }
}
