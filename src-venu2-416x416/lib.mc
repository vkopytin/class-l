using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

typedef DrawHandOptions as { :transform as Graphics.AffineTransform };

module lib {
    const moonPhaseTiles = WatchUi.loadResource(Rez.Drawables.moonPhaseTiles);
    const moonTileCoords = [
        [20, 20],  [64, 20],  [109, 20],  [153, 20],  [198, 20],  [242, 20],  [20, 73],   [64, 73],   [109, 73],
        [153, 73], [198, 73], [242, 73],  [20, 126],  [64, 126],  [109, 126], [153, 126], [198, 126], [242, 126],
        [20, 180], [64, 180], [109, 180], [153, 180], [198, 180], [242, 180], [20, 234],  [64, 234]
    ];

    const twilightTiles = WatchUi.loadResource(@Rez.Drawables.twilightTiles);
    const twilightCoords = [[0, 0], [63, 0], [123, 0], [181, 0], [246, 0]];

    const hourHandResource = WatchUi.loadResource(Rez.Drawables.hourHand);
    const minuteHandResource = WatchUi.loadResource(Rez.Drawables.minuteHand);
    const secondsHandResource = WatchUi.loadResource(Rez.Drawables.secondsHand);

    function initialize() {}

    function drawHourHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-11.912, -60.476);
        dc.drawBitmap2(0, 0, self.hourHandResource, options);
    }

    function drawMinuteHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-9.163, -80.634);
        dc.drawBitmap2(0, 0, self.minuteHandResource, options);
    }

    function drawSecondsHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-7.33, -84.3);
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
                       { :bitmapX => moonPhaseTile[0], :bitmapY => moonPhaseTile[1], :bitmapWidth => 28,
                         :bitmapHeight => 28 });
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
                       { :bitmapX => value[0], :bitmapY => value[1], :bitmapWidth => 44,
                         :bitmapHeight => 44 });
    }
}
