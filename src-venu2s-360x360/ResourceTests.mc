import Toybox.Graphics;
import Toybox.Math;
import Toybox.System;
import Toybox.Test;
import Toybox.WatchUi;

(:test)
class Venu2sAtlasChecks {
    function initialize() {}
    function draw(dc, bitmap, tiles, width, height) {
        for (var i = 0; i < tiles.size(); i++) {
            Test.assert(tiles[i][0] >= 0 && tiles[i][1] >= 0);
            Test.assert(tiles[i][0] + width <= bitmap.getWidth());
            Test.assert(tiles[i][1] + height <= bitmap.getHeight());
            lib.drawAtlasTile(dc, 0, 0, bitmap, tiles[i][0], tiles[i][1], width, height);
        }
    }
}

(:test)
function venu2sScaledResourcesRender(logger) {
    var surface = Gfx.createBufferedBitmap({ :width => 360, :height => 360 });
    var dc = surface.getDc();
    var background = WatchUi.loadResource(Rez.Drawables.background);
    Test.assertEqual(background.getWidth(), 360);
    Test.assertEqual(background.getHeight(), 360);
    lib.drawBackground(dc, 0, 0);
    var checks = new Venu2sAtlasChecks();
    checks.draw(dc, lib.moonPhaseTiles, lib.moonTileCoords, lib.moonTileSide, lib.moonTileSide);
    checks.draw(dc, lib.twilightTiles, lib.twilightCoords, lib.twilightTileSide, lib.twilightTileSide);
    checks.draw(dc, srv.weather.weatherConditions, lib.weatherTileCoords, lib.weatherTileWidth, lib.weatherTileHeight);
    srv.weather.drawWeatherIcon(dc, 0, 0, 0, Graphics.COLOR_WHITE);
    var phases = [:day, :morning, :evening, :night, :twilight];
    for (var phase = 0; phase < phases.size(); phase++) {
        lib.drawTwilightTile(dc, phases[phase]);
    }
    for (var moon = 0; moon < 26; moon++) {
        lib.drawMoonPhaseTile(dc, moon / 25.0);
    }
    var transform = Gfx.createAffineTransform();
    var options = { :transform => transform };
    var pivots = [[13.0, 66.0], [10.0, 88.0], [8.0, 92.0]];
    for (var tick = 0; tick < 60; tick++) {
        transform.setToTranslation(cfg.analogClockX, cfg.analogClockY);
        transform.rotate((tick + 0.37) * Math.PI / 30.0);
        var original = transform.getMatrix();
        for (var hand = 0; hand < 3; hand++) {
            if (hand == 0) { lib.drawHourHand(dc, options); }
            else if (hand == 1) { lib.drawMinuteHand(dc, options); }
            else { lib.drawSecondsHand(dc, options); }
            var after = transform.getMatrix();
            for (var element = 0; element < original.size(); element++) {
                Test.assertEqual(after[element], original[element]);
            }
            var pivot = lib.handTransform.transformPoint(pivots[hand]);
            Test.assert(pivot[0] > cfg.analogClockX - 0.001 && pivot[0] < cfg.analogClockX + 0.001);
            Test.assert(pivot[1] > cfg.analogClockY - 0.001 && pivot[1] < cfg.analogClockY + 0.001);
        }
    }
    var masks = [Rez.Drawables.aod, Rez.Drawables.aodAlt];
    for (var index = 0; index < masks.size(); index++) {
        var mask = WatchUi.loadResource(masks[index]);
        Test.assertEqual(mask.getWidth(), 360);
        Test.assertEqual(mask.getHeight(), 360);
        dc.drawBitmap(0, 0, mask);
    }
    return true;
}

(:test)
class Venu2sRenderTestView extends WatchFaceView {
    function initialize() { WatchFaceView.initialize(); }
    function engineTick(deltaTime) as Void {}
}

(:test)
function venu2sSleepWakeRendering(logger) {
    var output = Gfx.createBufferedBitmap({ :width => 1, :height => 1 });
    var view = new Venu2sRenderTestView();
    view.onLayout(output.getDc());
    view.onUpdate(output.getDc());
    view.onEnterSleep();
    view.onUpdate(output.getDc());
    view.onExitSleep();
    view.onUpdate(output.getDc());
    view.onHide();
    logger.debug("Venu 2S awake, AOD and wake rendering passed; heap bytes: " + System.getSystemStats().usedMemory);
    return true;
}
