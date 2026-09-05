using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;

module srv {

    module digital {
        var time = "20:20";
        var bluetooth = "\uE1A9";
        var bluetoothColor = 0x000055;
        var alarmColor = 0x000055;
        var vibrateColor = 0x000055;
        var charge = "\uE3E5";
        var chargeColor = 0x000055;
        var clockTime = System.getClockTime();

        function update() as Void {
            self.clockTime = System.getClockTime();

            self.time = Lang.format("$1$:$2$", [self.clockTime.hour.format("%02d"), self.clockTime.min.format("%02d")]);

            var settings = Toybox.System.getDeviceSettings();
            if (settings.phoneConnected) {
                self.bluetooth = ("\uE1A8");
                self.bluetoothColor = (0x55AAAA);
            } else {
                self.bluetooth = ("\uE1A9");
                self.bluetoothColor = (0x000055);
            }

            if (settings.alarmCount > 0) {
                self.alarmColor = (0x55AAAA);
            } else {
                self.alarmColor = (0x000055);
            }

            if (settings.vibrateOn) {
                self.vibrateColor = (0x55AAAA);
            } else {
                self.vibrateColor = (0x000055);
            }

            var stats = System.getSystemStats();
            if (stats has :solarIntensity && stats.solarIntensity != null) {
                if (stats.solarIntensity > 49) {
                    self.charge = ("\uE1AC");
                    self.chargeColor = (0x55AAAA);
                } else if (stats.solarIntensity > 24) {
                    self.charge = ("\uE1AE");
                    self.chargeColor = (0x55AAAA);
                } else if (stats.solarIntensity > 0) {
                    self.charge = ("\uE1AD");
                    self.chargeColor = (0x55AAAA);
                } else {
                    self.charge = ("\uE1AD");
                    self.chargeColor = (0x000055);
                }
            } else {
                if (stats.charging) {
                    self.charge = ("\uE3E5");
                    self.chargeColor = (0x55AAAA);
                } else {
                    self.charge = ("\uE3E5");
                    self.chargeColor = (0x000055);
                }
            }
        }

        function draw(dc as Graphics.Dc) as Void {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cfg.digitalX, cfg.digitalY, Graphics.FONT_LARGE, self.time, Graphics.TEXT_JUSTIFY_CENTER);

            var font = WatchUi.loadResource(Rez.Fonts.system);
            dc.setColor(self.chargeColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cfg.chargeIconX, cfg.chargeIconY, font, self.charge, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(bluetoothColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cfg.bluetoothIconX, cfg.bluetoothIconY, font, self.bluetooth, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(self.alarmColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cfg.alarmIconX, cfg.alarmIconY, font, "\uE190", Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(self.vibrateColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cfg.vibrateIconX, cfg.vibrateIconY, font, "\uE62D", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
