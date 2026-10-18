import Toybox.Graphics;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class Fenix9Pro51RenderTestView extends WatchFaceView {
    function initialize() { WatchFaceView.initialize(); }
    function engineTick(deltaTime) as Void {}
}

(:test)
function fenix9Pro51OledRendering(logger) {
    var bitmap = Gfx.createBufferedBitmap({ :width => cfg.bufferWidth, :height => cfg.bufferHeight });
    var dc = bitmap.getDc();
    Test.assert(dc.getWidth() == 466 && dc.getHeight() == 466);
    var background = WatchUi.loadResource(Rez.Drawables.background);
    Test.assert(background.getWidth() == dc.getWidth());
    Test.assert(background.getHeight() == dc.getHeight());

    var view = new Fenix9Pro51RenderTestView();
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
    }

    var masks = [Rez.Drawables.aod, Rez.Drawables.aodAlt];
    for (var index = 0; index < masks.size(); index++) {
        var mask = WatchUi.loadResource(masks[index]);
        Test.assert(mask.getWidth() == dc.getWidth());
        Test.assert(mask.getHeight() == dc.getHeight());
        dc.drawBitmap(0, 0, mask);
    }
    view.onEnterSleep();
    view.onUpdate(dc);
    view.onHide();
    logger.debug("Fenix 9 Pro 51mm rendered at 466x466, including all sprite crops and both AOD masks.");
    return true;
}
