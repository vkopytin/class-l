using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

module cfg {
    const bufferDx = 5;
    const bufferDy = 5;
    const bufferWidth = 255 - bufferDx;
    const bufferHeight = 255 - bufferDy;

    const graphHeight = 10.0;
    const graphWidth = 40.0;
    const graphBarWidth = 3;
    const graphBarGap = 1;

    const minutesClockX = 130 - bufferDx;
    const minutesClockY = 112 - bufferDy;
    const analogClockX = 130;
    const analogClockY = 112;
    const analogClockClip = [70, 53, 128, 128];

    const secondsHandCoordinates = WatchUi.loadResource(Rez.JsonData.secondsCoordinates);
    const initClip = WatchUi.loadResource(Rez.JsonData.secondsClearClip);

    const digitalX = 130 - bufferDx;
    const digitalY = 168 - bufferDy;

    const chargeIconX = 76 - bufferDx;
    const chargeIconY = 176 - bufferDy;
    const bluetoothIconX = 76 - bufferDx;
    const bluetoothIconY = 190 - bufferDy;
    const alarmIconX = 182 - bufferDx;
    const alarmIconY = 176 - bufferDy;
    const vibrateIconX = 182 - bufferDx;
    const vibrateIconY = 190 - bufferDy;

    const barometerX = 58 - bufferDx;
    const barometerY = 88 - bufferDy;
    const barometerTextX = 55 - bufferDx;
    const barometerTextY = 48 - bufferDy;

    const heartRateX = 236 - bufferDx;
    const heartRateY = 89 - bufferDy;
    const heartRateTextX = 202 - bufferDx;
    const heartRateTextY = 48 - bufferDy;

    const stepsX = 240 - bufferDx;
    const stepsY = 170 - bufferDy;
    const stepsTextX = 226 - bufferDx;
    const stepsTextY = 123 - bufferDy;

    const batteryX = 114 - bufferDx;
    const batteryY = 228 - bufferDy;
    const batteryWidth = 31;
    const batteryHeight = 9;
    const batteryTextX = 130 - bufferDx;
    const batteryTextY = 236 - bufferDy;

    const calendarDateX = 28 - bufferDx;
    const calendarDateY = 114 - bufferDy;
    const calendarMonthX = 28 - bufferDx;
    const calendarMonthY = 136 - bufferDy;
    const calendarWeekDayX = 30 - bufferDx;
    const calendarWeekDayY = 151 - bufferDy;
    const calendarWeekDayFont = Graphics.FONT_GLANCE;

    const moonPhaseX = 46 - bufferDx;
    const moonPhaseY = 184 - bufferDy;

    const twilightX = 210 - bufferDx;
    const twilightY = 184 - bufferDy;

    const weatherX = 148 - bufferDx;
    const weatherY = 14 - bufferDy;
}
