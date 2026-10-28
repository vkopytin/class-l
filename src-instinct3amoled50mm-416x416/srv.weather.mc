using Toybox.Weather;
using Toybox.Time;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Application;

module srv {

    // FR965 weather rendering adapted to the scaled 416x416 sprite atlas.
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
            self.drawWeatherIcon(dc, cfg.weatherX - 46, cfg.weatherY - 7, cfg.weatherX, self.color);
            self.drawTemperature(dc, cfg.weatherX - 7, cfg.weatherY - 5, false, self.color);
        }

        function drawWeatherIcon(dc, x, y, x2, fontColor) {
            if (self.weather == null) {
                dc.drawBitmap2(x - 9, y - 24, self.weatherConditions,
                               { :bitmapX => 9, :bitmapY => 22, :bitmapWidth => 37,
                                 :bitmapHeight => 37 });
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
                var tileCoordinates = [9, 24];
                switch (self.cond) {
                    case Weather.CONDITION_CLEAR:
                        tileCoordinates = [9, 24];
                        break;
                    case Weather.CONDITION_PARTLY_CLOUDY:
                        tileCoordinates = [73, 24];
                        break;
                    case Weather.CONDITION_MOSTLY_CLOUDY:
                        tileCoordinates = [133, 24];
                        break;
                    case Weather.CONDITION_RAIN:
                        tileCoordinates = [198, 24];
                        break;
                    case Weather.CONDITION_SNOW:
                        tileCoordinates = [257, 24];
                        break;
                    case Weather.CONDITION_WINDY:
                        tileCoordinates = [321, 26];
                        break;
                    case Weather.CONDITION_THUNDERSTORMS:
                        tileCoordinates = [379, 25];
                        break;
                    case Weather.CONDITION_WINTRY_MIX:
                        tileCoordinates = [440, 25];
                        break;
                    case Weather.CONDITION_FOG:
                        tileCoordinates = [502, 25];
                        break;
                    case Weather.CONDITION_HAZY:
                        tileCoordinates = [563, 25];
                        break;
                    case Weather.CONDITION_HAIL:
                        tileCoordinates = [9, 92];
                        break;
                    case Weather.CONDITION_SCATTERED_SHOWERS:
                        tileCoordinates = [70, 93];
                        break;
                    case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                        tileCoordinates = [134, 93];
                        break;
                    case Weather.CONDITION_UNKNOWN_PRECIPITATION:
                        tileCoordinates = [196, 93];
                        break;
                    case Weather.CONDITION_LIGHT_RAIN:
                        tileCoordinates = [258, 92];
                        break;
                    case Weather.CONDITION_HEAVY_RAIN:
                        tileCoordinates = [319, 92];
                        break;
                    case Weather.CONDITION_LIGHT_SNOW:
                        tileCoordinates = [379, 92];
                        break;
                    case Weather.CONDITION_HEAVY_SNOW:
                        tileCoordinates = [440, 92];
                        break;
                    case Weather.CONDITION_LIGHT_RAIN_SNOW:
                        tileCoordinates = [502, 93];
                        break;
                    case Weather.CONDITION_HEAVY_RAIN_SNOW:
                        tileCoordinates = [563, 93];
                        break;
                    case Weather.CONDITION_CLOUDY:
                        tileCoordinates = [9, 159];
                        break;
                    case Weather.CONDITION_RAIN_SNOW:
                        tileCoordinates = [70, 159];
                        break;
                    case Weather.CONDITION_PARTLY_CLEAR:
                        tileCoordinates = [134, 159];
                        break;
                    case Weather.CONDITION_MOSTLY_CLEAR:
                        tileCoordinates = [196, 159];
                        break;
                    case Weather.CONDITION_LIGHT_SHOWERS:
                        tileCoordinates = [258, 160];
                        break;
                    case Weather.CONDITION_SHOWERS:
                        tileCoordinates = [319, 158];
                        break;
                    case Weather.CONDITION_HEAVY_SHOWERS:
                        tileCoordinates = [379, 159];
                        break;
                    case Weather.CONDITION_CHANCE_OF_SHOWERS:
                        tileCoordinates = [440, 160];
                        break;
                    case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                        tileCoordinates = [502, 160];
                        break;
                    case Weather.CONDITION_MIST:
                        tileCoordinates = [563, 160];
                        break;
                    case Weather.CONDITION_DUST:
                        tileCoordinates = [9, 221];
                        break;
                    case Weather.CONDITION_DRIZZLE:
                        tileCoordinates = [70, 221];
                        break;
                    case Weather.CONDITION_TORNADO:
                        tileCoordinates = [134, 220];
                        break;
                    case Weather.CONDITION_SMOKE:
                        tileCoordinates = [196, 222];
                        break;
                    case Weather.CONDITION_ICE:
                        tileCoordinates = [258, 222];
                        break;
                    case Weather.CONDITION_SAND:
                        tileCoordinates = [315, 222];
                        break;
                    case Weather.CONDITION_SQUALL:
                        tileCoordinates = [378, 222];
                        break;
                    case Weather.CONDITION_SANDSTORM:
                        tileCoordinates = [440, 222];
                        break;
                    case Weather.CONDITION_VOLCANIC_ASH:
                        tileCoordinates = [502, 220];
                        break;
                    case Weather.CONDITION_HAZE:
                        tileCoordinates = [563, 222];
                        break;
                    case Weather.CONDITION_FAIR:
                        tileCoordinates = [9, 282];
                        break;
                    case Weather.CONDITION_HURRICANE:
                        tileCoordinates = [70, 282];
                        break;
                    case Weather.CONDITION_TROPICAL_STORM:
                        tileCoordinates = [134, 282];
                        break;
                    case Weather.CONDITION_CHANCE_OF_SNOW:
                        tileCoordinates = [196, 286];
                        break;
                    case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                        tileCoordinates = [257, 286];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                        tileCoordinates = [315, 286];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                        tileCoordinates = [378, 286];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                        tileCoordinates = [440, 286];
                        break;
                    case Weather.CONDITION_FLURRIES:
                        tileCoordinates = [502, 282];
                        break;
                    case Weather.CONDITION_FREEZING_RAIN:
                        tileCoordinates = [563, 282];
                        break;
                    case Weather.CONDITION_SLEET:
                        tileCoordinates = [9, 340];
                        break;
                    case Weather.CONDITION_ICE_SNOW:
                        tileCoordinates = [71, 340];
                        break;
                    case Weather.CONDITION_THIN_CLOUDS:
                        tileCoordinates = [134, 340];
                        break;
                    case Weather.CONDITION_UNKNOWN:
                    default:
                        tileCoordinates = [196, 340];
                }
                dc.drawBitmap2(x - tileCoordinates[0], y - tileCoordinates[1], self.weatherConditions,
                               { :bitmapX => tileCoordinates[0], :bitmapY => tileCoordinates[1],
                                 :bitmapWidth => 41, :bitmapHeight => 38 });

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
