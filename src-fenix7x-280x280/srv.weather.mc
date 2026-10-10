using Toybox.Weather;
using Toybox.Time;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Application;

module srv {

    // Fenix 7 weather layout scaled to 280 pixels.
    module weather {
        var weatherConditions = WatchUi.loadResource(@Rez.Drawables.weatherConditions);
        var weather = null as Toybox.Weather.CurrentConditions;
        var cond = null as Toybox.Weather.Condition;
        var temperature = 0;
        var minTemp = 0;
        var maxTemp = 0;
        var color = 0x55AAAA;
        var font = Graphics.FONT_TINY;

        function update() as Void {
            var currentConditions = Toybox.Weather.getCurrentConditions();
            if (currentConditions == null) {
                return;
            }

            self.weather = currentConditions;
            self.cond = currentConditions.condition;
            self.temperature = currentConditions.temperature;
            self.minTemp = currentConditions.lowTemperature;
            self.maxTemp = currentConditions.highTemperature;
        }

        function draw(dc as Graphics.Dc) as Void {
            self.drawWeatherIcon(dc, cfg.weatherX - 43, cfg.weatherY - 9, cfg.weatherX, self.color);
            self.drawTemperature(dc, cfg.weatherX + 2, cfg.weatherY - 6, false, self.color);
        }

