import Toybox.System;
import Toybox.Timer;

module MainTimer {
    const MAX_CATCH_UP_MS = 1000;
    const updateFn = new Toybox.Lang.Method(MainTimer, :update);
    var timer = null as Timer.Timer;
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

        if (self.accumulatedTime > self.MAX_CATCH_UP_MS) {
            self.accumulatedTime = self.MAX_CATCH_UP_MS;
        }

        while (self.accumulatedTime > self.deltaTime) {
            self.instWithEngineTick.engineTick(self.deltaTime);
            self.accumulatedTime -= self.deltaTime;
        }

        self.lastTime = time;
    }

    function start() as Void { self.enqueue(); }

    function stop() as Void { self.timer.stop(); }

    function enqueue() as Void { self.timer.start(self.updateFn, 100, false); }

    function update() as Void {
        self.nextTick();
        self.enqueue();
    }
}
