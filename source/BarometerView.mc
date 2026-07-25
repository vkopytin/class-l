import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

class BarometerView extends WatchUi.Drawable {
    private var label as WatchUi.Text?;
    private var barometerData = new [52] as Array<Graphics.Point2D>;
    private var color = Graphics.COLOR_PURPLE;
    private var sensor = :getPressureHistory;
    private var labelScale = 1.0;

    function setLabel(label as WatchUi.Text or Null) {
        self.label = label;
    }

    function initialize(params) {

        Drawable.initialize(params);

        if (params.hasKey(:color)) {
            self.color = params.get(:color);
        }
        if (params.hasKey(:sensor)) {
            self.sensor = params.get(:sensor);
        }
        if (params.hasKey(:labelScale)) {
            self.labelScale = params.get(:labelScale);
        }

        for (var i = 0; i < 52; i++) {
            self.barometerData[i] = [locX, locY];
        }
    }

    public function setText(text as Lang.String) as Void {
        self.label.setText(text);
    }

    public function updateData() {
        if (Toybox has :SensorHistory) {
            if (Toybox.SensorHistory has self.sensor) {
                var items = new Method(Toybox.SensorHistory, self.sensor);
                var sample = items.invoke({}) as Toybox.SensorHistory.SensorHistoryIterator;
                var value = self.graphDataToArray(
                    self.locX, self.locY,
                    sample, self.barometerData
                );
                self.label.setText((value / self.labelScale).format("%d"));
            }
        }
    }

    function draw(dc as Dc) {

        Drawable.draw(dc);

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
        if (sample != null) {
            // iterate over the samples and draw the graph
            var data = sample.next();
            var value = data.data;
            result = value;
            value = arraySumm([
                data, sample.next(), sample.next(), sample.next(),
                sample.next(), sample.next(), sample.next(), sample.next(),
                sample.next(), sample.next(), sample.next(), sample.next(),
                sample.next(), sample.next()
            ], min) / 14.0;
            for (var i = 0; i < length; i++) {
                value = (value - min) * self.height / diff;
                var x = offsetX - i;
                var y = offsetY - value;
                items[4 * i] = [offsetX - 5 * i, offsetY];
                items[4 * i + 1] = [offsetX - 5 * i, offsetY - value];
                items[4 * i + 2] = [offsetX - 5 * i + 3, offsetY - value];
                items[4 * i + 3] = [offsetX - 5 * i + 3, offsetY];
                value = arraySumm([
                    sample.next(), sample.next(), sample.next(), sample.next(),
                    sample.next(), sample.next(), sample.next(), sample.next(),
                    sample.next(), sample.next(), sample.next(), sample.next(),
                    sample.next(), sample.next()
                ], min) / 14.0;
            }
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
