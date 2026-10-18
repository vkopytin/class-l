using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

typedef DrawHandOptions as { :transform as Graphics.AffineTransform };

module lib {
    const moonPhaseTiles = WatchUi.loadResource(Rez.Drawables.moonPhaseTiles);
    const moonTileCoords = [
        [14, 14],  [44, 14],  [74, 14],  [104, 14], [135, 14],  [164, 14],  [14, 50],   [44, 50],  [74, 50],
        [104, 50], [135, 50], [164, 50], [14, 87],  [14, 87],   [44, 87],   [74, 87],   [104, 87], [135, 87],
        [164, 87], [14, 123], [44, 123], [74, 123], [104, 123], [135, 123], [164, 123], [14, 160]
    ];

    const twilightTiles = WatchUi.loadResource(@Rez.Drawables.twilightTiles);
    const twilightCoords = [
        [0, 0], // day
        [30, 0], // morning
        [61, 0], // evening
        [90, 0], // night
        [123, 0] // twilight
    ];

    var hourHandResource = WatchUi.loadResource(Rez.Drawables.hourHand);
    var minuteHandResource = WatchUi.loadResource(Rez.Drawables.minuteHand);
    var secondsHandResource = WatchUi.loadResource(Rez.Drawables.secondsHand);

    function initialize() {}

    function drawHourHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-9.2308, -35.0769);
        dc.drawBitmap2(0, 0, self.hourHandResource, options);
    }

    function drawMinuteHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-8.3077, -54.4615);
        dc.drawBitmap2(0, 0, self.minuteHandResource, options);
    }

    function drawSecondsHand(dc as Graphics.Dc, options as DrawHandOptions) {
        options[:transform].translate(-4.6154, -48.9231);
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
                       { :bitmapX => moonPhaseTile[0], :bitmapY => moonPhaseTile[1], :bitmapWidth => 18,
                         :bitmapHeight => 18 });
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
                       { :bitmapX => value[0], :bitmapY => value[1], :bitmapWidth => 22,
                         :bitmapHeight => 22 });
    }
}
