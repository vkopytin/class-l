import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

class StepsView extends WatchUi.Drawable {
    private var label as WatchUi.Text?;
    private var stepsData = new[28] as Array<Graphics.Point2D>;
    private var color = Graphics.COLOR_PURPLE;
    private var labelScale = 1.0;
    private var lastHash = 0;
    private var forceRedraw = true;
    private var clearRect = [0, 0, 0, 0];
    private var back = null as Graphics.BufferedBitmap;

    function setLabel(label as WatchUi.Text or Null) { self.label = label; }
    function setBack(bb as Graphics.BufferedBitmap) { self.back = bb; }

    function initialize(params) {

        Drawable.initialize(params);

        if (params.hasKey(:color)) {
            self.color = params.get(:color);
        }
        if (params.hasKey(:labelScale)) {
            self.labelScale = params.get(:labelScale);
        }
        if (params.hasKey(:clearRect)) {
            self.clearRect = params.get(:clearRect);
        }

        for (var i = 0; i < 28; i++) {
            self.stepsData[i] = [0, 0];
        }
    }

    public function setText(text as Lang.String) as Void { self.label.setText(text); }

    public function updateData() {
        var value = self.stepsHistoryToArray(self.locX, self.locY, self.stepsData);
        self.label.setText((value).format("%d"));
        var activityMonitor = ActivityMonitor.getInfo();
        if (activityMonitor != null && activityMonitor.steps != null) {
            var steps = activityMonitor.steps;
            self.label.setText(steps.format("%d"));
        }
    }

    function draw(dc as Dc) {
        if (!self.forceRedraw) {
            return;
        }
        self.forceRedraw = false;

        Drawable.draw(dc);

        if (self.back == null) {
            dc.setPenWidth(1);
            dc.drawRectangle(self.clearRect[0], self.clearRect[1], self.clearRect[2], self.clearRect[3]);
        } else {
            dc.setClip(self.clearRect[0], self.clearRect[1], self.clearRect[2], self.clearRect[3]);
            dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
            dc.clear();
        }

        self.label.draw(dc);
        dc.setColor(self.color, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(self.stepsData);
    }

    function stepsHistoryToArray(offsetX, offsetY, items) {
        var history = ActivityMonitor.getHistory();
        var max = 10000;
        var length = self.min(items.size() / 4, history.size());
        var steps = history[0].steps;
        var hash = 5381;

        if (history != null) {
            for (var i = 0; i < length; i++) {
                var value = self.min(history[i].steps, max);
                value = value * self.height / max;
                hash = ((hash << 5) + hash) + value.toNumber();
                var x = offsetX - i;
                var y = offsetY - value;
                items[4 * i] = [offsetX - 5 * i, offsetY];
                items[4 * i + 1] = [offsetX - 5 * i, offsetY - value];
                items[4 * i + 2] = [offsetX - 5 * i + 3, offsetY - value];
                items[4 * i + 3] = [offsetX - 5 * i + 3, offsetY];
            }
            for (var i = length; i < items.size() / 4; i++) {
                items[4 * i] = [offsetX, offsetY];
                items[4 * i + 1] = [offsetX, offsetY];
                items[4 * i + 2] = [offsetX, offsetY];
                items[4 * i + 3] = [offsetX, offsetY];
            }
        }

        if (self.lastHash != hash) {
            self.lastHash = hash;
            self.forceRedraw = true;
        }

        return steps;
    }

    function arraySumm(array, def) {
        var sum = 0;
        for (var i = 0; i < array.size(); i++) {
            if (array[i] == null || array[i].data == null) {
                array[i] = def;
            } else {
                array[i] = array[i].data;
            }
            sum += array[i];
        }
        return sum;
    }

    function min(a, b) { return a < b ? a : b; }
}
