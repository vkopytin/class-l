using Toybox.System;
using Toybox.Graphics;
using Toybox.Lang;

const ONE_RAD = Toybox.Math.PI * 2.0 / 60.0;

module srv {
    const graphItemsLength = 13;

    function min(a, b) { return a < b ? a : b; }

    function max(a, b) { return a > b ? a : b; }

    function summ7(a1, a2, a3, a4, a5, a6, a7, def) {
        return ((a1 == null || a1.data == null) ? def : a1.data) + ((a2 == null || a2.data == null) ? def : a2.data) +
               ((a3 == null || a3.data == null) ? def : a3.data) + ((a4 == null || a4.data == null) ? def : a4.data) +
               ((a5 == null || a5.data == null) ? def : a5.data) + ((a6 == null || a6.data == null) ? def : a6.data) +
               ((a7 == null || a7.data == null) ? def : a7.data);
    }

    function graphDataToArray(offsetX, offsetY, sample, items) {
        var max = sample.getMax();
        var min = sample.getMin();
        var diff = max - min;
        var height = cfg.graphHeight;
        var result = 0.0;
        if (sample != null) {
            // iterate over the samples and draw the graph
            var data = sample.next();
            var value = data.data;
            result = value;

            value = (self.summ7(data, sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                sample.next(), min) +
                     self.summ7(sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                sample.next(), sample.next(), min)) /
                    14.0;
            for (var i = 0; i < self.graphItemsLength; i++) {
                value = (value - min) * height / diff;
                var offset = offsetX - cfg.graphBarWidth * i;
                items[4 * i][0] = offset;
                items[4 * i][1] = offsetY;
                items[4 * i + 1][0] = offset;
                items[4 * i + 1][1] = offsetY - value;
                items[4 * i + 2][0] = offset + cfg.graphBarGap;
                items[4 * i + 2][1] = offsetY - value;
                items[4 * i + 3][0] = offset + cfg.graphBarGap;
                items[4 * i + 3][1] = offsetY;

                value = (srv.summ7(sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                   sample.next(), sample.next(), min) +
                         srv.summ7(sample.next(), sample.next(), sample.next(), sample.next(), sample.next(),
                                   sample.next(), sample.next(), min)) /
                        14.0;
            }
        }
        return result;
    }

}
