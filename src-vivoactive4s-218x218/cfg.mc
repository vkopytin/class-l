using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

// Fenix 6X low-memory layout scaled to 218x218 for Vivoactive 4S.
module cfg {
    const bufferDx = 4;
    const bufferDy = 4;
    const bufferWidth = 214 - bufferDx;
    const bufferHeight = 214 - bufferDy;

    const graphHeight = 10.0;
    const graphWidth = 40.0;
    const graphBarWidth = 3;
    const graphBarGap = 1;

    const minutesClockX = 109 - bufferDx;
    const minutesClockY = 94 - bufferDy;
    const analogClockX = 109;
    const analogClockY = 94;
    const analogClockClip = [58, 44, 107, 107];

    const secondsHandCoordinates = WatchUi.loadResource(Rez.JsonData.secondsCoordinates);
    const initClip = WatchUi.loadResource(Rez.JsonData.secondsClearClip);

    const digitalX = 109 - bufferDx;
    const digitalY = 141 - bufferDy;

    const chargeIconX = 64 - bufferDx;
    const chargeIconY = 148 - bufferDy;
    const bluetoothIconX = 64 - bufferDx;
    const bluetoothIconY = 160 - bufferDy;
    const alarmIconX = 153 - bufferDx;
    const alarmIconY = 148 - bufferDy;
    const vibrateIconX = 153 - bufferDx;
    const vibrateIconY = 160 - bufferDy;

    const barometerX = 49 - bufferDx;
    const barometerY = 74 - bufferDy;
    const barometerTextX = 46 - bufferDx;
    const barometerTextY = 40 - bufferDy;

    const heartRateX = 203 - bufferDx;
    const heartRateY = 75 - bufferDy;
    const heartRateTextX = 170 - bufferDx;
    const heartRateTextY = 40 - bufferDy;

    const stepsX = 201 - bufferDx;
    const stepsY = 142 - bufferDy;
    const stepsTextX = 189 - bufferDx;
    const stepsTextY = 103 - bufferDy;

    const batteryX = 95 - bufferDx;
    const batteryY = 191 - bufferDy;
    const batteryWidth = 29;
    const batteryHeight = 8;
    const batteryTextX = 109 - bufferDx;
    const batteryTextY = 198 - bufferDy;

    const calendarDateX = 23 - bufferDx;
    const calendarDateY = 96 - bufferDy;
    const calendarMonthX = 23 - bufferDx;
    const calendarMonthY = 114 - bufferDy;
    const calendarWeekDayX = 25 - bufferDx;
    const calendarWeekDayY = 127 - bufferDy;
    const calendarWeekDayFont = Graphics.FONT_GLANCE;

    const moonPhaseX = 39 - bufferDx;
    const moonPhaseY = 154 - bufferDy;

    const twilightX = 176 - bufferDx;
    const twilightY = 154 - bufferDy;

    const weatherX = 124 - bufferDx;
    const weatherY = 12 - bufferDy;
}
