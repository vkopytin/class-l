import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Test;

(:test)
class GraphHistorySample {
    var data;
    function initialize(value) { self.data = value; }
}

(:test)
class GraphHistoryIterator {
    var minimum;
    var maximum;
    var values;
    var index = 0;

    function initialize(minimum, maximum, values) {
        self.minimum = minimum;
        self.maximum = maximum;
        self.values = values;
    }

    function getMin() { return self.minimum; }
    function getMax() { return self.maximum; }
    function next() {
        if (self.index >= self.values.size()) {
            return null;
        }
        var value = self.values[self.index];
        self.index += 1;
        return new GraphHistorySample(value);
    }
}

(:test)
class GraphHistoryPoints {
    var points = [] as Array<Graphics.Point2D>;

    function initialize() {
        for (var i = 0; i < srv.graphItemsLength * 4; i++) {
            self.points.add([0, 0]);
        }
    }
}

(:test)
function graphHistoryUnavailableBounds(logger) {
    var fixture = new GraphHistoryPoints();
    var points = fixture.points;
    // Unavailable history leaves the cached graph intact, like a null iterator.
    points[0][0] = 123;
    Test.assert(srv.graphDataToArray(50, 50, null, points) == 1);
    var bounds = [[null, null], [null, 100], [60, null]];
    for (var i = 0; i < bounds.size(); i++) {
        var history = new GraphHistoryIterator(bounds[i][0], bounds[i][1], []);
        Test.assert(srv.graphDataToArray(50, 50, history, points) == 1);
        Test.assert(history.index == 0);
        Test.assert(points[0][0] == 123);
    }
    return true;
}

(:test)
function graphHistoryConstantAndExhausted(logger) {
    var fixture = new GraphHistoryPoints();
    var points = fixture.points;
    var history = new GraphHistoryIterator(60, 60, [60]);
    Test.assert(srv.graphDataToArray(50, 50, history, points) == 60);
    for (var i = 0; i < srv.graphItemsLength; i++) {
        Test.assert(points[4 * i][0] == 50 - cfg.graphBarWidth * i);
        Test.assert(points[4 * i + 1][1] == 50);
        Test.assert(points[4 * i + 2][1] == 50);
    }
    return true;
}

(:test)
function graphHistorySparseSamples(logger) {
    var fixture = new GraphHistoryPoints();
    var points = fixture.points;
    // The first bar averages 14 samples; missing samples use the minimum.
    var history = new GraphHistoryIterator(60, 88, [88, null]);
    Test.assert(srv.graphDataToArray(50, 50, history, points) == 88);
    var expectedY = 50 - cfg.graphHeight / 14.0;
    var difference = points[1][1] - expectedY;
    Test.assert(difference > -0.001 && difference < 0.001);
    Test.assert(points[5][1] == 50);
    return true;
}

(:test)
function graphHistoryValidRange(logger) {
    var fixture = new GraphHistoryPoints();
    var points = fixture.points;
    var values = [];
    for (var i = 0; i < 14; i++) {
        values.add(88);
    }
    var history = new GraphHistoryIterator(60, 88, values);
    Test.assert(srv.graphDataToArray(50, 50, history, points) == 88);
    Test.assert(points[1][1] == 50 - cfg.graphHeight);
    Test.assert(points[2][0] == 50 + cfg.graphBarGap);
    Test.assert(points[5][1] == 50);
    return true;
}
