using Toybox.Weather;
using Toybox.Time;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Application;

module srv {

    // FR965 weather layout with individual bitmap icons for Venu API 3.3.
    module weather {

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
            self.drawWeatherIcon(dc, cfg.weatherX - 43, cfg.weatherY - 7, cfg.weatherX, self.color);
            self.drawTemperature(dc, cfg.weatherX - 7, cfg.weatherY - 5, false, self.color);
        }

        function drawWeatherIcon(dc, x, y, x2, fontColor) {
            if (self.weather == null) {
                lib.drawWeatherTile(dc, x, y - 1, [9, 21]);
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
                var tileCoordinates = [9, 22];
                switch (self.cond) {
                    case Weather.CONDITION_CLEAR:
                        tileCoordinates = [9, 22];
                        break;
                    case Weather.CONDITION_PARTLY_CLOUDY:
                        tileCoordinates = [69, 22];
                        break;
                    case Weather.CONDITION_MOSTLY_CLOUDY:
                        tileCoordinates = [125, 22];
                        break;
                    case Weather.CONDITION_RAIN:
                        tileCoordinates = [186, 22];
                        break;
                    case Weather.CONDITION_SNOW:
                        tileCoordinates = [241, 22];
                        break;
                    case Weather.CONDITION_WINDY:
                        tileCoordinates = [301, 24];
                        break;
                    case Weather.CONDITION_THUNDERSTORMS:
                        tileCoordinates = [356, 23];
                        break;
                    case Weather.CONDITION_WINTRY_MIX:
                        tileCoordinates = [412, 23];
                        break;
                    case Weather.CONDITION_FOG:
                        tileCoordinates = [471, 23];
                        break;
                    case Weather.CONDITION_HAZY:
                        tileCoordinates = [527, 23];
                        break;
                    case Weather.CONDITION_HAIL:
                        tileCoordinates = [9, 86];
                        break;
                    case Weather.CONDITION_SCATTERED_SHOWERS:
                        tileCoordinates = [65, 88];
                        break;
                    case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                        tileCoordinates = [125, 88];
                        break;
                    case Weather.CONDITION_UNKNOWN_PRECIPITATION:
                        tileCoordinates = [184, 88];
                        break;
                    case Weather.CONDITION_LIGHT_RAIN:
                        tileCoordinates = [242, 86];
                        break;
                    case Weather.CONDITION_HEAVY_RAIN:
                        tileCoordinates = [299, 86];
                        break;
                    case Weather.CONDITION_LIGHT_SNOW:
                        tileCoordinates = [356, 86];
                        break;
                    case Weather.CONDITION_HEAVY_SNOW:
                        tileCoordinates = [412, 86];
                        break;
                    case Weather.CONDITION_LIGHT_RAIN_SNOW:
                        tileCoordinates = [471, 87];
                        break;
                    case Weather.CONDITION_HEAVY_RAIN_SNOW:
                        tileCoordinates = [527, 87];
                        break;
                    case Weather.CONDITION_CLOUDY:
                        tileCoordinates = [9, 149];
                        break;
                    case Weather.CONDITION_RAIN_SNOW:
                        tileCoordinates = [65, 149];
                        break;
                    case Weather.CONDITION_PARTLY_CLEAR:
                        tileCoordinates = [125, 149];
                        break;
                    case Weather.CONDITION_MOSTLY_CLEAR:
                        tileCoordinates = [184, 149];
                        break;
                    case Weather.CONDITION_LIGHT_SHOWERS:
                        tileCoordinates = [242, 150];
                        break;
                    case Weather.CONDITION_SHOWERS:
                        tileCoordinates = [299, 148];
                        break;
                    case Weather.CONDITION_HEAVY_SHOWERS:
                        tileCoordinates = [356, 149];
                        break;
                    case Weather.CONDITION_CHANCE_OF_SHOWERS:
                        tileCoordinates = [412, 150];
                        break;
                    case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                        tileCoordinates = [471, 150];
                        break;
                    case Weather.CONDITION_MIST:
                        tileCoordinates = [527, 150];
                        break;
                    case Weather.CONDITION_DUST:
                        tileCoordinates = [9, 207];
                        break;
                    case Weather.CONDITION_DRIZZLE:
                        tileCoordinates = [65, 207];
                        break;
                    case Weather.CONDITION_TORNADO:
                        tileCoordinates = [125, 206];
                        break;
                    case Weather.CONDITION_SMOKE:
                        tileCoordinates = [184, 208];
                        break;
                    case Weather.CONDITION_ICE:
                        tileCoordinates = [242, 208];
                        break;
                    case Weather.CONDITION_SAND:
                        tileCoordinates = [296, 208];
                        break;
                    case Weather.CONDITION_SQUALL:
                        tileCoordinates = [354, 208];
                        break;
                    case Weather.CONDITION_SANDSTORM:
                        tileCoordinates = [412, 208];
                        break;
                    case Weather.CONDITION_VOLCANIC_ASH:
                        tileCoordinates = [471, 206];
                        break;
                    case Weather.CONDITION_HAZE:
                        tileCoordinates = [527, 208];
                        break;
                    case Weather.CONDITION_FAIR:
                        tileCoordinates = [9, 265];
                        break;
                    case Weather.CONDITION_HURRICANE:
                        tileCoordinates = [65, 265];
                        break;
                    case Weather.CONDITION_TROPICAL_STORM:
                        tileCoordinates = [125, 265];
                        break;
                    case Weather.CONDITION_CHANCE_OF_SNOW:
                        tileCoordinates = [184, 268];
                        break;
                    case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                        tileCoordinates = [241, 268];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                        tileCoordinates = [296, 268];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                        tileCoordinates = [354, 268];
                        break;
                    case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                        tileCoordinates = [412, 268];
                        break;
                    case Weather.CONDITION_FLURRIES:
                        tileCoordinates = [471, 265];
                        break;
                    case Weather.CONDITION_FREEZING_RAIN:
                        tileCoordinates = [527, 265];
                        break;
                    case Weather.CONDITION_SLEET:
                        tileCoordinates = [9, 319];
                        break;
                    case Weather.CONDITION_ICE_SNOW:
                        tileCoordinates = [66, 319];
                        break;
                    case Weather.CONDITION_THIN_CLOUDS:
                        tileCoordinates = [125, 319];
                        break;
                    case Weather.CONDITION_UNKNOWN:
                    default:
                        tileCoordinates = [184, 319];
                }
                lib.drawWeatherTile(dc, x, y, tileCoordinates);

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
                    units = "\u00B0C"; // C
                    temp = weather.feelsLikeTemperature;
                } else {
                    temp = (weather.feelsLikeTemperature * 9 / 5) + 32;
                    if (minTemp != null and maxTemp != null) {
                        minTemp = (minTemp * 9 / 5) + 32;
                        maxTemp = (maxTemp * 9 / 5) + 32;
                    }
                    // temp = Lang.format("$1$", [temp.format("%d")] );
                    units = "\u00B0F"; // F
                }
            } else if ((weather.temperature != null)) {
                // real temperature ;  and weather.temperature
                // instanceof Number
                if (TempMetric == System.UNIT_METRIC or Storage.getValue(16) == true) { // Celsius
                    units = "\u00B0C"; // C
                    temp = weather.temperature;
                } else {
                    temp = (weather.temperature * 9 / 5) + 32;
                    if (minTemp != null and maxTemp != null) {
                        minTemp = (minTemp * 9 / 5) + 32;
                        maxTemp = (maxTemp * 9 / 5) + 32;
                    }
                    // temp = Lang.format("$1$", [temp.format("%d")] );
                    units = "\u00B0F"; // F
                }
            }

            if (temp != null) { // and temp instanceof Number
                dc.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
                if ((minTemp != null) and(maxTemp != null)) { //  and minTemp instanceof Number ;  and maxTemp
                                                              //  instanceof Number
                    if (temp <= minTemp) {
                        if (fontColor == Graphics.COLOR_WHITE) { // Dark Theme
                            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT); // Light Blue 0x55AAFF
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

                var font = lib.textFont(self.font);
                dc.drawText(x, y + offset, font, temp, Graphics.TEXT_JUSTIFY_LEFT);
                dc.setColor(fontColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x + dc.getTextWidthInPixels(temp, font), y + offset, font, units,
                            Graphics.TEXT_JUSTIFY_LEFT);
            }
        }
    }
}
