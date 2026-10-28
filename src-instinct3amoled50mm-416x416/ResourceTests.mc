import Toybox.Graphics;
import Toybox.Math;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class ScaledOledRenderTestView extends WatchFaceView {
    function initialize() { WatchFaceView.initialize(); }
    function engineTick(deltaTime) as Void {}
}

// Exercise the real data update and full render, including populated weather
// when supplied by the simulator, partial updates, and always-on mode.
(:test)
function scaledOledWatchFaceRenders(logger) {
    var surface = Gfx.createBufferedBitmap({ :width => 1, :height => 1 });
    var dc = surface.getDc();
    var view = new ScaledOledRenderTestView();
    view.onLayout(dc);
    view.onUpdate(dc);
    view.onPartialUpdate(dc);
    view.onEnterSleep();
    view.onUpdate(dc);
    view.onHide();
    return true;
}

// Exercise compiled resources, including every crop in the scaled atlases.
(:test)
function venu2ScaledResourcesRender(logger) {
    var bitmap = Gfx.createBufferedBitmap({ :width => cfg.bufferWidth, :height => cfg.bufferHeight });
    var dc = bitmap.getDc();
    var background = WatchUi.loadResource(Rez.Drawables.background);
    Test.assert(background.getWidth() == dc.getWidth());
    Test.assert(background.getHeight() == dc.getHeight());
    lib.drawBackground(dc, 0, 0);
    srv.weather.drawWeatherIcon(dc, cfg.weatherX - 46, cfg.weatherY - 7, cfg.weatherX, Graphics.COLOR_WHITE);

    for (var phase = 0; phase < lib.moonTileCoords.size(); phase++) {
        lib.drawMoonPhaseTile(dc, phase / 25.0);
    }
    var twilightStates = [:night, :day, :evening, :morning, :twilight];
    for (var state = 0; state < twilightStates.size(); state++) {
        lib.drawTwilightTile(dc, twilightStates[state]);
    }

    for (var second = 0; second < 60; second++) {
        var transform = Gfx.createAffineTransform();
        transform.translate(cfg.analogClockX, cfg.analogClockY);
        transform.rotate(second * Math.PI / 30.0);
        lib.drawHourHand(dc, { :transform => transform });
        transform.initialize();
        transform.translate(cfg.analogClockX, cfg.analogClockY);
        transform.rotate(second * Math.PI / 30.0);
        lib.drawMinuteHand(dc, { :transform => transform });
        transform.initialize();
        transform.translate(cfg.analogClockX, cfg.analogClockY);
        transform.rotate(second * Math.PI / 30.0);
        lib.drawSecondsHand(dc, { :transform => transform });
    }

    var maskIds = [Rez.Drawables.aod, Rez.Drawables.aodAlt];
    for (var index = 0; index < maskIds.size(); index++) {
        var mask = WatchUi.loadResource(maskIds[index]);
        Test.assert(mask.getWidth() == dc.getWidth());
        Test.assert(mask.getHeight() == dc.getHeight());
        dc.drawBitmap(0, 0, mask);
    }
    return true;
}
