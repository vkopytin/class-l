using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Math;

module srv {
    module clock {
        function update() as Void {

        }

        function draw(dc as Graphics.Dc) as Void {
            var secondAngle = (srv.digital.clockTime.sec / 60.0) * 2.0 * Math.PI;
            var minuteAngle = (srv.digital.clockTime.min / 60.0) * 2.0 * Math.PI;
            var hourAngle = srv.digital.clockTime.hour / 12.0 * 2.0 * Math.PI;

            var minuteHandTransform = Gfx.createAffineTransform();
            minuteHandTransform.translate(cfg.minutesClockX, cfg.minutesClockY);
            minuteHandTransform.rotate(minuteAngle + secondAngle / 60.0);

            var hourHandTransform = Gfx.createAffineTransform();
            hourHandTransform.translate(cfg.minutesClockX, cfg.minutesClockY);
            hourHandTransform.rotate(hourAngle + minuteAngle / 12.0);

            lib.drawMinuteHand(dc, {
                :transform => minuteHandTransform,
            });

            lib.drawHourHand(dc, {
                :transform => hourHandTransform,
            });
        }
    }
}
