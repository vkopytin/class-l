using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Activity;

module srv {
    module heartRate {

        var heartRateData = WatchUi.loadResource(Rez.JsonData.heartRateData);
        var heartRate = "60";

        function update() as Void {
            if (Toybox.SensorHistory has :getHeartRateHistory) {
                var sample = Toybox.SensorHistory.getHeartRateHistory( {});
                srv.graphDataToArray(cfg.heartRateX, cfg.heartRateY, sample, self.heartRateData);
            }
            var activityInfo = Activity.getActivityInfo();
            if (activityInfo != null && activityInfo.currentHeartRate != null) {
                self.heartRate = activityInfo.currentHeartRate.format("%d");
            }
        }

        function draw(dc as Graphics.Dc) as Void {
            // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            // dc.drawRectangle(cfg.heartRateX - 40 + cfg.graphBarWidth, cfg.heartRateY - cfg.graphHeight, 40,
            //                  cfg.graphHeight);
            dc.setColor(0xFF5500, Graphics.COLOR_TRANSPARENT);
            dc.setClip(cfg.heartRateX - cfg.graphWidth + cfg.graphBarWidth, cfg.heartRateY - cfg.graphHeight,
                       cfg.graphWidth, cfg.graphHeight);
            dc.fillPolygon(self.heartRateData);
            dc.clearClip();

            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cfg.heartRateTextX, cfg.heartRateTextY, Graphics.FONT_XTINY, self.heartRate,
                        Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
