import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Application;
import Toybox.Graphics;

class WatchFaceView extends WatchUi.WatchFace {
    private var isBurnInProtection = false;
    private var sleepMode = false;
    private var frameUpdatePending = false;
    public var partialTransform = Gfx.createAffineTransform();
    private var transformMove = Gfx.createAffineTransform();
    private var buffer = null as Graphics.BufferedBitmap;

    function initialize() {
        WatchFace.initialize();
        lib.initialize();
        MainTimer.initialize(self);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        self.buffer = Gfx.createBufferedBitmap({ :width => cfg.bufferWidth,
            :height => cfg.bufferHeight,
        });
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        MainTimer.nextTick();
        if (self.sleepMode == false) {
            MainTimer.start();
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void { MainTimer.stop(); }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        self.sleepMode = false;
        var settings = System.getDeviceSettings();
        if (settings has :requiresBurnInProtection && settings.requiresBurnInProtection) {
            isBurnInProtection = false;
        }
        self.syncData();
        MainTimer.nextTick();
        MainTimer.start();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        self.sleepMode = true;
        var settings = System.getDeviceSettings();
        if (settings has :requiresBurnInProtection && settings.requiresBurnInProtection) {
            isBurnInProtection = true;
        }
        MainTimer.stop();
    }

    // Normal render phase
    function onUpdate(dc as Dc) as Void {
        if (isBurnInProtection) {
            dc.clearClip();
            dc.clear();
            return;
        }
        if (self.frameUpdatePending) {
            self.frameUpdatePending = false;
        } else {
            self.syncData();
            self.ultraUpdate(self.buffer.getDc());
        }
        dc.clearClip();
        // WatchFace.onUpdate(dc);
        lib.drawBackground(dc, 0, 0);
        dc.drawBitmap(cfg.bufferDx, cfg.bufferDy, self.buffer);

        srv.seconds.draw(dc);
    }

    // Handle the partial update event - 1Hz mode
    function onPartialUpdate(dc as Dc) as Void {
        var angle = srv.seconds.partialAngle();

        var clip = self.transformMove.transformPoints(self.partialTransform.transformPoints(cfg.initClip))
                       as Array<Graphics.Point2D>;
        var point0 = clip[0] as Graphics.Point2D;
        var point1 = clip[1] as Graphics.Point2D;
        var point2 = clip[2] as Graphics.Point2D;
        var point3 = clip[3] as Graphics.Point2D;

        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        // dc.fillPolygon(clip);

        var minX = srv.min(point0[0], srv.min(point1[0], srv.min(point2[0], point3[0])));
        var minY = srv.min(point0[1], srv.min(point1[1], srv.min(point2[1], point3[1])));
        var maxX = srv.max(point0[0], srv.max(point1[0], srv.max(point2[0], point3[0])));
        var maxY = srv.max(point0[1], srv.max(point1[1], srv.max(point2[1], point3[1])));
        dc.setClip(minX, minY, maxX - minX, maxY - minY);

        self.partialTransform.initialize();
        self.partialTransform.translate(cfg.analogClockX, cfg.analogClockY);
        self.partialTransform.rotate(angle);

        dc.drawBitmap(cfg.bufferDx, cfg.bufferDy, self.buffer);
        srv.seconds.drawPartial(dc, self.partialTransform);

        srv.seconds.advancePartial();
    }

    function engineTick(deltaTime) as Void {
        if (self.frameUpdatePending) {
            return;
        }
        self.ultraUpdate(self.buffer.getDc());

        self.frameUpdatePending = true;
        WatchUi.requestUpdate();
    }

    // Ultra fast render phase
    function ultraUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.setClip(cfg.analogClockClip[0], cfg.analogClockClip[1], cfg.analogClockClip[2], cfg.analogClockClip[3]);
        lib.drawBackground(dc, cfg.bufferDx, cfg.bufferDy);
        dc.clearClip();

        srv.drawAll(dc);
    }

    // synchronize app state
    function syncData() as Void {
        srv.seconds.synchronize(System.getClockTime().sec);
        srv.updateAll();
    }

}
