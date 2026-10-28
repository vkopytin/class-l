using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

typedef DrawHandOptions as { :transform as Graphics.AffineTransform };

module lib {
    const moonPhaseTiles = WatchUi.loadResource(Rez.Drawables.moonPhaseTiles);
    const moonTileCoords = [
        [13, 13],  [40, 13],  [67, 13],  [95, 13],  [122, 13], [149, 13],  [13, 45],   [40, 45], [67, 45],
        [95, 45],  [122, 45], [149, 45], [13, 79],  [13, 79],  [40, 79],   [67, 79],   [95, 79], [122, 79],
        [149, 79], [13, 112], [40, 112], [67, 112], [95, 112], [122, 112], [149, 112], [13, 145]
    ];

    const twilightTiles = WatchUi.loadResource(@Rez.Drawables.twilightTiles);
    const twilightCoords = [[0, 0], [28, 0], [55, 0], [82, 0], [112, 0]];

    var hourHandResource = WatchUi.loadResource(Rez.Drawables.hourHand);
    var minuteHandResource = WatchUi.loadResource(Rez.Drawables.minuteHand);
    var secondsHandResource = WatchUi.loadResource(Rez.Drawables.secondsHand);

    function initialize() {}

    function drawHourHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-8.0, -31.0);
        dc.drawBitmap2(0, 0, self.hourHandResource, options);
    }

    function drawMinuteHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-7.0, -49.0);
        dc.drawBitmap2(0, 0, self.minuteHandResource, options);
    }

    function drawSecondsHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-4.0, -44.0);
        dc.drawBitmap2(0, 0, self.secondsHandResource, options);
    }

    function setBackgroundColor(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
    }

    function drawBackground(dc as Graphics.Dc, dx as Lang.Number, dy as Lang.Number) as Void {
        dc.drawBitmap(0, 0, WatchUi.loadResource(Rez.Drawables.background));
    }

    function drawBackgroundAod(dc as Graphics.Dc, dx as Lang.Number, dy as Lang.Number) as Void {
        self.drawBackground(dc, dx, dy);
    }

    function drawTextXTiny(dc as Graphics.Dc, x as Lang.Number, y as Lang.Number, value as Lang.String,
                           justification as Graphics.TextJustification) as Void {
        var font = WatchUi.loadResource(Rez.Fonts.segoe);
        dc.drawText(x, y, font, value, justification);
    }

    function drawMoonPhaseTile(dc as Graphics.Dc, phase as Lang.Float) as Void {
        var tile = (phase * 25).toNumber();
        var moonPhaseTile = self.moonTileCoords[tile];
        dc.drawBitmap2(cfg.moonPhaseX - moonPhaseTile[0], cfg.moonPhaseY - moonPhaseTile[1], self.moonPhaseTiles,
                       { :bitmapX => moonPhaseTile[0], :bitmapY => moonPhaseTile[1], :bitmapWidth => 17,
                         :bitmapHeight => 17 });
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
                       { :bitmapX => value[0], :bitmapY => value[1], :bitmapWidth => 20,
                         :bitmapHeight => 20 });
    }
}