        function drawWeatherIcon(dc, x, y, x2, fontColor) {
            if (self.weather == null) {
                dc.drawBitmap2(x - 11, y - 28, self.weatherConditions,
                               { :bitmapX => 11, :bitmapY => 26, :bitmapWidth => 43,
                                 :bitmapHeight => 43 });
                return false;
            }
            var sunset, sunrise;
            var currentConditions = self.weather;

            if (self.cond != null and self.cond instanceof Number) {
                var clockTime = System.getClockTime().hour;

                var position = currentConditions.observationLocationPosition;
                var today = currentConditions.observationTime;

                if (position != null and today != null) {
                    if (Weather.getSunset(position, today) != null) {
                        sunset = Time.Gregorian.info(Weather.getSunset(position, today), Time.FORMAT_SHORT);
                        sunset = sunset.hour;
                    } else {
                        sunset = 18;
                    }
                    if (Weather.getSunrise(position, today) != null) {
                        sunrise = Time.Gregorian.info(Weather.getSunrise(position, today), Time.FORMAT_SHORT);
                        sunrise = sunrise.hour;
                    } else {
                        sunrise = 6;
                    }
                } else {
                    sunset = 18;
                    sunrise = 6;
                }

                // weather icon test
                // cond = Weather.CONDITION_UNKNOWN;
                var tileCoordinates = [11, 28];
                switch (self.cond) {
                    case Weather.CONDITION_CLEAR:
                        tileCoordinates = [11, 28];
                        break;
                    case Weather.CONDITION_PARTLY_CLOUDY:
                        tileCoordinates = [86, 28];
                        break;
                    case Weather.CONDITION_MOSTLY_CLOUDY:
                        tileCoordinates = [156, 28];
                        break;
                    case Weather.CONDITION_RAIN:
                        tileCoordinates = [233, 28];
                        break;
                    case Weather.CONDITION_SNOW:
                        tileCoordinates = [302, 28];
                        break;
                    case Weather.CONDITION_WINDY:
                        tileCoordinates = [377, 30];
                        break;
                    case Weather.CONDITION_THUNDERSTORMS:
                        tileCoordinates = [446, 29];
                        break;
                    case Weather.CONDITION_WINTRY_MIX:
                        tileCoordinates = [517, 29];
                        break;
                    case Weather.CONDITION_FOG:
                        tileCoordinates = [590, 29];
                        break;
                    case Weather.CONDITION_HAZY:
                        tileCoordinates = [661, 29];
                        break;
                    case Weather.CONDITION_HAIL:
                        tileCoordinates = [11, 108];
                        break;
                    case Weather.CONDITION_SCATTERED_SHOWERS:
                        tileCoordinates = [82, 110];
                        break;
                    case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                        tileCoordinates = [157, 110];
                        break;
                    case Weather.CONDITION_UNKNOWN_PRECIPITATION:
                        tileCoordinates = [230, 110];
                        break;
                    case Weather.CONDITION_LIGHT_RAIN:
                        tileCoordinates = [304, 108];
                        break;
                    case Weather.CONDITION_HEAVY_RAIN:
                        tileCoordinates = [375, 108];
                        break;
                    case Weather.CONDITION_LIGHT_SNOW:
                        tileCoordinates = [446, 108];
                        break;
                    case Weather.CONDITION_HEAVY_SNOW:
                        tileCoordinates = [517, 108];
                        break;
                    case Weather.CONDITION_LIGHT_RAIN_SNOW:
                        tileCoordinates = [590, 109];
                        break;
                    case Weather.CONDITION_HEAVY_RAIN_SNOW:
                        tileCoordinates = [661, 109];
                        break;
                    case Weather.CONDITION_CLOUDY:
                        tileCoordinates = [11, 186];
                        break;
                    case Weather.CONDITION_RAIN_SNOW:
                        tileCoordinates = [82, 186];
                        break;
                    case Weather.CONDITION_PARTLY_CLEAR:
                        tileCoordinates = [157, 186];
                        break;
                    case Weather.CONDITION_MOSTLY_CLEAR:
                        tileCoordinates = [230, 186];
                        break;
                    case Weather.CONDITION_LIGHT_SHOWERS:
                        tileCoordinates = [304, 188];
                        break;
                    case Weather.CONDITION_SHOWERS:
                        tileCoordinates = [375, 185];
                        break;
                    case Weather.CONDITION_HEAVY_SHOWERS:
                        tileCoordinates = [446, 186];
                        break;
                    case Weather.CONDITION_CHANCE_OF_SHOWERS:
                        tileCoordinates = [517, 188];
                        break;
                    case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                        tileCoordinates = [590, 188];
                        break;
                    case Weather.CONDITION_MIST:
                        tileCoordinates = [661, 188];
                        break;
                    case Weather.CONDITION_DUST:
                        tileCoordinates = [11, 260];
                        break;
                    case Weather.CONDITION_DRIZZLE:
                        tileCoordinates = [82, 260];
                        break;
                    case Weather.CONDITION_TORNADO:
                        tileCoordinates = [157, 258];
                        break;
                    case Weather.CONDITION_SMOKE:
                        tileCoordinates = [230, 261];
                        break;
                    case Weather.CONDITION_ICE:
                        tileCoordinates = [304, 261];
                        break;
                    case Weather.CONDITION_SAND:
                        tileCoordinates = [370, 261];
                        break;
                    case Weather.CONDITION_SQUALL:
                        tileCoordinates = [444, 261];
                        break;
                    case Weather.CONDITION_SANDSTORM:
                        tileCoordinates = [517, 261];
                        break;
                    case Weather.CONDITION_VOLCANIC_ASH:
                        tileCoordinates = [590, 258];
                        break;
                    case Weather.CONDITION_HAZE:
                        tileCoordinates = [661, 261];
                        break;
                    case Weather.CONDITION_FAIR:
                        tileCoordinates = [11, 332];
                        break;
                    case Weather.CONDITION_HURRICANE:
                        tileCoordinates = [82, 332];
                        break;
                    case Weather.CONDITION_TROPICAL_STORM:
                        tileCoordinates = [157, 332];
                        break;
                    case Weather.CONDITION_CHANCE_OF_SNOW:
                        tileCoordinates = [230, 336];
                        break;
                    case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                        tileCoordinates = [302, 336];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                        tileCoordinates = [370, 336];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                        tileCoordinates = [444, 336];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                        tileCoordinates = [517, 336];
                        break;
                    case Weather.CONDITION_FLURRIES:
                        tileCoordinates = [590, 332];
                        break;
                    case Weather.CONDITION_FREEZING_RAIN:
                        tileCoordinates = [661, 332];
                        break;
                    case Weather.CONDITION_SLEET:
                        tileCoordinates = [11, 400];
                        break;
                    case Weather.CONDITION_ICE_SNOW:
                        tileCoordinates = [83, 400];
                        break;
                    case Weather.CONDITION_THIN_CLOUDS:
                        tileCoordinates = [157, 400];
                        break;
                    case Weather.CONDITION_UNKNOWN:
                    default:
                        tileCoordinates = [230, 400];
                }
                dc.drawBitmap2(x - tileCoordinates[0], y - tileCoordinates[1], self.weatherConditions,
                               { :bitmapX => tileCoordinates[0], :bitmapY => tileCoordinates[1],
                                 :bitmapWidth => 47, :bitmapHeight => 44 });

                return true;
            } else {
                return false;
            }
        }

