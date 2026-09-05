using Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Math;

const EPOCH = 2440587.5;
const SYNODIC_MONTH = 29.53058770576;

module srv {
    module moonPhase {
        var moonPhase = 0.0;

        function update() as Void {
            var now = Time.now();
            self.moonPhase = self.calcMoonPhase(now);
        }

        function draw(dc as Graphics.Dc) as Void { lib.drawMoonPhaseTile(dc, self.moonPhase); }

        function calcMoonPhase(now as Toybox.Time.Moment) as Lang.Float {
            var time = (now.value() * 1000.0) / 86400000.0 + EPOCH;
            var phase = (time - 2451550.1) / SYNODIC_MONTH;
            var moonAge = phase - Math.floor(phase);
            if (moonAge < 0) {
                moonAge = moonAge + 1.0;
            }
            // return moonAge * SYNODIC_MONTH;
            return moonAge;
        }
    }
}
