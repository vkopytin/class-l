using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Lang;

module srv {

    module battery {
        var batteryLevel = 0;

        function update() as Void {
            var stats = System.getSystemStats();

            self.batteryLevel = stats.battery;
        }

        function draw(dc as Graphics.Dc) as Void {
            var batteryLevelBitmap = WatchUi.loadResource(Rez.Drawables.batteryLevel);
            var barWidth = cfg.batteryWidth * self.batteryLevel / 100.0;
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.setClip(cfg.batteryX, cfg.batteryY, barWidth, cfg.batteryHeight);
            dc.drawBitmap(cfg.batteryX, cfg.batteryY, batteryLevelBitmap);
            dc.clearClip();

            var level = Lang.format("$1$%", [self.batteryLevel.format("%d")]);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            lib.drawTextXTyni(dc, cfg.batteryTextX, cfg.batteryTextY, level, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
