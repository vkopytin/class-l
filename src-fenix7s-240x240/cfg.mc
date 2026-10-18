using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

// Fenix 7 bitmap layout scaled to 240x240 (12/13).
module cfg {
    const bufferDx = 0;
    const bufferDy = 0;

    const bufferWidth = 240;
    const bufferHeight = 240;

    const graphHeight = 9.2308;
    const graphWidth = 36.9231;
    const graphBarWidth = 3;
    const graphBarGap = 1;

    const minutesClockX = 120.0;
    const minutesClockY = 103.3846;
    const analogClockX = 120.0;
    const analogClockY = 103.3846;
    const analogClockClip = [65, 49, 117, 117];
    const initClip = [[0.9231, 70.1538], [0.9231, 0.0], [11.0769, 0.0], [11.0769, 70.1538]];

    const digitalX = 120;
    const digitalY = 155;

    const chargeIconX = 70;
    const chargeIconY = 162;
    const bluetoothIconX = 70;
    const bluetoothIconY = 175;
    const alarmIconX = 168;
    const alarmIconY = 162;
    const vibrateIconX = 168;
    const vibrateIconY = 175;

    const barometerX = 54;
    const barometerY = 81;
    const barometerTextX = 51;
    const barometerTextY = 44;

    const heartRateX = 218;
    const heartRateY = 82;
    const heartRateTextX = 186;
    const heartRateTextY = 44;

    const stepsX = 222;
    const stepsY = 157;
    const stepsTextX = 209;
    const stepsTextY = 114;

    const batteryX = 105;
    const batteryY = 210;
    const batteryWidth = 31;
    const batteryHeight = 9;
    const batteryTextX = 120;
    const batteryTextY = 218;

    const calendarDateX = 26;
    const calendarDateY = 105;
    const calendarMonthX = 26;
    const calendarMonthY = 126;
    const calendarWeekDayX = 28;
    const calendarWeekDayY = 139;
    const calendarWeekDayFont = Graphics.FONT_GLANCE;

    const moonPhaseX = 37;
    const moonPhaseY = 178;

    const twilightX = 185;
    const twilightY = 170;

    const weatherX = 120;
    const weatherY = 13;
}
