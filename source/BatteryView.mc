import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

class BatteryView extends WatchUi.Drawable {
    private var label as WatchUi.Text?;
    private var color = Graphics.COLOR_PURPLE;

    function setLabel(label as WatchUi.Text or Null) {
        self.label = label;
    }

    function initialize(params) {

        Drawable.initialize(params);

        if (params.hasKey(:color)) {
            self.color = params.get(:color);
        }

    }

    public function setText(text as Lang.String) as Void {
        self.label.setText(text);
    }

    public function updateData() {

    }

    function draw(dc as Dc) {

        Drawable.draw(dc);

        self.label.draw(dc);
        dc.setColor(self.color, Graphics.COLOR_TRANSPARENT);
    }

}
