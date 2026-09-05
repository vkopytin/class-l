using Toybox.System;
using Toybox.Graphics;
using Toybox.Lang;

module srv {

    module seconds {

        var previousSeconds = 0;
        var seconds = 0;
        var lastStep = 0.0;
        var pid = PidController.create(0.23, 0.15, 0.05);
        var secTransform = Gfx.createAffineTransform();

        function update(seconds as Lang.Numeric) as Void {
            self.previousSeconds = self.seconds;
            self.seconds = seconds;
            self.pid.setTarget(self.seconds);
            if (self.previousSeconds > self.seconds) {
                self.pid.reset();
                self.lastStep = self.pid.update(-1.0);
            }

            self.pid.setTarget(self.seconds);
        }

        function draw(dc as Graphics.Dc) as Void {
            self.lastStep = self.pid.update(self.lastStep);
            var angle = self.lastStep * ONE_RAD;

            self.secTransform.initialize();
            self.secTransform.translate(cfg.analogClockX, cfg.analogClockY);
            self.secTransform.rotate(angle);

            lib.drawSecondsHand(dc, { :transform => self.secTransform });
        }
    }
}
