import Toybox.Graphics;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class Fr255sRenderTestView extends WatchFaceView {
    function initialize() { WatchFaceView.initialize(); }
    function engineTick(deltaTime) as Void {}
}

(:test)
function fr255sBitmapRendering(logger) {
    Test.assert(Graphics has :AffineTransform);
    Test.assert(SensorHistory has :getPressureHistory);
    Test.assert(cfg.bufferWidth == 218 && cfg.bufferHeight == 218);
    // The view owns the full frame buffer; use a tiny destination for the test.
    var surface = Gfx.createBufferedBitmap({ :width => 1, :height => 1 });
    var dc = surface.getDc();
    var background = WatchUi.loadResource(Rez.Drawables.background);
    Test.assert(background.getWidth() == 218 && background.getHeight() == 218);
    var battery = WatchUi.loadResource(Rez.Drawables.batteryLevel);
    Test.assert(battery.getWidth() == cfg.batteryWidth && battery.getHeight() == cfg.batteryHeight);
    var view = new Fr255sRenderTestView();
    view.onLayout(dc);
    view.onUpdate(dc);
    for (var phase = 0; phase < lib.moonTileCoords.size(); phase++) {
        lib.drawMoonPhaseTile(dc, phase / 25.0);
    }
    var twilightStates = [:night, :day, :evening, :morning, :twilight];
    for (var state = 0; state < twilightStates.size(); state++) {
        lib.drawTwilightTile(dc, twilightStates[state]);
    }
    for (var second = 0; second < 60; second++) {
        var transform = Gfx.createAffineTransform();
        transform.translate(cfg.minutesClockX, cfg.minutesClockY);
        transform.rotate(second * ONE_RAD);
        lib.drawHourHand(dc, { :transform => transform });
        transform.initialize();
        transform.translate(cfg.minutesClockX, cfg.minutesClockY);
        transform.rotate(second * ONE_RAD);
        lib.drawMinuteHand(dc, { :transform => transform });
        srv.seconds.synchronize(second);
        srv.seconds.draw(dc);
        view.onPartialUpdate(dc);
    }
    dc.clearClip();
    view.onEnterSleep();
    view.onUpdate(dc);
    view.onExitSleep();
    view.onUpdate(dc);
    view.onHide();
    var memory = System.getSystemStats().usedMemory;
    Test.assert(memory < 131072);
    logger.debug("FR255S rendered native 218x218 board artwork, sprites, 60 hand angles, sleep/wake; memory: " + memory);
    return true;
}
