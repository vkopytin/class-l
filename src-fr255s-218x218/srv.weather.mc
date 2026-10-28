using Toybox.Weather;
using Toybox.Time;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Application;

module srv {

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
            self.drawWeatherIcon(dc, cfg.weatherX - 34, cfg.weatherY - 7, cfg.weatherX, self.color);
            self.drawTemperature(dc, cfg.weatherX + 2, cfg.weatherY - 5, false, self.color);
        }

        function drawWeatherIcon(dc, x, y, x2, fontColor) {
            if (self.weather == null) {
                dc.drawBitmap2(x - 8, y - 22, self.weatherConditions,
                               { :bitmapX => 8, :bitmapY => 20, :bitmapWidth => 34,
                                 :bitmapHeight => 34 });
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
                var tileCoordinates = [8, 22];
                switch (self.cond) {
                    case Weather.CONDITION_CLEAR:
                        tileCoordinates = [8, 22];
                        break;
                    case Weather.CONDITION_PARTLY_CLOUDY:
                        tileCoordinates = [67, 22];
                        break;
                    case Weather.CONDITION_MOSTLY_CLOUDY:
                        tileCoordinates = [122, 22];
                        break;
                    case Weather.CONDITION_RAIN:
                        tileCoordinates = [181, 22];
                        break;
                    case Weather.CONDITION_SNOW:
                        tileCoordinates = [235, 22];
                        break;
                    case Weather.CONDITION_WINDY:
                        tileCoordinates = [293, 23];
                        break;
                    case Weather.CONDITION_THUNDERSTORMS:
                        tileCoordinates = [347, 23];
                        break;
                    case Weather.CONDITION_WINTRY_MIX:
                        tileCoordinates = [402, 23];
                        break;
                    case Weather.CONDITION_FOG:
                        tileCoordinates = [459, 23];
                        break;
                    case Weather.CONDITION_HAZY:
                        tileCoordinates = [515, 23];
                        break;
                    case Weather.CONDITION_HAIL:
                        tileCoordinates = [8, 84];
                        break;
                    case Weather.CONDITION_SCATTERED_SHOWERS:
                        tileCoordinates = [64, 86];
                        break;
                    case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                        tileCoordinates = [122, 86];
                        break;
                    case Weather.CONDITION_UNKNOWN_PRECIPITATION:
                        tileCoordinates = [179, 86];
                        break;
                    case Weather.CONDITION_LIGHT_RAIN:
                        tileCoordinates = [236, 84];
                        break;
                    case Weather.CONDITION_HEAVY_RAIN:
                        tileCoordinates = [292, 84];
                        break;
                    case Weather.CONDITION_LIGHT_SNOW:
                        tileCoordinates = [347, 84];
                        break;
                    case Weather.CONDITION_HEAVY_SNOW:
                        tileCoordinates = [402, 84];
                        break;
                    case Weather.CONDITION_LIGHT_RAIN_SNOW:
                        tileCoordinates = [459, 85];
                        break;
                    case Weather.CONDITION_HEAVY_RAIN_SNOW:
                        tileCoordinates = [515, 85];
                        break;
                    case Weather.CONDITION_CLOUDY:
                        tileCoordinates = [8, 145];
                        break;
                    case Weather.CONDITION_RAIN_SNOW:
                        tileCoordinates = [64, 145];
                        break;
                    case Weather.CONDITION_PARTLY_CLEAR:
                        tileCoordinates = [122, 145];
                        break;
                    case Weather.CONDITION_MOSTLY_CLEAR:
                        tileCoordinates = [179, 145];
                        break;
                    case Weather.CONDITION_LIGHT_SHOWERS:
                        tileCoordinates = [236, 147];
                        break;
                    case Weather.CONDITION_SHOWERS:
                        tileCoordinates = [292, 144];
                        break;
                    case Weather.CONDITION_HEAVY_SHOWERS:
                        tileCoordinates = [347, 145];
                        break;
                    case Weather.CONDITION_CHANCE_OF_SHOWERS:
                        tileCoordinates = [402, 147];
                        break;
                    case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                        tileCoordinates = [459, 147];
                        break;
                    case Weather.CONDITION_MIST:
                        tileCoordinates = [515, 147];
                        break;
                    case Weather.CONDITION_DUST:
                        tileCoordinates = [8, 202];
                        break;
                    case Weather.CONDITION_DRIZZLE:
                        tileCoordinates = [64, 202];
                        break;
                    case Weather.CONDITION_TORNADO:
                        tileCoordinates = [122, 201];
                        break;
                    case Weather.CONDITION_SMOKE:
                        tileCoordinates = [179, 203];
                        break;
                    case Weather.CONDITION_ICE:
                        tileCoordinates = [236, 203];
                        break;
                    case Weather.CONDITION_SAND:
                        tileCoordinates = [288, 203];
                        break;
                    case Weather.CONDITION_SQUALL:
                        tileCoordinates = [345, 203];
                        break;
                    case Weather.CONDITION_SANDSTORM:
                        tileCoordinates = [402, 203];
                        break;
                    case Weather.CONDITION_VOLCANIC_ASH:
                        tileCoordinates = [459, 201];
                        break;
                    case Weather.CONDITION_HAZE:
                        tileCoordinates = [515, 203];
                        break;
                    case Weather.CONDITION_FAIR:
                        tileCoordinates = [8, 258];
                        break;
                    case Weather.CONDITION_HURRICANE:
                        tileCoordinates = [64, 258];
                        break;
                    case Weather.CONDITION_TROPICAL_STORM:
                        tileCoordinates = [122, 258];
                        break;
                    case Weather.CONDITION_CHANCE_OF_SNOW:
                        tileCoordinates = [179, 262];
                        break;
                    case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                        tileCoordinates = [235, 262];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                        tileCoordinates = [288, 262];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                        tileCoordinates = [345, 262];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                        tileCoordinates = [402, 262];
                        break;
                    case Weather.CONDITION_FLURRIES:
                        tileCoordinates = [459, 258];
                        break;
                    case Weather.CONDITION_FREEZING_RAIN:
                        tileCoordinates = [515, 258];
                        break;
                    case Weather.CONDITION_SLEET:
                        tileCoordinates = [8, 311];
                        break;
                    case Weather.CONDITION_ICE_SNOW:
                        tileCoordinates = [65, 311];
                        break;
                    case Weather.CONDITION_THIN_CLOUDS:
                        tileCoordinates = [122, 311];
                        break;
                    case Weather.CONDITION_UNKNOWN:
                    default:
                        tileCoordinates = [179, 311];
                }
                dc.drawBitmap2(x - tileCoordinates[0], y - tileCoordinates[1], self.weatherConditions,
                               { :bitmapX => tileCoordinates[0], :bitmapY => tileCoordinates[1],
                                 :bitmapWidth => 37, :bitmapHeight => 34 });

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
