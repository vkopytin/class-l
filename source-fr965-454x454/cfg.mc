module cfg {
    // Screen dimensions: 454 x 454
    const clockX = 227;
    const clockY = 195;

    const hourKnobPivotX = -13.0;
    const hourKnobPivotY = -66.0;

    const minuteKnobPivotX = -10.0;
    const minuteKnobPivotY = -88.0;

    const secondsClockTextureX = 16;
    const secondsClockTextureY = 132;

    const secondsKnobPivotX = -8.0;
    const secondsKnobPivotY = -92.0;

    const secondsClipRegion = [[1.0, 132.0], [1.0, 0.0], [14.0, 0.0], [14.0, 132.0]];

    const sunsetX = 227;
    const sunsetY = 227;
    const sunsetRadius = 226;

    const moonPhaseX = 60;
    const moonPhaseY = 333;
    const moonPhaseTileSize = 30;
    const moonTileCoords = [
        [22, 22],  [70, 22],  [119, 22],  [167, 22],  [216, 22],  [264, 22],  [22, 80],   [70, 80],   [119, 80],
        [167, 80], [216, 80], [264, 80],  [22, 138],  [70, 138],  [119, 138], [167, 138], [216, 138], [264, 138],
        [22, 196], [70, 196], [119, 196], [167, 196], [216, 196], [264, 196], [22, 255],  [70, 255]
    ];

    const batteryX = 199;
    const batteryY = 398;
    const batteryWidth = 55;
    const batteryHeight = 16;

    const barometerX = 20;
    const barometerY = 154;

    const heartRateX = 82;
    const heartRateY = 154;

    const graphHeight = 20.0;
    const graphBarWidth = 5;
    const graphBarGap = 3;

    const stepsX = 84;
    const stepsY = 295;

    const twilightX = 346;
    const twilightY = 320;
    const twilightTileSize = 48;
    const twilightCoords = [[0, 0], [69, 0], [134, 0], [198, 0], [268, 0]];
}
