import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;

class TextBlockView extends WatchUi.Drawable {
    private var color = Graphics.COLOR_PURPLE;
    private var font = Graphics.FONT_XTINY;
    private var text = "";
    private var justification = Graphics.TEXT_JUSTIFY_LEFT;
    private var forceRedraw = true;
    private var back = null as Graphics.BufferedBitmap;
    private var padding = [0, 0, 0, 0];

    function setText(label as String) {
        if (self.text.equals(label)) {
            return;
        }
        self.text = label;
        self.forceRedraw = true;
    }
    function setFont(font as Graphics.FontType) { self.font = font; }
    function setColor(color as Graphics.Color) { self.color = color; }
    function setJustification(justification as Graphics.TextJustify) { self.justification = justification; }
    function setBack(bb as Graphics.BufferedBitmap) { self.back = bb; }

    function initialize(params) {

        Drawable.initialize(params as Lang.Dictionary);

        if (params.hasKey(:color)) {
            self.color = params.get(:color);
        }
        if (params.hasKey(:font)) {
            self.font = params.get(:font);
        }
        if (params.hasKey(:text)) {
            self.text = params.get(:text);
        }
        if (params.hasKey(:color)) {
            self.color = params.get(:color);
        }
        if (params.hasKey(:justification)) {
            self.justification = params.get(:justification);
        }
        if (params.hasKey(:padding)) {
            self.padding = params.get(:padding);
        }
    }

    public function updateData() {

    }

    function draw(dc as Dc) {
        if (!self.forceRedraw) {
            return;
        }
        self.forceRedraw = false;

        Drawable.draw(dc);

        var clearRegion = dc.getTextDimensions(self.text, self.font);
        var boxX = self.locX;
        if (self.justification == Graphics.TEXT_JUSTIFY_CENTER) {
            boxX = locX - (clearRegion[0] / 2);
        } else if (self.justification == Graphics.TEXT_JUSTIFY_RIGHT) {
            boxX = self.locX - clearRegion[0];
        }

        if (self.back == null) {
            dc.setPenWidth(1);
            dc.drawRectangle(boxX - self.padding[0], self.locY - self.padding[1],
                             clearRegion[0] + self.padding[2] + self.padding[0],
                             clearRegion[1] + self.padding[3] + self.padding[1]);
        } else {
            dc.setClip(boxX - self.padding[0], self.locY - self.padding[1],
                       clearRegion[0] + self.padding[2] + self.padding[0],
                       clearRegion[1] + self.padding[3] + self.padding[1]);
            dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
            dc.clear();
        }

        dc.setColor(self.color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(self.locX, self.locY, self.font, self.text, self.justification);
    }

}
