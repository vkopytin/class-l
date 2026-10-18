using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

// Fenix 6 low-memory layout scaled to 280x280 (14/13).
module cfg {
    const bufferDx = 5;
    const bufferDy = 5;
    const bufferWidth = 275 - bufferDx;
    const bufferHeight = 275 - bufferDy;

    const graphHeight = 10.7692;
    const graphWidth = 43.0769;
    const graphBarWidth = 3;
    const graphBarGap = 1;

    const minutesClockX = 140 - bufferDx;
    const minutesClockY = 121 - bufferDy;
    const analogClockX = 140;
    const analogClockY = 121;
    const analogClockClip = [75, 57, 138, 138];

    const secondsHandCoordinates = WatchUi.loadResource(Rez.JsonData.secondsCoordinates);
    const initClip = WatchUi.loadResource(Rez.JsonData.secondsClearClip);

    const digitalX = 140 - bufferDx;
    const digitalY = 181 - bufferDy;

    const chargeIconX = 82 - bufferDx;
    const chargeIconY = 190 - bufferDy;
    const bluetoothIconX = 82 - bufferDx;
    const bluetoothIconY = 205 - bufferDy;
    const alarmIconX = 196 - bufferDx;
    const alarmIconY = 190 - bufferDy;
    const vibrateIconX = 196 - bufferDx;
    const vibrateIconY = 205 - bufferDy;

    const barometerX = 62 - bufferDx;
    const barometerY = 95 - bufferDy;
    const barometerTextX = 59 - bufferDx;
    const barometerTextY = 52 - bufferDy;

    const heartRateX = 254 - bufferDx;
    const heartRateY = 96 - bufferDy;
    const heartRateTextX = 218 - bufferDx;
    const heartRateTextY = 52 - bufferDy;

    const stepsX = 258 - bufferDx;
    const stepsY = 183 - bufferDy;
    const stepsTextX = 243 - bufferDx;
    const stepsTextY = 132 - bufferDy;

    const batteryX = 123 - bufferDx;
    const batteryY = 246 - bufferDy;
    const batteryWidth = 33;
    const batteryHeight = 12;
    const batteryTextX = 140 - bufferDx;
    const batteryTextY = 254 - bufferDy;

    const calendarDateX = 30 - bufferDx;
    const calendarDateY = 123 - bufferDy;
    const calendarMonthX = 30 - bufferDx;
    const calendarMonthY = 146 - bufferDy;
    const calendarWeekDayX = 32 - bufferDx;
    const calendarWeekDayY = 163 - bufferDy;
    const calendarWeekDayFont = Graphics.FONT_GLANCE;

    const moonPhaseX = 50 - bufferDx;
    const moonPhaseY = 198 - bufferDy;

    const twilightX = 226 - bufferDx;
    const twilightY = 198 - bufferDy;

    const weatherX = 159 - bufferDx;
    const weatherY = 15 - bufferDy;
}
