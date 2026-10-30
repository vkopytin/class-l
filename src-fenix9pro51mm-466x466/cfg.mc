using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

// FR965 OLED layout scaled from 454x454 to 466x466 (233/227).
module cfg {
    const bufferDx = 0;
    const bufferDy = 0;
    const bufferWidth = 466;
    const bufferHeight = 466;

    const graphHeight = 20.5286;
    const graphWidth = 82.1145;
    const graphBarWidth = 5;
    const graphBarGap = 2;

    const minutesClockX = 233.0;
    const minutesClockY = 200.1542;
    const analogClockX = 233.0;
    const analogClockY = 200.1542;
    const analogClockClip = [72, 54, 130, 130];
    const initClip = [[-4.1057, 21.5551], [-4.1057, -52.348], [8.2115, -52.348], [8.2115, 21.5551]];

    const digitalX = 233;
    const digitalY = 308;

    const chargeIconX = 138;
    const chargeIconY = 313;
    const bluetoothIconX = 138;
    const bluetoothIconY = 346;
    const alarmIconX = 326;
    const alarmIconY = 313;
    const vibrateIconX = 326;
    const vibrateIconY = 346;

    const barometerX = 103;
    const barometerY = 158;
    const barometerTextX = 104;
    const barometerTextY = 82;

    const heartRateX = 421;
    const heartRateY = 160;
    const heartRateTextX = 365;
    const heartRateTextY = 85;

    const stepsX = 426;
    const stepsY = 304;
    const stepsTextX = 406;
    const stepsTextY = 221;

    const batteryX = 204;
    const batteryY = 409;
    const batteryWidth = 56;
    const batteryHeight = 16;
    const batteryTextX = 233;
    const batteryTextY = 424;

    const calendarDateX = 57;
    const calendarDateY = 205;
    const calendarMonthX = 57;
    const calendarMonthY = 238;
    const calendarWeekDayX = 62;
    const calendarWeekDayY = 268;
    const calendarWeekDayFont = Graphics.FONT_XTINY;

    const moonPhaseX = 68;
    const moonPhaseY = 342;

    const twilightX = 355;
    const twilightY = 328;

    const weatherX = 233;
    const weatherY = 31;
}
