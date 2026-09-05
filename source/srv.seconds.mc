using Toybox.System;
using Toybox.Graphics;
using Toybox.Lang;

module srv {

    module seconds {

        var previousSeconds = 0;
        var canonicalSecond = 0;
        var partialSecond = 0;
        var lastStep = 0.0;
        var pid = PidController.create(0.16, 0.23, 0.15);
        var secTransform = Gfx.createAffineTransform();

        function synchronize(second as Lang.Numeric) as Void {
            self.previousSeconds = self.canonicalSecond;
            self.canonicalSecond = second;
            self.partialSecond = second;
            self.pid.setTarget(self.canonicalSecond);
            if (self.previousSeconds > self.canonicalSecond) {
                self.pid.reset();
                self.lastStep = self.pid.update(-1.0);
            }
            self.pid.setTarget(self.canonicalSecond);
        }

        function advancePartial() as Void { self.partialSecond = (self.partialSecond + 1) % 60; }

        function draw(dc as Graphics.Dc) as Void {
            self.lastStep = self.pid.update(self.lastStep);
            var angle = self.lastStep * ONE_RAD;

            self.secTransform.initialize();
            self.secTransform.translate(cfg.analogClockX, cfg.analogClockY);
            self.secTransform.rotate(angle);

            lib.drawSecondsHand(dc, { :transform => self.secTransform });
        }

        function drawPartial(dc as Graphics.Dc, transform) as Void {
            lib.drawSecondsHand(dc, { :transform => transform });
        }

        function partialAngle() as Lang.Numeric { return self.partialSecond * ONE_RAD; }
    }
}
