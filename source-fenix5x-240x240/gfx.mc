import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

module Gfx {
    class AffineTransform {
        private var m00 = 1.0;
        private var m01 = 0.0;
        private var m02 = 0.0;
        private var m10 = 0.0;
        private var m11 = 1.0;
        private var m12 = 0.0;

        function initialize() {
            self.m00 = 1.0;
            self.m01 = 0.0;
            self.m02 = 0.0;
            self.m10 = 0.0;
            self.m11 = 1.0;
            self.m12 = 0.0;
        }

        function translate(tx as Numeric, ty as Numeric) as Void {
            self.m02 += tx * self.m00 + ty * self.m01;
            self.m12 += tx * self.m10 + ty * self.m11;
        }

        function scale(sx as Numeric, sy as Numeric) as Void {
            self.m00 *= sx;
            self.m01 *= sy;
            self.m10 *= sx;
            self.m11 *= sy;
        }

        function rotate(theta as Numeric) as Void {
            var cosTheta = Math.cos(theta);
            var sinTheta = Math.sin(theta);

            var m00New = self.m00 * cosTheta + self.m01 * sinTheta;
            var m01New = -self.m00 * sinTheta + self.m01 * cosTheta;
            var m10New = self.m10 * cosTheta + self.m11 * sinTheta;
            var m11New = -self.m10 * sinTheta + self.m11 * cosTheta;

            self.m00 = m00New;
            self.m01 = m01New;
            self.m10 = m10New;
            self.m11 = m11New;
        }

        // function getMatrix() as Lang.Array<Lang.Array<Lang.Numeric>> {
        //     return [[self.m00, self.m01, self.m02], [self.m10, self.m11, self.m12]];
        // }

        function transformPoints(points as Array<Point2D>) as Array<Point2D> {
            var transformedPoints = new Array<Point2D>[points.size()];
            for (var i = 0; i < points.size(); i++) {
                var x = points[i][0];
                var y = points[i][1];
                var newX = self.m00 * x + self.m01 * y + self.m02;
                var newY = self.m10 * x + self.m11 * y + self.m12;
                transformedPoints[i] = [newX, newY];
            }
            return transformedPoints;
        }
    }
    function createAffineTransform() as Gfx.AffineTransform { return new Gfx.AffineTransform(); }

    function createBufferedBitmap(options as { :width as Number, :height as Number })
        as Graphics.BufferedBitmap {
        return new Graphics.BufferedBitmap(options);
    }
}
