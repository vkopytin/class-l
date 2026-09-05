using Toybox.Graphics;
using Toybox.Lang;
using Toybox.ActivityMonitor;
using Toybox.WatchUi;

module srv {
    var stepsData = WatchUi.loadResource(Rez.JsonData.stepsData);

    module steps {
        // const stp = [1000, 4000, 11000, 2000, 3000, 6000, 1000];
        const maxStepsLevel = 10000;
        var stepsCount = "12345";

        function update() as Void {
            self.graphDataToArray(cfg.stepsX, cfg.stepsY, self.stepsData);
            var activityMonitor = ActivityMonitor.getInfo();
            self.stepsCount = activityMonitor.steps.format("%d");
        }

        function draw(dc as Graphics.Dc) as Void {
            dc.setColor(0x55AAAA, Graphics.COLOR_TRANSPARENT);
            dc.setClip(cfg.stepsX - cfg.graphWidth + cfg.graphBarWidth, cfg.stepsY - cfg.graphHeight, cfg.graphWidth,
                       cfg.graphHeight);
            dc.fillPolygon(self.stepsData);
            dc.clearClip();

            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            lib.drawTextXTyni(dc, cfg.stepsTextX, cfg.stepsTextY, self.stepsCount, Graphics.TEXT_JUSTIFY_CENTER);
        }

        function graphDataToArray(offsetX as Lang.Number, offsetY as Lang.Number, items as Lang.Array<Graphics.Point2D>)
            as Void {
            var history = ActivityMonitor.getHistory();
            var length = srv.min(items.size() / 4, history.size());
            var height = cfg.graphHeight;

            if (history != null) {
                for (var i = 0; i < length; i++) {
                    var value = self.min(history[i].steps, maxStepsLevel);
                    // var value = self.min(stp[i], maxStepsLevel);
                    value = value * height / maxStepsLevel;
                    var offset = offsetX - cfg.graphBarWidth * i;
                    items[4 * i] = [offset, offsetY];
                    items[4 * i + 1] = [offset, offsetY - value];
                    items[4 * i + 2] = [offset + cfg.graphBarGap, offsetY - value];
                    items[4 * i + 3] = [offset + cfg.graphBarGap, offsetY];
                }
                for (var i = length; i < items.size() / 4; i++) {
                    items[4 * i] = [offsetX, offsetY];
                    items[4 * i + 1] = [offsetX, offsetY];
                    items[4 * i + 2] = [offsetX, offsetY];
                    items[4 * i + 3] = [offsetX, offsetY];
                }
            }
        }
    }
}
