import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

class MoonPhasesView extends WatchUi.Drawable {
    private var moonPhaseTile = [15, 15] as [Number, Number];
    private var moonTileCoords = [] as Array<[Number, Number]>;
    private var moonPhaseTiles = null as WatchUi.BitmapResource;
    private var tileSize = 20;

    function initialize(params) {

        Drawable.initialize(params);

        if (params.hasKey(:tileSize)) {
            self.tileSize = params.get(:tileSize);
        }

        self.moonPhaseTiles = WatchUi.loadResource(@Rez.Drawables.moonPhaseTiles);
    }

    public function updateData(time as Toybox.Time.Moment) {

        var phase = self.moonPhase(time);
        self.moonPhaseTile = cfg.moonTileCoords[phase];

    }

    function draw(dc as Dc) {

        Drawable.draw(dc);

        dc.drawBitmap2(self.locX - self.moonPhaseTile[0], self.locY - self.moonPhaseTile[1], self.moonPhaseTiles,
                       { :bitmapX => self.moonPhaseTile[0], :bitmapY => self.moonPhaseTile[1],
                         :bitmapWidth => self.tileSize, :bitmapHeight => self.tileSize });
    }

    function moonPhase(now as Toybox.Time.Moment) {
        var time = (now.value() * 1000.0) / 86400000.0 + EPOCH;
        var phase = (time - 2451550.1) / SYNODIC_MONTH;
        var moonAge = phase - Math.floor(phase);
        if (moonAge < 0) {
            moonAge = moonAge + 1.0;
        }
        // return moonAge * SYNODIC_MONTH;
        return (moonAge * 25).toNumber();
    }

}
