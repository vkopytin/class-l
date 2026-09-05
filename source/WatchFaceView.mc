import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Application;
import Toybox.Graphics;

class WatchFaceView extends WatchUi.WatchFace {
    private const timer = new MainTimer(self);
    private var isBurnInProtection = false;
    private var sleepMode = false;
    private var clockTime = null as System.ClockTime;
    private var requestedUpdate = false;
    private var transform = Gfx.createAffineTransform();
    private var secondsOptions = { :transform => self.transform };
    private var transformMove = Gfx.createAffineTransform();
    private var buffer = null as Graphics.BufferedBitmap;

    function initialize() {
        WatchFace.initialize();
        lib.initialize();
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
        self.timer.nextTick();
        if (self.sleepMode == false) {
            self.timer.start();
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void { self.timer.stop(); }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        self.sleepMode = false;
        var settings = System.getDeviceSettings();
        if (settings has :requiresBurnInProtection && settings.requiresBurnInProtection) {
            isBurnInProtection = false;
        }
        srv.seconds.update(100);
        self.syncData();
        self.timer.nextTick();
        self.timer.start();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        self.sleepMode = true;
        var settings = System.getDeviceSettings();
        if (settings has :requiresBurnInProtection && settings.requiresBurnInProtection) {
            isBurnInProtection = true;
        }
        self.timer.stop();
    }

    // Normal render phase
    function onUpdate(dc as Dc) as Void {
        if (isBurnInProtection) {
            dc.clearClip();
            dc.clear();
            return;
        }
        if (self.requestedUpdate) {
            self.requestedUpdate = false;
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
        var angle = srv.seconds.seconds * ONE_RAD;

        var clip = self.transformMove.transformPoints(self.transform.transformPoints(cfg.initClip));

        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        // dc.fillPolygon(clip);

        var minX = srv.min(clip[0][0], srv.min(clip[1][0], srv.min(clip[2][0], clip[3][0])));
        var minY = srv.min(clip[0][1], srv.min(clip[1][1], srv.min(clip[2][1], clip[3][1])));
        var maxX = srv.max(clip[0][0], srv.max(clip[1][0], srv.max(clip[2][0], clip[3][0])));
        var maxY = srv.max(clip[0][1], srv.max(clip[1][1], srv.max(clip[2][1], clip[3][1])));
        dc.setClip(minX, minY, maxX - minX, maxY - minY);

        self.transform.initialize();
        self.transform.translate(cfg.analogClockX, cfg.analogClockY);
        self.transform.rotate(angle);

        dc.drawBitmap(0, 0, self.buffer);
        lib.drawSecondsHand(dc, self.secondsOptions);

        srv.seconds.seconds++;
    }

    function engineTick(deltaTime) as Void {
        if (self.requestedUpdate) {
            // self.syncData();
            return;
        }
        self.ultraUpdate(self.buffer.getDc());

        self.requestedUpdate = true;
        WatchUi.requestUpdate();
    }

    // Ultra fast render phase
    function ultraUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
        dc.clear();
        dc.setClip(cfg.analogClockClip[0], cfg.analogClockClip[1], cfg.analogClockClip[2], cfg.analogClockClip[3]);
        lib.drawBackground(dc, cfg.bufferDx, cfg.bufferDy);
        dc.clearClip();

        srv.barometer.draw(dc);
        srv.heartRate.draw(dc);
        srv.steps.draw(dc);
        srv.weather.draw(dc);
        srv.battery.draw(dc);
        srv.calendar.draw(dc);
        srv.digital.draw(dc);
        srv.moonPhase.draw(dc);
        srv.twilight.draw(dc);
        srv.clock.draw(dc);
    }

    // synchronize app state
    function syncData() as Void {
        self.clockTime = System.getClockTime();
        srv.seconds.update(self.clockTime.sec);

        srv.barometer.update();
        srv.heartRate.update();
        srv.steps.update();
        srv.weather.update();
        srv.battery.update();
        srv.calendar.update();
        srv.digital.update();
        srv.moonPhase.update();
        srv.twilight.update();
        srv.clock.update();
    }

}
