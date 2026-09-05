import Toybox.Math;
import Toybox.System;
import Toybox.Lang;

class PidController {
    static function create(kP, kI, kD) as PidController { return new PidController(kP, kI, kD, 0, 0); }

    var kP;
    var kI;
    var kD;
    var dt;
    var iMax;
    var target;
    var currentValue;
    var sumError;
    var lastError;
    var lastTime;

    function initialize(kP, kI, kD, dt, iMax) {
        // PID constants
        self.kP = kP;
        self.kI = kP;
        self.kD = kD;

        // Interval of time between two updates
        // If not set, it will be automatically calculated
        self.dt = dt;

        // Maximum absolute value of sumError
        self.iMax = iMax;

        self.sumError = 0;
        self.lastError = 0;
        self.lastTime = 0;

        self.target = 0; // default value, can be modified with .setTarget
    }

    function setTarget(target) as Void { self.target = target; }

    function update(currentValue) as Number {
        self.currentValue = currentValue;

        // Calculate dt
        var dt = self.dt;
        if (dt > 0) {
            var currentTime = System.getTimer();
            if (self.lastTime == 0) { // First time update() is called
                dt = 0;
            } else {
                dt = (currentTime - self.lastTime) / 1000.0; // in seconds
            }
            self.lastTime = currentTime;
        }
        if (dt == 0) {
            dt = 3.0;
        }

        var error = (self.target - self.currentValue);
        self.sumError = self.sumError + error * dt;
        if (self.iMax > 0 && self.sumError.abs() > self.iMax) {
            var sumSign = (self.sumError > 0) ? 1.0 : -1.0;
            self.sumError = sumSign * self.iMax;
        }

        var dError = (error - self.lastError) / dt;
        self.lastError = error;

        return (self.kP * error) + (self.kI * self.sumError) + (self.kD * dError);
    }

    function reset() as Void {
        self.sumError = 0.0;
        self.lastError = 0.0;
        self.lastTime = 0.0;
    }
}
