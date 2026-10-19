using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

typedef DrawHandOptions as { :transform as Gfx.AffineTransform };

module lib {
    const hourRectangles = WatchUi.loadResource(Rez.JsonData.hourHandRectangles);
    const minuteRectangles = WatchUi.loadResource(Rez.JsonData.minuteHandRectangles);
    const secondsRectangles = WatchUi.loadResource(Rez.JsonData.secondsHandRectangles);
    const backgroundPieces = [[Rez.Drawables.background0, 0, 0], [Rez.Drawables.background1, 98, 0], [Rez.Drawables.background2, 195, 0], [Rez.Drawables.background3, 293, 0], [Rez.Drawables.background4, 0, 98], [Rez.Drawables.background5, 98, 98], [Rez.Drawables.background6, 195, 98], [Rez.Drawables.background7, 293, 98], [Rez.Drawables.background8, 0, 195], [Rez.Drawables.background9, 98, 195], [Rez.Drawables.background10, 195, 195], [Rez.Drawables.background11, 293, 195], [Rez.Drawables.background12, 0, 293], [Rez.Drawables.background13, 98, 293], [Rez.Drawables.background14, 195, 293], [Rez.Drawables.background15, 293, 293]];
    const moonTiles = [Rez.Drawables.moon0, Rez.Drawables.moon1, Rez.Drawables.moon2, Rez.Drawables.moon3, Rez.Drawables.moon4, Rez.Drawables.moon5, Rez.Drawables.moon6, Rez.Drawables.moon7, Rez.Drawables.moon8, Rez.Drawables.moon9, Rez.Drawables.moon10, Rez.Drawables.moon11, Rez.Drawables.moon12, Rez.Drawables.moon13, Rez.Drawables.moon14, Rez.Drawables.moon15, Rez.Drawables.moon16, Rez.Drawables.moon17, Rez.Drawables.moon18, Rez.Drawables.moon19, Rez.Drawables.moon20, Rez.Drawables.moon21, Rez.Drawables.moon22, Rez.Drawables.moon23, Rez.Drawables.moon24, Rez.Drawables.moon25];
    const twilightTiles = [Rez.Drawables.twilight0, Rez.Drawables.twilight1, Rez.Drawables.twilight2, Rez.Drawables.twilight3, Rez.Drawables.twilight4];
    const weatherTiles = [[Rez.Drawables.weather0, 9, 21], [Rez.Drawables.weather1, 9, 22], [Rez.Drawables.weather2, 69, 22], [Rez.Drawables.weather3, 125, 22], [Rez.Drawables.weather4, 186, 22], [Rez.Drawables.weather5, 241, 22], [Rez.Drawables.weather6, 301, 24], [Rez.Drawables.weather7, 356, 23], [Rez.Drawables.weather8, 412, 23], [Rez.Drawables.weather9, 471, 23], [Rez.Drawables.weather10, 527, 23], [Rez.Drawables.weather11, 9, 86], [Rez.Drawables.weather12, 65, 88], [Rez.Drawables.weather13, 125, 88], [Rez.Drawables.weather14, 184, 88], [Rez.Drawables.weather15, 242, 86], [Rez.Drawables.weather16, 299, 86], [Rez.Drawables.weather17, 356, 86], [Rez.Drawables.weather18, 412, 86], [Rez.Drawables.weather19, 471, 87], [Rez.Drawables.weather20, 527, 87], [Rez.Drawables.weather21, 9, 149], [Rez.Drawables.weather22, 65, 149], [Rez.Drawables.weather23, 125, 149], [Rez.Drawables.weather24, 184, 149], [Rez.Drawables.weather25, 242, 150], [Rez.Drawables.weather26, 299, 148], [Rez.Drawables.weather27, 356, 149], [Rez.Drawables.weather28, 412, 150], [Rez.Drawables.weather29, 471, 150], [Rez.Drawables.weather30, 527, 150], [Rez.Drawables.weather31, 9, 207], [Rez.Drawables.weather32, 65, 207], [Rez.Drawables.weather33, 125, 206], [Rez.Drawables.weather34, 184, 208], [Rez.Drawables.weather35, 242, 208], [Rez.Drawables.weather36, 296, 208], [Rez.Drawables.weather37, 354, 208], [Rez.Drawables.weather38, 412, 208], [Rez.Drawables.weather39, 471, 206], [Rez.Drawables.weather40, 527, 208], [Rez.Drawables.weather41, 9, 265], [Rez.Drawables.weather42, 65, 265], [Rez.Drawables.weather43, 125, 265], [Rez.Drawables.weather44, 184, 268], [Rez.Drawables.weather45, 241, 268], [Rez.Drawables.weather46, 296, 268], [Rez.Drawables.weather47, 354, 268], [Rez.Drawables.weather48, 412, 268], [Rez.Drawables.weather49, 471, 265], [Rez.Drawables.weather50, 527, 265], [Rez.Drawables.weather51, 9, 319], [Rez.Drawables.weather52, 66, 319], [Rez.Drawables.weather53, 125, 319], [Rez.Drawables.weather54, 184, 319]];

    function initialize() {}

    function drawHand(dc as Graphics.Dc, options as DrawHandOptions, rectangles) as Void {
        for (var i = 0; i < rectangles.size(); i++) {
            dc.setColor(rectangles[i][0], Graphics.COLOR_TRANSPARENT);
            dc.fillPolygon(options[:transform].transformPoints(rectangles[i][1]));
        }
    }
    function drawHourHand(dc as Graphics.Dc, options as DrawHandOptions) as Void {
        self.drawHand(dc, options, self.hourRectangles);
    }
    function drawMinuteHand(dc as Graphics.Dc, options as DrawHandOptions) as Void {
        self.drawHand(dc, options, self.minuteRectangles);
    }
    function drawSecondsHand(dc as Graphics.Dc, options as DrawHandOptions) as Void {
        self.drawHand(dc, options, self.secondsRectangles);
    }
    function drawBackground(dc as Graphics.Dc, dx as Lang.Number, dy as Lang.Number) as Void {
        for (var i = 0; i < self.backgroundPieces.size(); i++) {
            var piece = self.backgroundPieces[i];
            dc.drawBitmap(piece[1] - dx, piece[2] - dy, WatchUi.loadResource(piece[0]));
        }
    }
    function drawTextXTiny(dc as Graphics.Dc, x as Lang.Number, y as Lang.Number, value as Lang.String,
                           justification as Graphics.TextJustification) as Void {
        dc.drawText(x, y, Graphics.FONT_XTINY, value, justification);
    }
    function drawMoonPhaseTile(dc as Graphics.Dc, phase as Lang.Float) as Void {
        dc.drawBitmap(cfg.moonPhaseX, cfg.moonPhaseY, WatchUi.loadResource(self.moonTiles[(phase * 25).toNumber()]));
    }
    function drawTwilightTile(dc as Graphics.Dc, twilight as Lang.Symbol) as Void {
        var tile = twilight == :morning ? 1 : (twilight == :evening ? 2 : (twilight == :night ? 3 : (twilight == :twilight ? 4 : 0)));
        dc.drawBitmap(cfg.twilightX, cfg.twilightY, WatchUi.loadResource(self.twilightTiles[tile]));
    }
    function drawWeatherTile(dc as Graphics.Dc, x, y, coordinates) as Void {
        for (var i = 0; i < self.weatherTiles.size(); i++) {
            var tile = self.weatherTiles[i];
            if (tile[1] == coordinates[0] && tile[2] == coordinates[1]) {
                dc.drawBitmap(x, y, WatchUi.loadResource(tile[0]));
                return;
            }
        }
    }
}
