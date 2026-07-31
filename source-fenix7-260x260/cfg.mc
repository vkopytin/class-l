module cfg {
    // Screen dimensions: 260 x 260
    const clockX = 130;
    const clockY = 112;

    const hourKnobPivotX = -10.0;
    const hourKnobPivotY = -38.0;

    const minuteKnobPivotX = -9.0;
    const minuteKnobPivotY = -59.0;

    const secondsClockTextureX = 16;
    const secondsClockTextureY = 132;

    const secondsKnobPivotX = -5.0;
    const secondsKnobPivotY = -54.0;

    const secondsClipRegion = [[1.0, 76.0], [1.0, 0.0], [10.0, 0.0], [10.0, 76.0]];

    const sunsetX = 130;
    const sunsetY = 130;
    const sunsetRadius = 130;

    const moonPhaseX = 40;
    const moonPhaseY = 193;
    const moonPhaseTileSize = 20;
    const moonTileCoords = [
        [15, 15],  [48, 15],  [80, 15],  [113, 15], [146, 15],  [178, 15],  [15, 54],   [48, 54],  [80, 54],
        [113, 54], [146, 54], [178, 54], [15, 94],  [15, 94],   [48, 94],   [80, 94],   [113, 94], [146, 94],
        [178, 94], [15, 133], [48, 133], [80, 133], [113, 133], [146, 133], [178, 133], [15, 173]
    ];

    const batteryX = 114;
    const batteryY = 228;
    const batteryWidth = 31;
    const batteryHeight = 9;

    const barometerX = 19;
    const barometerY = 88;

    const heartRateX = 79;
    const heartRateY = 88;

    const graphHeight = 10.0;
    const graphBarWidth = 3;
    const graphBarGap = 2;

    const stepsX = 78;
    const stepsY = 168;

    const twilightX = 200;
    const twilightY = 184;
    const twilightTileSize = 24;
    const twilightCoords = [[0, 0], [33, 0], [66, 0], [98, 0], [133, 0]];
}
