using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

module cfg {
    const bufferWidth = 229 - 6;
    const bufferHeight = 233 - 6;
    const bufferDx = 6;
    const bufferDy = 6;

    const graphHeight = 10.0;
    const graphWidth = 40.0;
    const graphBarWidth = 3;
    const graphBarGap = 1;

    const minutesClockX = 120 - 6;
    const minutesClockY = 103 - 6;
    const analogClockX = 120;
    const analogClockY = 103;
    const analogClockClip = [70 - 6, 53 - 6, 127, 127];

    const secondsHandCoordinates = WatchUi.loadResource(Rez.JsonData.secondsCoordinates);
    const initClip = WatchUi.loadResource(Rez.JsonData.secondsClearClip);

    const digitalX = 120 - 6;
    const digitalY = 158 - 6;

    const chargeIconX = 71 - 6;
    const chargeIconY = 162 - 6;
    const bluetoothIconX = 71 - 6;
    const bluetoothIconY = 177 - 6;
    const alarmIconX = 168 - 6;
    const alarmIconY = 162 - 6;
    const vibrateIconX = 168 - 6;
    const vibrateIconY = 177 - 6;

    const barometerX = 54 - 6;
    const barometerY = 82 - 6;
    const barometerTextX = 55 - 6;
    const barometerTextY = 42 - 6;

    const heartRateX = 216 - 6;
    const heartRateY = 83 - 6;
    const heartRateTextX = 186 - 6;
    const heartRateTextY = 39 - 6;

    const stepsX = 180 - 6;
    const stepsY = 100 - 6;
    const stepsTextX = 206 - 6;
    const stepsTextY = 112 - 6;

    const batteryX = 105 - 6;
    const batteryY = 211 - 6;
    const batteryWidth = 31;
    const batteryHeight = 8;
    const batteryTextX = 120 - 6;
    const batteryTextY = 216 - 6;

    const calendarDateX = 28 - 6;
    const calendarDateY = 104 - 6;
    const calendarMonthX = 28 - 6;
    const calendarMonthY = 121 - 6;
    const calendarWeekDayX = 30 - 6;
    const calendarWeekDayY = 138 - 6;
    const calendarWeekDayFont = :segoe;

    const moonPhaseX = 43 - 6;
    const moonPhaseY = 170 - 6;

    const twilightX = 196 - 6;
    const twilightY = 168 - 6;

    const weatherX = 130 - 6;
    const weatherY = 10 - 6;
}