        function drawTemperature(dc, x, y, showBoolean, fontColor) {
            var TempMetric = System.getDeviceSettings().temperatureUnits;
            var temp = null, units = "", minTemp = null, maxTemp = null;
            if (self.weather == null) {
                return;
            }

            if ((weather.lowTemperature != null) and(weather.highTemperature != null)) {
                // and weather.lowTemperature instanceof Number ;  and
                // weather.highTemperature instanceof Number
                minTemp = weather.lowTemperature;
                maxTemp = weather.highTemperature;
            }

            var offset = 0;

            if (showBoolean ==
                false and(weather.feelsLikeTemperature != null)) { // feels like ;  and weather.feelsLikeTemperature
                                                                   // instanceof Number
                if (TempMetric == System.UNIT_METRIC or Storage.getValue(16) == true) { // Celsius
                    units = "°C"; // C
                    temp = weather.feelsLikeTemperature;
                } else {
                    temp = (weather.feelsLikeTemperature * 9 / 5) + 32;
                    if (minTemp != null and maxTemp != null) {
                        minTemp = (minTemp * 9 / 5) + 32;
                        maxTemp = (maxTemp * 9 / 5) + 32;
                    }
                    // temp = Lang.format("$1$", [temp.format("%d")] );
                    units = "°F"; // F
                }
            } else if ((weather.temperature != null)) {
                // real temperature ;  and weather.temperature
                // instanceof Number
                if (TempMetric == System.UNIT_METRIC or Storage.getValue(16) == true) { // Celsius
                    units = "°C"; // C
                    temp = weather.temperature;
                } else {
                    temp = (weather.temperature * 9 / 5) + 32;
                    if (minTemp != null and maxTemp != null) {
                        minTemp = (minTemp * 9 / 5) + 32;
                        maxTemp = (maxTemp * 9 / 5) + 32;
                    }
                    // temp = Lang.format("$1$", [temp.format("%d")] );
                    units = "°F"; // F
                }
            }

            if (temp != null) { // and temp instanceof Number
                dc.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
                if ((minTemp != null) and(maxTemp != null)) { //  and minTemp instanceof Number ;  and maxTemp
                                                              //  instanceof Number
                    if (temp <= minTemp) {
                        if (fontColor == Graphics.COLOR_WHITE) { // Dark Theme
                            dc.setColor(Graphics.COLOR_BLUE,
                                        Graphics.COLOR_TRANSPARENT); // Light Blue 0x55AAFF
                        } else { // Light Theme
                            dc.setColor(0x0055AA, Graphics.COLOR_TRANSPARENT);
                        }
                    } else if (temp >= maxTemp) {
                        if (fontColor == Graphics.COLOR_WHITE) { // Dark Theme
                            dc.setColor(0xFFAA00, Graphics.COLOR_TRANSPARENT); // Light Orange
                        } else { // Light Theme
                            dc.setColor(0xAA5500, Graphics.COLOR_TRANSPARENT);
                        }
                    }
                }

                temp = temp.format("%d");

                dc.drawText(x, y + offset, self.font, temp, Graphics.TEXT_JUSTIFY_LEFT);
                dc.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x + dc.getTextWidthInPixels(temp, self.font), y + offset, self.font, units,
                            Graphics.TEXT_JUSTIFY_LEFT);
            }
        }
    }
}
