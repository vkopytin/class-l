using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

module cfg {
    const bufferWidth = 260;
    const bufferHeight = 260;
    const bufferDx = 0;
    const bufferDy = 0;

    const graphHeight = 10.0;
    const graphWidth = 40.0;
    const graphBarWidth = 3;
    const graphBarGap = 1;

    const minutesClockX = 130.0;
    const minutesClockY = 112.0;
    const analogClockX = 130.0;
    const analogClockY = 112.0;
    const analogClockClip = [70, 53, 127, 127];
    const initClip = [[1.0, 76.0], [1.0, 0.0], [12.0, 0.0], [12.0, 76.0]];

    const digitalX = 130;
    const digitalY = 168;

    const chargeIconX = 76;
    const chargeIconY = 176;
    const bluetoothIconX = 76;
    const bluetoothIconY = 190;
    const alarmIconX = 182;
    const alarmIconY = 176;
    const vibrateIconX = 182;
    const vibrateIconY = 190;

    const barometerX = 58;
    const barometerY = 88;
    const barometerTextX = 55;
    const barometerTextY = 48;

    const heartRateX = 236;
    const heartRateY = 89;
    const heartRateTextX = 202;
    const heartRateTextY = 48;

    const stepsX = 240;
    const stepsY = 170;
    const stepsTextX = 226;
    const stepsTextY = 123;

    const batteryX = 114;
    const batteryY = 228;
    const batteryWidth = 31;
    const batteryHeight = 9;
    const batteryTextX = 130;
    const batteryTextY = 236;

    const calendarDateX = 28;
    const calendarDateY = 114;
    const calendarMonthX = 28;
    const calendarMonthY = 136;
    const calendarWeekDayX = 30;
    const calendarWeekDayY = 151;
    const calendarWeekDayFont = Graphics.FONT_GLANCE;

    const moonPhaseX = 40;
    const moonPhaseY = 193;

    const twilightX = 200;
    const twilightY = 184;

    const weatherX = 130;
    const weatherY = 14;
}
