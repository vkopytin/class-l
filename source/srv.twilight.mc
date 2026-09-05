using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Position;
using Toybox.Activity;
using Toybox.System;
using Toybox.Math;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;

module srv {

    module twilight {
        var twilightTile = :night;
        var sunriseTime = 5.0;
        var sunsetTime = 17.0;

        function update() as Void {
            var latlon = [0, 0];
            var info = Position.getInfo();
            if (info != null && info.position != null) {
                latlon = info.position.toDegrees();
            }
            var actInfo = Activity.getActivityInfo();
            if (actInfo != null && actInfo.currentLocation != null) {
                latlon = actInfo.currentLocation.toDegrees();
            }
            var now = Time.now();
            var date = Gregorian.info(now, Time.FORMAT_SHORT);

            self.sunriseTime = srv.twilight.computeSunTime(date, true, latlon[0], latlon[1]);
            self.sunsetTime = srv.twilight.computeSunTime(date, false, latlon[0], latlon[1]);

            var sunriseTime1 = srv.min(self.sunriseTime, self.sunsetTime);
            var sunsetTime1 = srv.max(self.sunriseTime, self.sunsetTime);
            var time = date.hour + date.min / 60.0 + date.sec / 3600.0;
            var beforeSunriseTime = sunriseTime1 - 1;
            var beforeSunsetTime = sunsetTime1 - 1;
            var afterSunSetTime = sunsetTime1 + 1;

            if (time < beforeSunriseTime) {
                self.twilightTile = :night;
            } else if (time < sunriseTime1) {
                self.twilightTile = :morning;
            } else if (time < beforeSunsetTime) {
                self.twilightTile = :day;
            } else if (time < sunsetTime1) {
                self.twilightTile = :evening;
            } else if (time < afterSunSetTime) {
                self.twilightTile = :twilight;
            } else {
                self.twilightTile = :night;
            }
        }

        function draw(dc as Graphics.Dc) as Void { lib.drawTwilightTile(dc, self.twilightTile); }

        // Calculates sunrise or sunset for a given day and location.
        // isSunrise: true for Sunrise, false for Sunset
        // lat: Latitude in degrees (Float)
        // lon: Longitude in degrees (Float)
        // returns: A Float representing the time of day in hours (UTC), or null if error.
        function computeSunTime(date as Gregorian.Info, isSunrise as Lang.Boolean, lat as Lang.Number,
                                lon as Lang.Number) as Lang.Float or Null {

            // 1. Calculate the day of the year (approximate N)
            var N = date.day; // Simplification for brevity; works best near current date.

            // 2. Convert longitude to hour value and estimate time
            var lngHour = lon / 15.0;
            var t;
            if (isSunrise) {
                t = N + ((6.0 - lngHour) / 24.0);
            } else {
                t = N + ((18.0 - lngHour) / 24.0);
            }

            // 3. Calculate Sun's mean anomaly (M) in radians
            var M = Math.toRadians((0.9856 * t) - 3.289);

            // 4. Calculate Sun's true longitude (L) in radians
            var L = M + Math.toRadians((1.916 * Math.sin(M)) + (0.020 * Math.sin(2.0 * M)) + 282.634);
            // Force L into 0-2PI range
            while (L < 0) {
                L += 2.0 * Math.PI;
            }
            while (L >= 2.0 * Math.PI) {
                L -= 2.0 * Math.PI;
            }

            // 5. Calculate Sun's right ascension (RA) in radians
            var RA = Math.atan(0.91764 * Math.tan(L));
            while (RA < 0) {
                RA += 2.0 * Math.PI;
            }
            while (RA >= 2.0 * Math.PI) {
                RA -= 2.0 * Math.PI;
            }

            // Adjust RA to be in the same quadrant as L
            var lQuadrant = Math.floor(L / (Math.PI / 2.0));
            var raQuadrant = Math.floor(RA / (Math.PI / 2.0));
            RA = RA + ((lQuadrant - raQuadrant) * (Math.PI / 2.0));
            RA = RA / Math.toRadians(15.0); // Convert to hours

            // 6. Calculate Sun's declination (sinDec and cosDec)
            var sinDec = 0.39782 * Math.sin(L);
            var cosDec = Math.cos(Math.asin(sinDec));

            // 7. Calculate Sun's local hour angle (H)
            // 90.833 degrees is the standard zenith for sunrise/sunset
            var cosH = (Math.cos(Math.toRadians(90.833)) - (sinDec * Math.sin(Math.toRadians(lat)))) /
                       (cosDec * Math.cos(Math.toRadians(lat)));

            // Check for midnight sun or polar night
            if (cosH > 1.0 || cosH < -1.0) {
                return null;
            }

            // 8. Calculate H and convert to hours
            var H;
            if (isSunrise) {
                H = 360.0 - Math.toDegrees(Math.acos(cosH));
            } else {
                H = Math.toDegrees(Math.acos(cosH));
            }
            H = H / 15.0;

            // 9. Calculate local mean time of rising/setting
            var T = H + RA - (0.06571 * t) - 6.622;

            // 10. Adjust back to UTC time
            var utctime = T - lngHour;
            while (utctime < 0) {
                utctime += 24.0;
            }
            while (utctime >= 24.0) {
                utctime -= 24.0;
            }

            return utctime;
        }

    }
}
