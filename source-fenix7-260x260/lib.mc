using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

module lib {
    const moonPhaseTiles = WatchUi.loadResource(Rez.Drawables.moonPhaseTiles);
    const moonTileCoords = [
        [15, 15],  [48, 15],  [80, 15],  [113, 15], [146, 15],  [178, 15],  [15, 54],   [48, 54],  [80, 54],
        [113, 54], [146, 54], [178, 54], [15, 94],  [15, 94],   [48, 94],   [80, 94],   [113, 94], [146, 94],
        [178, 94], [15, 133], [48, 133], [80, 133], [113, 133], [146, 133], [178, 133], [15, 173]
    ];

    const twilightTiles = WatchUi.loadResource(@Rez.Drawables.twilightTiles);
    const twilightCoords = [
        [0, 0], // day
        [33, 0], // morning
        [66, 0], // evening
        [98, 0], // night
        [133, 0] // twilight
    ];

    var hourHandResource = WatchUi.loadResource(Rez.Drawables.hourHand);
    var minuteHandResource = WatchUi.loadResource(Rez.Drawables.minuteHand);
    var secondsHandResource = WatchUi.loadResource(Rez.Drawables.secondsHand);

    function initialize() {}

    function drawHourHand(dc as Graphics.Dc, options as { :transform as Graphics.AffineTransform }) {
        options[:transform].translate(-10.0, -38.0);
        dc.drawBitmap2(0, 0, self.hourHandResource, options);
    }

    function drawMinuteHand(dc as Graphics.Dc, options as { :transform as Graphics.AffineTransform }) {
        options[:transform].translate(-9.0, -59.0);
        dc.drawBitmap2(0, 0, self.minuteHandResource, options);
    }

    function drawSecondsHand(dc as Graphics.Dc, options as { :transform as Graphics.AffineTransform }) {
        options[:transform].translate(-5.0, -53.0);
        dc.drawBitmap2(0, 0, self.secondsHandResource, options);
    }

    function drawBackground(dc as Graphics.Dc, dx as Lang.Number, dy as Lang.Number) as Void {
        dc.drawBitmap(0, 0, WatchUi.loadResource(Rez.Drawables.background));
    }

    function drawTextXTyni(dc as Graphics.Dc, x as Lang.Number, y as Lang.Number, value as Lang.String,
                           justification as Graphics.TextJustification) as Void {
        dc.drawText(x, y, Graphics.FONT_XTINY, value, justification);
    }

    function drawMoonPhaseTile(dc as Graphics.Dc, phase as Lang.Float) as Void {
        var tile = (phase * 25).toNumber();
        var moonPhaseTile = self.moonTileCoords[tile];
        dc.drawBitmap2(cfg.moonPhaseX - moonPhaseTile[0], cfg.moonPhaseY - moonPhaseTile[1], self.moonPhaseTiles,
                       { :bitmapX => moonPhaseTile[0], :bitmapY => moonPhaseTile[1], :bitmapWidth => 20,
                         :bitmapHeight => 20 });
    }

    function drawTwilightTile(dc as Graphics.Dc, twilightTile as Lang.Symbol) as Void {
        var value = self.twilightCoords[0];
        if (twilightTile == :night) {
            value = self.twilightCoords[3];
        } else if (twilightTile == :day) {
            value = self.twilightCoords[0];
        } else if (twilightTile == :evening) {
            value = self.twilightCoords[2];
        } else if (twilightTile == :morning) {
            value = self.twilightCoords[1];
        } else if (twilightTile == :twilight) {
            value = self.twilightCoords[4];
        }

        dc.drawBitmap2(cfg.twilightX - value[0], cfg.twilightY - value[1], self.twilightTiles,
                       { :bitmapX => value[0], :bitmapY => value[1], :bitmapWidth => 24,
                         :bitmapHeight => 24 });
    }
}
