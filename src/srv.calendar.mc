using Toybox.Graphics;
using Toybox.Time.Gregorian as Date;
using Toybox.Time;
using Toybox.WatchUi;
using Toybox.Lang;

module srv {

    module calendar {
        var weekDay = "";
        var weekDayColor = 0x55AAAA;
        var month = "";
        var date = "24";

        function update() as Void {
            var dInf = Date.info(Time.now(), Time.FORMAT_SHORT);

            var WEEK_DAYS_OR_MONTHS = WatchUi.loadResource(Rez.JsonData.weekDays);
            self.weekDay = WEEK_DAYS_OR_MONTHS[dInf.day_of_week];
            self.weekDayColor = dInf.day_of_week == Date.DAY_SUNDAY ? 0xFF5500 : 0x55AAAA;

            WEEK_DAYS_OR_MONTHS = WatchUi.loadResource(Rez.JsonData.monthNames);
            self.month = WEEK_DAYS_OR_MONTHS[dInf.month];

            self.date = dInf.day.format("%02d");
        }

        function draw(dc as Graphics.Dc) as Void {
            dc.setColor(0xFF5500, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cfg.calendarDateX, cfg.calendarDateY, Graphics.FONT_TINY, self.date,
                        Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cfg.calendarMonthX, cfg.calendarMonthY, Graphics.FONT_GLANCE, self.month,
                        Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(self.weekDayColor, Graphics.COLOR_TRANSPARENT);
            if (cfg.calendarWeekDayFont == :segoe) {
                lib.drawTextXTiny(dc, cfg.calendarWeekDayX, cfg.calendarWeekDayY, self.weekDay,
                                  Graphics.TEXT_JUSTIFY_CENTER);
            } else {
                dc.drawText(cfg.calendarWeekDayX, cfg.calendarWeekDayY,
                            cfg.calendarWeekDayFont as Graphics.FontDefinition, self.weekDay,
                            Graphics.TEXT_JUSTIFY_CENTER);
            }
        }
    }
}
