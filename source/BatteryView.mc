import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

class BatteryView extends WatchUi.Drawable {
    private var label as WatchUi.Text?;
    private var color = Graphics.COLOR_PURPLE;
    private var batteryLevel = 100;
    private var batteryLevelBitmap = null as WatchUi.BitmapResource;
    private var batteryLevelTexture = null as Graphics.BitmapTexture;
    private var forceRedraw = true;
    private var clearRect = [0, 0, 0, 0];
    private var back = null as Graphics.BufferedBitmap;

    function setLabel(label as WatchUi.Text or Null) { self.label = label; }
    function setValue(value as Lang.Number) { self.batteryLevel = value; }
    function setBack(bb as Graphics.BufferedBitmap) { self.back = bb; }

    function initialize(params) {

        Drawable.initialize(params as Lang.Dictionary);

        if (params.hasKey(:color)) {
            self.color = params.get(:color);
        }
        if (params.hasKey(:clearRect)) {
            self.clearRect = params.get(:clearRect);
        }
        self.batteryLevelBitmap = WatchUi.loadResource(Rez.Drawables.batteryLevel);
        self.batteryLevelTexture = new Graphics.BitmapTexture({ :bitmap => self.batteryLevelBitmap });
    }

    public function setText(text as Lang.String) as Void { self.label.setText(text); }

    public function updateData() {
        var stats = System.getSystemStats();
        if (self.batteryLevel == stats.battery) {
            return;
        }
        self.batteryLevel = stats.battery;
        self.label.setText(Lang.format("$1$%", [self.batteryLevel.format("%d")]));
        self.forceRedraw = true;
    }

    function draw(dc as Dc) {
        if (!self.forceRedraw) {
            return;
        }
        self.forceRedraw = false;

        Drawable.draw(dc);

        if (self.back == null) {
            dc.setPenWidth(1);
            dc.drawRectangle(self.clearRect[0], self.clearRect[1], self.clearRect[2], self.clearRect[3]);
        } else {
            dc.setClip(self.clearRect[0], self.clearRect[1], self.clearRect[2], self.clearRect[3]);
            dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
            dc.clear();
        }

        self.label.draw(dc);
        dc.setColor(self.color, Graphics.COLOR_TRANSPARENT);
        var barWidth = self.width * self.batteryLevel / 100.0;
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setFill(self.batteryLevelTexture);
        dc.fillRectangle(self.locX, self.locY, barWidth, self.height);
    }

}
