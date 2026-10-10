using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

typedef DrawHandOptions as { :transform as Graphics.AffineTransform };

module lib {
    const moonPhaseTiles = WatchUi.loadResource(Rez.Drawables.moonPhaseTiles);
    const moonTileCoords = [
        [16, 16],  [52, 16],  [86, 16],  [122, 16], [157, 16],  [192, 16],  [16, 58],   [52, 58],  [86, 58],
        [122, 58], [157, 58], [192, 58], [16, 101],  [16, 101],   [52, 101],   [86, 101],   [122, 101], [157, 101],
        [192, 101], [16, 143], [52, 143], [86, 143], [122, 143], [157, 143], [192, 143], [16, 186]
    ];

    const twilightTiles = WatchUi.loadResource(@Rez.Drawables.twilightTiles);
    const twilightCoords = [
        [0, 0], // day
        [36, 0], // morning
        [71, 0], // evening
        [106, 0], // night
        [143, 0] // twilight
    ];

    var hourHandResource = WatchUi.loadResource(Rez.Drawables.hourHand);
    var minuteHandResource = WatchUi.loadResource(Rez.Drawables.minuteHand);
    var secondsHandResource = WatchUi.loadResource(Rez.Drawables.secondsHand);

    function initialize() {}

    function drawHourHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-10.7692, -40.9231);
        dc.drawBitmap2(0, 0, self.hourHandResource, options);
    }

    function drawMinuteHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-9.6923, -63.5385);
        dc.drawBitmap2(0, 0, self.minuteHandResource, options);
    }

    function drawSecondsHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-5.3846, -57.0769);
        dc.drawBitmap2(0, 0, self.secondsHandResource, options);
    }

    function drawBackground(dc as Graphics.Dc, dx as Lang.Number, dy as Lang.Number) as Void {
        dc.drawBitmap(0, 0, WatchUi.loadResource(Rez.Drawables.background));
    }

    function drawTextXTiny(dc as Graphics.Dc, x as Lang.Number, y as Lang.Number, value as Lang.String,
                           justification as Graphics.TextJustification) as Void {
        dc.drawText(x, y, Graphics.FONT_XTINY, value, justification);
    }

    function drawMoonPhaseTile(dc as Graphics.Dc, phase as Lang.Float) as Void {
        var tile = (phase * 25).toNumber();
        var moonPhaseTile = self.moonTileCoords[tile];
        dc.drawBitmap2(cfg.moonPhaseX - moonPhaseTile[0], cfg.moonPhaseY - moonPhaseTile[1], self.moonPhaseTiles,
                       { :bitmapX => moonPhaseTile[0], :bitmapY => moonPhaseTile[1], :bitmapWidth => 22,
                         :bitmapHeight => 22 });
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
                       { :bitmapX => value[0], :bitmapY => value[1], :bitmapWidth => 26,
                         :bitmapHeight => 26 });
    }
}
