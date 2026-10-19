using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

typedef DrawHandOptions as { :transform as Graphics.AffineTransform };

module lib {
    const moonPhaseTiles = WatchUi.loadResource(Rez.Drawables.moonPhaseTiles);
    const moonTileCoords = [
        [23, 23],  [72, 23],  [122, 23],  [171, 23],  [222, 23],  [271, 23],  [23, 82],   [72, 82],   [122, 82],
        [171, 82], [222, 82], [271, 82],  [23, 142],  [72, 142],  [122, 142], [171, 142], [222, 142], [271, 142],
        [23, 201], [72, 201], [122, 201], [171, 201], [222, 201], [271, 201], [23, 262],  [72, 262]
    ];

    const twilightTiles = WatchUi.loadResource(@Rez.Drawables.twilightTiles);
    const twilightCoords = [[0, 0], [71, 0], [138, 0], [203, 0], [275, 0]];

    const hourHandResource = WatchUi.loadResource(Rez.Drawables.hourHand);
    const minuteHandResource = WatchUi.loadResource(Rez.Drawables.minuteHand);
    const secondsHandResource = WatchUi.loadResource(Rez.Drawables.secondsHand);

    function initialize() {}

    function drawHourHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-13.3436, -67.7445);
        dc.drawBitmap2(0, 0, self.hourHandResource, options);
    }

    function drawMinuteHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-10.2643, -90.326);
        dc.drawBitmap2(0, 0, self.minuteHandResource, options);
    }

    function drawSecondsHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-8.2115, -94.4317);
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
        dc.drawText(x, y, Graphics.FONT_XTINY, value, justification);
    }

    function drawMoonPhaseTile(dc as Graphics.Dc, phase as Lang.Float) as Void {
        var tile = (phase * 25).toNumber();
        var moonPhaseTile = self.moonTileCoords[tile];
        dc.drawBitmap2(cfg.moonPhaseX - moonPhaseTile[0], cfg.moonPhaseY - moonPhaseTile[1], self.moonPhaseTiles,
                       { :bitmapX => moonPhaseTile[0], :bitmapY => moonPhaseTile[1], :bitmapWidth => 31,
                         :bitmapHeight => 31 });
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
                       { :bitmapX => value[0], :bitmapY => value[1], :bitmapWidth => 49,
                         :bitmapHeight => 49 });
    }
}
