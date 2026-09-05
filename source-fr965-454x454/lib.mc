using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

module lib {
    const moonPhaseTiles = WatchUi.loadResource(Rez.Drawables.moonPhaseTiles);
    const moonTileCoords = [
        [22, 22],  [70, 22],  [119, 22],  [167, 22],  [216, 22],  [264, 22],  [22, 80],   [70, 80],   [119, 80],
        [167, 80], [216, 80], [264, 80],  [22, 138],  [70, 138],  [119, 138], [167, 138], [216, 138], [264, 138],
        [22, 196], [70, 196], [119, 196], [167, 196], [216, 196], [264, 196], [22, 255],  [70, 255]
    ];

    const twilightTiles = WatchUi.loadResource(@Rez.Drawables.twilightTiles);
    const twilightCoords = [[0, 0], [69, 0], [134, 0], [198, 0], [268, 0]];

    const hourHandResource = WatchUi.loadResource(Rez.Drawables.hourHand);
    const minuteHandResource = WatchUi.loadResource(Rez.Drawables.minuteHand);
    const secondsHandResource = WatchUi.loadResource(Rez.Drawables.secondsHand);

    function initialize() {}

    function drawHourHand(dc as Graphics.Dc, options as { :transform as Graphics.AffineTransform }) {
        options[:transform].translate(-13.0, -66.0);
        dc.drawBitmap2(0, 0, self.hourHandResource, options);
    }

    function drawMinuteHand(dc as Graphics.Dc, options as { :transform as Graphics.AffineTransform }) {
        options[:transform].translate(-10.0, -88.0);
        dc.drawBitmap2(0, 0, self.minuteHandResource, options);
    }

    function drawSecondsHand(dc as Graphics.Dc, options as { :transform as Graphics.AffineTransform }) {
        options[:transform].translate(-8.0, -92.0);
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
                       { :bitmapX => moonPhaseTile[0], :bitmapY => moonPhaseTile[1], :bitmapWidth => 30,
                         :bitmapHeight => 30 });
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
                       { :bitmapX => value[0], :bitmapY => value[1], :bitmapWidth => 48,
                         :bitmapHeight => 48 });
    }
}
