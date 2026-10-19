import Toybox.Graphics;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class VenuRenderTestView extends WatchFaceView {
    function initialize() { WatchFaceView.initialize(); }
    function engineTick(deltaTime) as Void {}
}

(:test)
function venuLegacyOledRendering(logger) {
    Test.assert(SensorHistory has :getPressureHistory);
    Test.assert(cfg.bufferWidth == 390 && cfg.bufferHeight == 390);
    // Only the view owns a full-sized buffer on this legacy device.
    var surface = Gfx.createBufferedBitmap({ :width => 1, :height => 1 });
    var dc = surface.getDc();
    var view = new VenuRenderTestView();
    view.onLayout(dc);
    view.onUpdate(dc);
    for (var phase = 0; phase < lib.moonTiles.size(); phase++) {
        lib.drawMoonPhaseTile(dc, phase / 25.0);
    }
    var twilightStates = [:night, :day, :evening, :morning, :twilight];
    for (var state = 0; state < twilightStates.size(); state++) {
        lib.drawTwilightTile(dc, twilightStates[state]);
    }
    for (var icon = 0; icon < lib.weatherTiles.size(); icon++) {
        var tile = lib.weatherTiles[icon];
        lib.drawWeatherTile(dc, 0, 0, [tile[1], tile[2]]);
    }
    for (var second = 0; second < 60; second++) {
        var transform = Gfx.createAffineTransform();
        transform.translate(cfg.minutesClockX, cfg.minutesClockY);
        transform.rotate(second * ONE_RAD);
        lib.drawHourHand(dc, { :transform => transform });
        lib.drawMinuteHand(dc, { :transform => transform });
        srv.seconds.synchronize(second);
        srv.seconds.draw(dc);
        view.onPartialUpdate(dc);
    }
    dc.clearClip();
    var masks = [Rez.Drawables.aod, Rez.Drawables.aodAlt];
    for (var index = 0; index < masks.size(); index++) {
        var mask = WatchUi.loadResource(masks[index]);
        Test.assert(mask.getWidth() == 390 && mask.getHeight() == 390);
        dc.drawBitmap(0, 0, mask);
    }
    view.onEnterSleep();
    view.onUpdate(dc);
    view.onHide();
    logger.debug("Venu pressure history available; rendered all icons, hands, partial updates, and AOD masks. Memory: " + System.getSystemStats().usedMemory);
    return true;
}
