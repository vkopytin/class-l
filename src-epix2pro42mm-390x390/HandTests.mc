import Toybox.Graphics;
import Toybox.Math;
import Toybox.Test;

(:test)
function filteredHandsKeepTheirPivot(logger) {
    var surface = Gfx.createBufferedBitmap({ :width => 220, :height => 220 });
    var dc = surface.getDc();
    var transform = Gfx.createAffineTransform();
    var options = { :transform => transform };
    var pivots = [[13.0, 66.0], [10.0, 88.0], [8.0, 92.0]];
    for (var tick = 0; tick < 60; tick++) {
        // Include fractional angles, as used by the animated seconds hand.
        transform.setToTranslation(110.0, 110.0);
        transform.rotate((tick + 0.37) * Math.PI / 30.0);
        var original = transform.getMatrix();
        for (var hand = 0; hand < 3; hand++) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.clear();
            if (hand == 0) {
                lib.drawHourHand(dc, options);
            } else if (hand == 1) {
                lib.drawMinuteHand(dc, options);
            } else {
                lib.drawSecondsHand(dc, options);
            }
            // Drawing must not move the caller's transform: the view reuses
            // it to calculate the seconds hand's partial-update erase clip.
            var after = transform.getMatrix();
            for (var element = 0; element < original.size(); element++) {
                Test.assertEqual(after[element], original[element]);
            }
            var pivot = lib.handTransform.transformPoint(pivots[hand]);
            Test.assert(pivot[0] > 109.999 && pivot[0] < 110.001);
            Test.assert(pivot[1] > 109.999 && pivot[1] < 110.001);
        }
    }
    return true;
}
