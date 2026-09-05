using Toybox.Graphics;
using Toybox.WatchUi;

module srv {

    module barometer {
        var barometerLevel = "1000";

        var barometerData = WatchUi.loadResource(Rez.JsonData.barometerData);

        function update() as Void {
            if (Toybox.SensorHistory has :getPressureHistory) {
                var sample = Toybox.SensorHistory.getPressureHistory( {});
                var value = srv.graphDataToArray(cfg.barometerX, cfg.barometerY, sample, self.barometerData);
                self.barometerLevel = (value * 0.1).format("%d");
            }
        }

        function draw(dc as Graphics.Dc) as Void {
            // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            // dc.drawRectangle(cfg.barometerX - 40 + cfg.graphBarWidth, cfg.barometerY - cfg.graphHeight, 40,
            //                  cfg.graphHeight);
            dc.setColor(0x55AAAA, Graphics.COLOR_TRANSPARENT);
            dc.setClip(cfg.barometerX - cfg.graphWidth + cfg.graphBarWidth, cfg.barometerY - cfg.graphHeight,
                       cfg.graphWidth, cfg.graphHeight);
            dc.fillPolygon(self.barometerData);
            dc.clearClip();

            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            lib.drawTextXTyni(dc, cfg.barometerTextX, cfg.barometerTextY, self.barometerLevel,
                              Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
