import Toybox.Graphics;
import Toybox.WatchUi;

typedef DrawHandOptions as { :transform as Graphics.AffineTransform };

module lib {
    const moonPhaseTiles = WatchUi.loadResource(Rez.Drawables.moonPhaseTiles);
    const twilightTiles = WatchUi.loadResource(Rez.Drawables.twilightTiles);
    const hourHandResource = WatchUi.loadResource(Rez.Drawables.hourHand);
    const minuteHandResource = WatchUi.loadResource(Rez.Drawables.minuteHand);
    const secondsHandResource = WatchUi.loadResource(Rez.Drawables.secondsHand);
    const handScale = 360.0 / 454.0;
    const handTransform = new Graphics.AffineTransform();
    const handOptions = { :transform => self.handTransform, :filterMode => Graphics.FILTER_MODE_BILINEAR };

    function initialize() {}

    function drawHand(dc as Graphics.Dc, options as DrawHandOptions, bitmap, pivotX, pivotY) as Void {
        // The caller's transform also defines the partial-update erase clip.
        self.handTransform.setToTranslation(0.0, 0.0);
        self.handTransform.concatenate(options[:transform]);
        self.handTransform.scale(self.handScale, self.handScale);
        self.handTransform.translate(-pivotX, -pivotY);
        dc.drawBitmap2(0, 0, bitmap, self.handOptions);
    }
    function drawHourHand(dc as Graphics.Dc, options as DrawHandOptions) as Void {
        self.drawHand(dc, options, self.hourHandResource, 13.0, 66.0);
    }
    function drawMinuteHand(dc as Graphics.Dc, options as DrawHandOptions) as Void {
        self.drawHand(dc, options, self.minuteHandResource, 10.0, 88.0);
    }
    function drawSecondsHand(dc as Graphics.Dc, options as DrawHandOptions) as Void {
        self.drawHand(dc, options, self.secondsHandResource, 8.0, 92.0);
    }
    function setBackgroundColor(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
    }
    function drawBackground(dc as Graphics.Dc, dx, dy) as Void {
        dc.drawBitmap(-dx, -dy, WatchUi.loadResource(Rez.Drawables.background));
    }
    function drawBackgroundAod(dc as Graphics.Dc, dx, dy) as Void { self.drawBackground(dc, dx, dy); }
    function drawTextXTiny(dc as Graphics.Dc, x, y, value, justification) as Void {
        dc.drawText(x, y, Graphics.FONT_XTINY, value, justification);
    }
    function drawAtlasTile(dc as Graphics.Dc, x, y, bitmap, sourceX, sourceY, width, height) as Void {
        dc.setClip(x, y, width, height);
        dc.drawBitmap(x - sourceX, y - sourceY, bitmap);
        dc.clearClip();
    }
    function drawMoonPhaseTile(dc as Graphics.Dc, phase) as Void {
        var tile = self.moonTileCoords[(phase * 25).toNumber()];
        self.drawAtlasTile(dc, cfg.moonPhaseX, cfg.moonPhaseY, self.moonPhaseTiles,
                          tile[0], tile[1], self.moonTileSide, self.moonTileSide);
    }
    function drawTwilightTile(dc as Graphics.Dc, phase) as Void {
        var index = phase == :morning ? 1 : (phase == :evening ? 2 : (phase == :night ? 3 : (phase == :twilight ? 4 : 0)));
        var tile = self.twilightCoords[index];
        self.drawAtlasTile(dc, cfg.twilightX, cfg.twilightY, self.twilightTiles,
                          tile[0], tile[1], self.twilightTileSide, self.twilightTileSide);
    }
}
