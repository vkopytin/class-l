using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

// FR965 OLED layout scaled from 454x454 to 416x416.
module cfg {
    const bufferDx = 0;
    const bufferDy = 0;
    const bufferWidth = 416;
    const bufferHeight = 416;

    const graphHeight = 18.326;
    const graphWidth = 73.304;
    const graphBarWidth = 5;
    const graphBarGap = 2;

    const minutesClockX = 208.0;
    const minutesClockY = 178.678;
    const analogClockX = 208.0;
    const analogClockY = 178.678;
    const analogClockClip = [64, 49, 116, 116];
    const initClip = [[-3.665, 19.242], [-3.665, -46.731], [7.33, -46.731], [7.33, 19.242]];

    const digitalX = 208;
    const digitalY = 275;

    const chargeIconX = 123;
    const chargeIconY = 279;
    const bluetoothIconX = 123;
    const bluetoothIconY = 309;
    const alarmIconX = 291;
    const alarmIconY = 279;
    const vibrateIconX = 291;
    const vibrateIconY = 309;

    const barometerX = 92;
    const barometerY = 141;
    const barometerTextX = 93;
    const barometerTextY = 73;

    const heartRateX = 380;
    const heartRateY = 143;
    const heartRateTextX = 326;
    const heartRateTextY = 76;

    const stepsX = 384;
    const stepsY = 274;
    const stepsTextX = 363;
    const stepsTextY = 197;

    const batteryX = 182;
    const batteryY = 365;
    const batteryWidth = 50;
    const batteryHeight = 15;
    const batteryTextX = 208;
    const batteryTextY = 378;

    const calendarDateX = 51;
    const calendarDateY = 183;
    const calendarMonthX = 51;
    const calendarMonthY = 212;
    const calendarWeekDayX = 55;
    const calendarWeekDayY = 244;
    const calendarWeekDayFont = Graphics.FONT_XTINY;

    const moonPhaseX = 60;
    const moonPhaseY = 305;

    const twilightX = 317;
    const twilightY = 293;

    const weatherX = 208;
    const weatherY = 27;
}
