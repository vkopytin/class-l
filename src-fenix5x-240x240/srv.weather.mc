using Toybox.Application;
using Toybox.Graphics;
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
                self.condInfo = lib.conditionToIcon(condition, night);
                self.hasValue = true;
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
            dc.drawText(x + dc.getTextWidthInPixels(self.temperature, Graphics.FONT_XTINY), y,
                        Graphics.FONT_XTINY, self.units, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }
}
