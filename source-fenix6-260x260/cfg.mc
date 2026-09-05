using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

module cfg {
    const bufferWidth = 250;
    const bufferHeight = 250;
    const bufferDx = 5;
    const bufferDy = 5;

    const graphHeight = 10.0;
    const graphWidth = 40.0;
    const graphBarWidth = 3;
    const graphBarGap = 1;

    const minutesClockX = 130 - 5;
    const minutesClockY = 112 - 5;
    const analogClockX = 130;
    const analogClockY = 112;
    const analogClockClip = [70, 53, 128, 128];

    const secondsHandCoordinates = WatchUi.loadResource(Rez.JsonData.secondsCoordinates);
    const initClip = WatchUi.loadResource(Rez.JsonData.secondsClearClip);

    const digitalX = 130 - 5;
    const digitalY = 168 - 5;

    const chargeIconX = 76 - 5;
    const chargeIconY = 176 - 5;
    const bluetoothIconX = 76 - 5;
    const bluetoothIconY = 190 - 5;
    const alarmIconX = 182 - 5;
    const alarmIconY = 176 - 5;
    const vibrateIconX = 182 - 5;
    const vibrateIconY = 190 - 5;

    const barometerX = 58 - 5;
    const barometerY = 88 - 5;
    const barometerTextX = 55 - 5;
    const barometerTextY = 48 - 5;

    const heartRateX = 236 - 5;
    const heartRateY = 89 - 5;
    const heartRateTextX = 202 - 5;
    const heartRateTextY = 48 - 5;

    const stepsX = 240 - 5;
    const stepsY = 170 - 5;
    const stepsTextX = 226 - 5;
    const stepsTextY = 123 - 5;

    const batteryX = 114 - 5;
    const batteryY = 228 - 5;
    const batteryWidth = 31;
    const batteryHeight = 9;
    const batteryTextX = 130 - 5;
    const batteryTextY = 236 - 5;

    const calendarDateX = 28 - 5;
    const calendarDateY = 114 - 5;
    const calendarMonthX = 28 - 5;
    const calendarMonthY = 136 - 5;
    const calendarWeekDayX = 30 - 5;
    const calendarWeekDayY = 151 - 5;
    const calendarWeekDayFont = Graphics.FONT_GLANCE;

    const moonPhaseX = 46 - 5;
    const moonPhaseY = 184 - 5;

    const twilightX = 210 - 5;
    const twilightY = 184 - 5;

    const weatherX = 148 - 5;
    const weatherY = 14 - 5;
}
