import Toybox.Graphics;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class Fenix7sRenderTestView extends WatchFaceView {
    function initialize() { WatchFaceView.initialize(); }
    function engineTick(deltaTime) as Void {}
}

(:test)
function fenix7sBitmapRendering(logger) {
    var bitmap = Gfx.createBufferedBitmap({ :width => cfg.bufferWidth, :height => cfg.bufferHeight });
    var dc = bitmap.getDc();
    var background = WatchUi.loadResource(Rez.Drawables.background);
    logger.debug("Background " + background.getWidth() + "x" + background.getHeight() +
                 "; buffer " + dc.getWidth() + "x" + dc.getHeight());
    Test.assert(background.getWidth() == dc.getWidth());
    Test.assert(background.getHeight() == dc.getHeight());
    var battery = WatchUi.loadResource(Rez.Drawables.batteryLevel);
    Test.assert(battery.getWidth() == cfg.batteryWidth);
    Test.assert(battery.getHeight() == cfg.batteryHeight);

    var view = new Fenix7sRenderTestView();
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
    view.onHide();
    logger.debug("Fenix 7S rendered the Fenix 6S background, all scaled sprites, and 60 hand angles.");
    return true;
}
