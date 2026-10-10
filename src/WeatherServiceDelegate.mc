import Toybox.Lang;
using Toybox.Background;
using Toybox.Communications;
using Toybox.System;
using Toybox.Position;
using Toybox.Activity;
using Toybox.Application;

(:background)
class WeatherServiceDelegate extends System.ServiceDelegate {
    function initialize() { ServiceDelegate.initialize(); }

    function onTemporalEvent() as Void {
        var latlon = [51.107, 17.038]; // Retrieve actual stored coordinates here
        var info = Position.getInfo();
        if (info != null && info.position != null) {
            latlon = info.position.toDegrees();
        }
        var actInfo = Activity.getActivityInfo();
        if (actInfo != null && actInfo.currentLocation != null) {
            latlon = actInfo.currentLocation.toDegrees();
        }
        var units = "metric";
        if (System.getDeviceSettings().temperatureUnits != System.UNIT_METRIC) {
            units = "imperial";
        }
        var apiKey = Application.Properties.getValue("owApiKey");
        if (apiKey == null || apiKey.equals("")) {
            return;
        }

        var url = "https://api.openweathermap.org/data/2.5/weather";
        var params = { "lat" => latlon[0], "lon" => latlon[1], "appid" => apiKey, "units" => units };
        var options = { :method => Communications.HTTP_REQUEST_METHOD_GET,
                        :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON };

        Communications.makeWebRequest(url, params, options, method(:onReceiveWeather));
    }

    function onReceiveWeather(responseCode as Number, data as Dictionary) as Void {
        if (responseCode == 200 && data != null) {
            var weatherData = { "temp" => data["main"]["temp"].toNumber(), "cond" => data["weather"][0]["id"] };
            Background.exit(weatherData); // Package and send payload back to App
        } else {
            Background.exit(null);
        }
    }
}
