using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

// FR965 OLED layout scaled to 390x390 for the original Venu.
module cfg {
    const bufferDx = 0;
    const bufferDy = 0;
    const bufferWidth = 390;
    const bufferHeight = 390;

    const graphHeight = 17.1806;
    const graphWidth = 68.7225;
    const graphBarWidth = 4;
    const graphBarGap = 2;

    const minutesClockX = 195.0;
    const minutesClockY = 167.511;
    const analogClockX = 195.0;
    const analogClockY = 167.511;
    // Fill the entire buffer so text blends against the opaque artwork.
    const analogClockClip = [0, 0, bufferWidth, bufferHeight];
    const initClip = [[-9.0, -81.0], [-9.0, 36.0], [9.0, 36.0], [9.0, -81.0]];

    const digitalX = 195;
    const digitalY = 258;

    const chargeIconX = 115;
    const chargeIconY = 262;
    const bluetoothIconX = 115;
    const bluetoothIconY = 289;
    const alarmIconX = 273;
    const alarmIconY = 262;
    const vibrateIconX = 273;
    const vibrateIconY = 289;

    const barometerX = 86;
    const barometerY = 132;
    const barometerTextX = 87;
    const barometerTextY = 69;

    const heartRateX = 352;
    const heartRateY = 134;
    const heartRateTextX = 306;
    const heartRateTextY = 71;

    const stepsX = 206;
    const stepsY = 146;
    const stepsTextX = 340;
    const stepsTextY = 185;

    const batteryX = 171;
    const batteryY = 342;
    const batteryWidth = 47;
    const batteryHeight = 14;
    const batteryTextX = 195;
    const batteryTextY = 355;

    const calendarDateX = 48;
    const calendarDateY = 172;
    const calendarMonthX = 48;
    const calendarMonthY = 199;
    const calendarWeekDayX = 52;
    const calendarWeekDayY = 224;
    const calendarWeekDayFont = Graphics.FONT_XTINY;

    const moonPhaseX = 57;
    const moonPhaseY = 286;

    const twilightX = 297;
    const twilightY = 275;

    const weatherX = 195;
    const weatherY = 26;

}
