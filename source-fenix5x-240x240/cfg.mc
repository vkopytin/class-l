using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

module cfg {
    const bufferDx = 6;
    const bufferDy = 6;
    const bufferWidth = 229 - bufferDx;
    const bufferHeight = 233 - bufferDy;

    const graphHeight = 10.0;
    const graphWidth = 40.0;
    const graphBarWidth = 3;
    const graphBarGap = 1;

    const minutesClockX = 120 - bufferDx;
    const minutesClockY = 103 - bufferDy;
    const analogClockX = 120;
    const analogClockY = 103;
    const analogClockClip = [70 - bufferDx, 53 - bufferDy, 127, 127];

    const secondsHandCoordinates = WatchUi.loadResource(Rez.JsonData.secondsCoordinates);
    const initClip = WatchUi.loadResource(Rez.JsonData.secondsClearClip);

    const digitalX = 120 - bufferDx;
    const digitalY = 158 - bufferDy;

    const chargeIconX = 71 - bufferDx;
    const chargeIconY = 162 - bufferDy;
    const bluetoothIconX = 71 - bufferDx;
    const bluetoothIconY = 177 - bufferDy;
    const alarmIconX = 168 - bufferDx;
    const alarmIconY = 162 - bufferDy;
    const vibrateIconX = 168 - bufferDx;
    const vibrateIconY = 177 - bufferDy;

    const barometerX = 54 - bufferDx;
    const barometerY = 82 - bufferDy;
    const barometerTextX = 55 - bufferDx;
    const barometerTextY = 42 - bufferDy;

    const heartRateX = 216 - bufferDx;
    const heartRateY = 83 - bufferDy;
    const heartRateTextX = 186 - bufferDx;
    const heartRateTextY = 39 - bufferDy;

    const stepsX = 180 - bufferDx;
    const stepsY = 100 - bufferDy;
    const stepsTextX = 206 - bufferDx;
    const stepsTextY = 112 - bufferDy;

    const batteryX = 105 - bufferDx;
    const batteryY = 211 - bufferDy;
    const batteryWidth = 31;
    const batteryHeight = 8;
    const batteryTextX = 120 - bufferDx;
    const batteryTextY = 216 - bufferDy;

    const calendarDateX = 28 - bufferDx;
    const calendarDateY = 104 - bufferDy;
    const calendarMonthX = 28 - bufferDx;
    const calendarMonthY = 121 - bufferDy;
    const calendarWeekDayX = 30 - bufferDx;
    const calendarWeekDayY = 138 - bufferDy;
    const calendarWeekDayFont = :segoe;

    const moonPhaseX = 43 - bufferDx;
    const moonPhaseY = 170 - bufferDy;

    const twilightX = 196 - bufferDx;
    const twilightY = 168 - bufferDy;

    const weatherX = 130 - bufferDx;
    const weatherY = 10 - bufferDy;
}
