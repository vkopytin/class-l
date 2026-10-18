import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class Fenix6xRenderTestView extends WatchFaceView {
    function initialize() { WatchFaceView.initialize(); }

    // Keep the test synchronous while exercising the real data and draw paths.
    function engineTick(deltaTime) as Void {}
}

(:test)
function fenix6xLowMemoryRendering(logger) {
    var surface = Gfx.createBufferedBitmap({ :width => 1, :height => 1 });
    var dc = surface.getDc();
    var view = new Fenix6xRenderTestView();
    view.onLayout(dc);
    view.onUpdate(dc);

    // Rotate every polygon hand and refresh the cached data without allocating
    // a second full-screen bitmap on the low-memory device.
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
    view.onHide();
    logger.debug("Fenix 6X rendered active, sleep, and 60 partial updates; memory used: " +
                 System.getSystemStats().usedMemory);
    return true;
}
