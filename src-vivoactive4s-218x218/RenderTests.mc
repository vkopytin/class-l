import Toybox.Graphics;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class Vivoactive4sRenderTestView extends WatchFaceView {
    function initialize() { WatchFaceView.initialize(); }
    function engineTick(deltaTime) as Void {}
}

(:test)
function vivoactive4sLowMemoryRendering(logger) {
    Test.assert(SensorHistory has :getPressureHistory);
    Test.assert(cfg.bufferWidth == 210 && cfg.bufferHeight == 210);
    var surface = Gfx.createBufferedBitmap({ :width => 1, :height => 1 });
    var dc = surface.getDc();
    var battery = WatchUi.loadResource(Rez.Drawables.batteryLevel);
    Test.assert(battery.getWidth() == cfg.batteryWidth);
    Test.assert(battery.getHeight() == cfg.batteryHeight);
    for (var index = 0; index < lib.pieces.size(); index++) {
        var tile = WatchUi.loadResource(lib.pieces[index]);
        Test.assert(lib.backgroundOffsets[index % 4] + tile.getWidth() <= 218);
        Test.assert(lib.backgroundOffsets[index / 4] + tile.getHeight() <= 218);
    }
    var view = new Vivoactive4sRenderTestView();
    view.onLayout(dc);
    view.onUpdate(dc);
    for (var second = 0; second < 60; second++) {
        var transform = Gfx.createAffineTransform();
        transform.translate(cfg.minutesClockX, cfg.minutesClockY);
        transform.rotate(second * ONE_RAD);
        lib.drawHourHand(dc, { :transform => transform });
        lib.drawMinuteHand(dc, { :transform => transform });
        srv.seconds.synchronize(second);
        view.onPartialUpdate(dc);
    }
    view.onEnterSleep();
    view.onUpdate(dc);
    view.onExitSleep();
    view.onUpdate(dc);
    view.onHide();
    logger.debug("Vivoactive 4S rendered native tiles, active/sleep/wake, and 60 partial updates; memory: " +
                 System.getSystemStats().usedMemory);
    return true;
}
