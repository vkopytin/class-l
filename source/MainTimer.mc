import Toybox.System;
import Toybox.Timer;

class MainTimer {
    const updateFn = method(:update);
    var timer as Timer.Timer;
    var deltaTime = 100;
    var lastTime = System.getTimer();
    var accumulatedTime = 0;

    var instWithEngineTick;

    function initialize(instWithEngineTick) {
        self.instWithEngineTick = instWithEngineTick;
        self.timer = new Timer.Timer();
    }

    function nextTick() as Void {
        var time = System.getTimer();
        self.accumulatedTime += (time - self.lastTime);

        if (self.accumulatedTime > 1000) {
            self.accumulatedTime = 1000;
        }

        while (self.accumulatedTime > self.deltaTime) {
            self.instWithEngineTick.engineTick(self.deltaTime);
            self.accumulatedTime -= self.deltaTime;
        }

        self.lastTime = time;
    }

    function start() as Void { self.enqueue(); }

    function stop() as Void { self.timer.stop(); }

    private function enqueue() as Void { self.timer.start(self.updateFn, 100, false); }

    function update() as Void {
        self.nextTick();
        self.enqueue();
    }
}
