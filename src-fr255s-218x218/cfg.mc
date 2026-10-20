using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

// Fenix 7 bitmap rendering adapted to the native 218x218 board artwork.
module cfg {
    const bufferDx = 0;
    const bufferDy = 0;

    const bufferWidth = 218;
    const bufferHeight = 218;

    const graphHeight = 10.0;
    const graphWidth = 40.0;
    const graphBarWidth = 3;
    const graphBarGap = 1;

    const minutesClockX = 109.0;
    const minutesClockY = 93.9077;
    const analogClockX = 109.0;
    const analogClockY = 93.9077;
    const analogClockClip = [59, 44, 106, 106];
    const initClip = [[0.8385, 63.7231], [0.8385, 0.0], [10.0615, 0.0], [10.0615, 63.7231]];

    const digitalX = 109;
    const digitalY = 142;

    const chargeIconX = 64;
    const chargeIconY = 149;
    const bluetoothIconX = 64;
    const bluetoothIconY = 160;
    const alarmIconX = 153;
    const alarmIconY = 149;
    const vibrateIconX = 153;
    const vibrateIconY = 160;

    const barometerX = 49;
    const barometerY = 74;
    const barometerTextX = 46;
    const barometerTextY = 37;

    const heartRateX = 202;
    const heartRateY = 75;
    const heartRateTextX = 169;
    const heartRateTextY = 37;

    const stepsX = 201;
    const stepsY = 143;
    const stepsTextX = 189;
    const stepsTextY = 101;

    const batteryX = 95;
    const batteryY = 191;
    const batteryWidth = 29;
    const batteryHeight = 8;
    const batteryTextX = 110;
    const batteryTextY = 196;

    const calendarDateX = 23;
    const calendarDateY = 96;
    const calendarMonthX = 23;
    const calendarMonthY = 113;
    const calendarWeekDayX = 25;
    const calendarWeekDayY = 127;
    const calendarWeekDayFont = Graphics.FONT_GLANCE;

    const moonPhaseX = 34;
    const moonPhaseY = 162;

    const twilightX = 168;
    const twilightY = 154;

    const weatherX = 109;
    const weatherY = 12;
}
