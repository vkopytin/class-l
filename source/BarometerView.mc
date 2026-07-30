import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

class BarometerView extends WatchUi.Drawable {
    private var label as WatchUi.Text?;
    private var text = "";
    private var barometerData = new[52] as Array<Graphics.Point2D>;
    private var color = Graphics.COLOR_PURPLE;
    private var sensor = :getPressureHistory;
    private var labelScale = 1.0;
    private var barWidth = 3;
    private var barGap = 2;
    private var lastHash = 0;
    private var forceRedraw = true;
    private var back = null as Graphics.BufferedBitmap;
    private var clearRect = [0, 0, 0, 0];

    function setLabel(label as WatchUi.Text or Null) { self.label = label; }

    function initialize(params) {

        Drawable.initialize(params as Lang.Dictionary);

        if (params.hasKey(:color)) {
            self.color = params.get(:color);
        }
        if (params.hasKey(:sensor)) {
            self.sensor = params.get(:sensor);
        }
        if (params.hasKey(:labelScale)) {
            self.labelScale = params.get(:labelScale);
        }
        if (params.hasKey(:barWidth)) {
            self.barWidth = params.get(:barWidth);
        }
        if (params.hasKey(:barGap)) {
            self.barGap = params.get(:barGap);
        }
        if (params.hasKey(:clearRect)) {
            self.clearRect = params.get(:clearRect);
        }
        for (var i = 0; i < 52; i++) {
            self.barometerData[i] = [locX, locY];
        }
    }

    public function setText(text as Lang.String) as Void {
        if (self.text.equals(text)) {
            return;
        }
        self.text = text;
        self.label.setText(text);
        self.forceRedraw = true;
    }
    function setBack(bb as Graphics.BufferedBitmap) { self.back = bb; }

    public function updateData() {
        if (Toybox has :SensorHistory) {
            if (Toybox.SensorHistory has self.sensor) {
                var items = new Method(Toybox.SensorHistory, self.sensor);
                var sample = items.invoke( {}) as Toybox.SensorHistory.SensorHistoryIterator;
                var value = self.graphDataToArray(self.locX, self.locY, sample, self.barometerData);
                self.label.setText((value / self.labelScale).format("%d"));
            }
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
        dc.fillPolygon(self.barometerData);
    }

    function graphDataToArray(offsetX, offsetY, sample, items) {
        var max = sample.getMax();
        var min = sample.getMin();
        var diff = max - min;
        var length = 13;
        var result = 0.0;
        var hash = 5381;
        if (sample != null) {
            // iterate over the samples and draw the graph
            var data = sample.next();
            var value = data.data;
            result = value;
            value = arraySumm(
                        [
                            data, sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                            sample.next(), sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                            sample.next(), sample.next()
                        ],
                        min) /
                    14.0;
            for (var i = 0; i < length; i++) {
                value = (value - min) * self.height / diff;
                hash = ((hash << 5) + hash) + value.toNumber();
                var x = offsetX - i;
                var y = offsetY - value;
                items[4 * i] = [offsetX - self.barWidth * i, offsetY];
                items[4 * i + 1] = [offsetX - self.barWidth * i, offsetY - value];
                items[4 * i + 2] = [offsetX - self.barWidth * i + self.barGap, offsetY - value];
                items[4 * i + 3] = [offsetX - self.barWidth * i + self.barGap, offsetY];
                value = arraySumm(
                            [
                                sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                sample.next(), sample.next(), sample.next(), sample.next()
                            ],
                            min) /
                        14.0;
            }

        }
        if (self.lastHash != hash) {
            self.lastHash = hash;
            self.forceRedraw = true;
        }

        return result;
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

}
