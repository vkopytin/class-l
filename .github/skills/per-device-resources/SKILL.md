# Connect IQ Per-Device Resources Skill

Guidance for implementing device-specific resources (images, fonts, configurations) in multi-device Garmin Connect IQ projects using proper build-time separation via `monkey.jungle`.

## When to Use This Skill

- **Multiple target devices with different display capabilities** (e.g., fēnix 5X, fēnix 6, fēnix 7, Forerunner 965)
- **Different resource requirements per device** (e.g., tiled backgrounds for low-memory devices vs full images for high-res displays)
- **Memory constraints** requiring device-specific optimization (ultra-low memory on fēnix5x)
- **Display type differences** (MIP vs AMOLED) requiring different rendering strategies

## Key Pattern: Device-Specific sourcePath

The proper way to handle multi-device resources in Monkey C is to use **device-specific source paths**, not runtime device detection:

```ini
# monkey.jungle
base.sourcePath = source
base.resourcePath = resources

# Each device gets its own implementation folder
fenix5x.sourcePath = $(base.sourcePath);source-fenix5x
fenix5x.resourcePath = $(base.resourcePath);resources-fenix5x

fenix7.sourcePath = $(base.sourcePath);source-fenix7
fenix7.resourcePath = $(base.resourcePath);resources-fenix7

fr965.sourcePath = $(base.sourcePath);source-fr965
fr965.resourcePath = $(base.resourcePath);resources-fr965
```

**Why this matters:**

- Compiler merges source folders in order (base first, then device-specific)
- If both contain the same module, the device-specific version **overrides** the base version
- Each device gets **only its own resources** from device-specific resourcePath
- Eliminates symbol resolution conflicts at compile time

## Anti-Pattern: Don't Do This

### ❌ Runtime Device Detection + Try-Catch

```monkey
// WRONG - Compiler generates symbols for ALL resources regardless
module BackgroundManager {
    function initialize() as Void {
        try {
            backgroundFull = Application.loadResource(Rez.Drawables.BackgroundFull);
        } catch (ex) {
            backgroundTiles = [];
            for (var i = 0; i < 16; i++) {
                backgroundTiles.add(Application.loadResource(Rez.Drawables.BackgroundTile_0 + i));
            }
        }
    }
}
```

**Problem**: Monkey C compiler generates Rez symbols for ALL resources in ALL drawables.xml files it finds, regardless of which ones exist. If BackgroundFull is only in fenix7/drawables.xml, fenix5x build will fail with "Undefined symbol ':BackgroundFull'" even with try-catch, because the symbol reference happens at compile-time.

### ❌ Function-Level Annotations Without Full Function Exclusion

```monkey
// WRONG - Excluded function is called by initialize()
module BackgroundManager {
    function initialize() as Void {
        loadTiledBackground();  // Error! This function is excluded on fenix7
        loadFullBackground();   // Error! This function is excluded on fenix5x
    }

    (:HasTiles) function loadTiledBackground() as Void { }
    (:HasFullBackground) function loadFullBackground() as Void { }
}
```

**Problem**: If you annotate individual functions for exclusion, but initialize() calls both unconditionally, the compiler will error on the non-existent function call. Annotations exclude the function definition but not its call site.

## Correct Pattern: Device-Specific Module Implementation

### 1. Create Device-Specific Source Folders

```
source/                      (shared code)
  ├─ WatchFaceView.mc
  ├─ DisplayManager.mc
  └─ (other shared modules)

source-fenix5x/              (fenix5x-specific)
  └─ BackgroundManager.mc    (tiled background, 16 tiles × 60×60)

source-fenix6/               (fenix6-specific)
  └─ BackgroundManager.mc    (tiled background, 16 tiles × 65×65)

source-fenix7/               (fenix7-specific)
  └─ BackgroundManager.mc    (full background, 260×260)

source-fr965/                (fr965-specific)
  └─ BackgroundManager.mc    (full background, 454×454)
```

### 2. Create Device-Specific Resource Folders

```
resources/                   (shared resources)
  └─ drawables.xml          (only common resources like launcher icon)

resources-fenix5x/
  └─ drawables/
      ├─ drawables.xml      (16 BackgroundTile_* declarations)
      └─ bg-*.png           (60×60 tile images)

resources-fenix6/
  └─ drawables/
      ├─ drawables.xml      (16 BackgroundTile_* declarations)
      └─ bg-*.png           (65×65 tile images)

resources-fenix7/
  └─ drawables/
      ├─ drawables.xml      (BackgroundFull declaration)
      └─ background.png     (260×260 full image)

resources-fr965/
  └─ drawables/
      ├─ drawables.xml      (BackgroundFull declaration)
      └─ background.png     (454×454 full image)
```

### 3. Configure monkey.jungle

```ini
# Base paths used by all devices
base.sourcePath = source
base.resourcePath = resources

# Device-specific configurations
fenix5x.sourcePath = $(base.sourcePath);source-fenix5x
fenix5x.resourcePath = $(base.resourcePath);resources-fenix5x

fenix6.sourcePath = $(base.sourcePath);source-fenix6
fenix6.resourcePath = $(base.resourcePath);resources-fenix6

fenix7.sourcePath = $(base.sourcePath);source-fenix7
fenix7.resourcePath = $(base.resourcePath);resources-fenix7

fr965.sourcePath = $(base.sourcePath);source-fr965
fr965.resourcePath = $(base.resourcePath);resources-fr965
```

### 4. Implement Device-Specific Module (Example: fenix5x)

```monkey
// source-fenix5x/BackgroundManager.mc
import Toybox.Graphics;
import Toybox.Application;

module BackgroundManager {

    const TILE_COUNT = 16;
    var backgroundTiles = null;
    var isReady = false;

    function initialize() as Void {
        backgroundTiles = [];
        try {
            // Load all 16 tiles - these resources ONLY exist in fenix5x
            backgroundTiles.add(Application.loadResource(Rez.Drawables.BackgroundTile_0));
            backgroundTiles.add(Application.loadResource(Rez.Drawables.BackgroundTile_1));
            // ... more tiles
            isReady = (backgroundTiles.size() == TILE_COUNT);
        } catch (ex) {
            System.println("Failed to load tiles: " + ex.getErrorMessage());
        }
    }

    function drawBackground(dc as Graphics.Dc) as Void {
        if (isReady && backgroundTiles != null) {
            drawTiledBackground(dc);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            dc.clear();
        }
    }

    function drawTiledBackground(dc as Graphics.Dc) as Void {
        // Render 4×4 grid of 60×60 tiles
        // ...
    }
}
```

### 5. Implement Device-Specific Module (Example: fenix7)

```monkey
// source-fenix7/BackgroundManager.mc
import Toybox.Graphics;
import Toybox.Application;

module BackgroundManager {

    var backgroundFull = null;
    var isReady = false;

    function initialize() as Void {
        try {
            // Load full background - only exists in fenix7
            backgroundFull = Application.loadResource(Rez.Drawables.BackgroundFull);
            isReady = (backgroundFull != null);
        } catch (ex) {
            System.println("Failed to load background: " + ex.getErrorMessage());
        }
    }

    function drawBackground(dc as Graphics.Dc) as Void {
        if (isReady && backgroundFull != null) {
            dc.drawBitmap(0, 0, backgroundFull);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
            dc.clear();
        }
    }
}
```

## Module Sharing Pattern

Some modules may be shared across all devices (in `source/`) while device-specific versions override them (in `source-device/`). The compiler uses this override precedence:

1. Device-specific folder (`source-fenix5x/`, etc.) - highest priority
2. Base folder (`source/`) - fallback
3. SDK libraries - lowest priority

This allows you to:

- Keep 90% of code in shared `source/` folder
- Override only the modules that differ per device in device-specific folders
- Avoid duplicating shared code

## Handling AMOLED vs MIP Display Differences

The FR965 (AMOLED) has fundamentally different rendering characteristics than MIP displays:

### MIP Displays (fēnix 5X/6/7)

- Support background buffer allocation via `Graphics.BufferedBitmap`
- Support partial updates (`onPartialUpdate()`)
- Can efficiently render static background to buffer once

```monkey
// MIP: Use buffered rendering
if (DisplayManager.hasBackgroundBuffer()) {
    var bufferDc = DisplayManager.getBackgroundDrawingContext();
    bufferDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
    bufferDc.clear();
    BackgroundManager.drawBackground(bufferDc);  // Draw to buffer once
}
// Later: Blit buffer to screen
DisplayManager.drawBackgroundBufferToScreen(dc);
```

### AMOLED Displays (FR965)

- Do NOT support background buffer (memory optimization)
- Cannot efficiently use partial updates during active mode
- Must render full frame every update to avoid burn-in
- Requires black screen rendering during sleep mode

```monkey
// AMOLED: Render directly to screen (no buffer)
if (DisplayManager.isAmoledDevice()) {
    BackgroundManager.drawBackground(dc);  // Draw directly to screen
} else {
    DisplayManager.drawBackgroundBufferToScreen(dc);  // Draw from buffer
}
```

## Common Pitfalls & Solutions

### Pitfall 1: Resource Conflicts (Same Resource ID in Multiple Drawables.xml)

**Problem**: If you declare `BackgroundTile_0` in both `resources-fenix5x/drawables.xml` and `resources-fenix6/drawables.xml`, which one does Rez use?

**Solution**: Never use the same resource ID across different device-specific drawables.xml files. Use device-specific prefixes:

- fenix5x: `BackgroundTile_TL_TL`, `BackgroundTile_TL_TR`, etc.
- fenix6: `BackgroundTile_TL_TL`, `BackgroundTile_TL_TR`, etc.

Or if you must reuse IDs:

- fenix5x: `Tile_0`, `Tile_1`, ... (only in resources-fenix5x)
- fenix7: `BackgroundFull` (only in resources-fenix7)

Each device sees ONLY its own resource folder, so no conflicts occur.

### Pitfall 2: Forgetting to Initialize BackgroundManager

**Problem**: BackgroundManager.initialize() is called in DisplayManager.initialize(), but if DisplayManager isn't called (rare but possible), backgrounds won't load.

**Solution**: Always call DisplayManager.initialize() from WatchFaceView.onLayout():

```monkey
function onLayout(dc as Graphics.Dc) as Void {
    if (!displayInitialized) {
        DisplayManager.initialize(screenWidth, screenHeight, profile);
        displayInitialized = true;
    }
}
```

### Pitfall 3: AMOLED Rendering Gaps

**Problem**: If you only render background in the buffered code path, FR965 won't render anything because it has no buffer.

**Solution**: Use device detection to render appropriately:

```monkey
if (DisplayManager.hasBackgroundBuffer()) {
    // Render to buffer for MIP
    var bufferDc = DisplayManager.getBackgroundDrawingContext();
    BackgroundManager.drawBackground(bufferDc);
}

// Later in screen rendering:
if (DisplayManager.isAmoledDevice()) {
    BackgroundManager.drawBackground(dc);  // Direct to screen
} else {
    DisplayManager.drawBackgroundBufferToScreen(dc);  // From buffer
}
```

## Compilation Verification Checklist

After setting up per-device resources, verify all targets compile:

```bash
# Test each device build independently
java -jar monkeybrains.jar -d fenix5x_sim -f monkey.jungle -o bin/fenix5x.prg
java -jar monkeybrains.jar -d fenix6_sim -f monkey.jungle -o bin/fenix6.prg
java -jar monkeybrains.jar -d fenix7_sim -f monkey.jungle -o bin/fenix7.prg
java -jar monkeybrains.jar -d fr965_sim -f monkey.jungle -o bin/fr965.prg
```

Expected behavior:

- ✅ fenix5x: Only loads `source-fenix5x/BackgroundManager.mc` + `resources-fenix5x/drawables.xml`
- ✅ fenix6: Only loads `source-fenix6/BackgroundManager.mc` + `resources-fenix6/drawables.xml`
- ✅ fenix7: Only loads `source-fenix7/BackgroundManager.mc` + `resources-fenix7/drawables.xml`
- ✅ fr965: Only loads `source-fr965/BackgroundManager.mc` + `resources-fr965/drawables.xml`

All 4 builds should pass with NO "Undefined symbol" errors.

## Performance Implications

### Memory Usage

| Device  | Strategy                 | Memory Impact                     |
| ------- | ------------------------ | --------------------------------- |
| fenix5x | 16 tiles (60×60)         | ~7 KB per tile = 112 KB total     |
| fenix6  | 16 tiles (65×65)         | ~8 KB per tile = 128 KB total     |
| fenix7  | Full buffer + full image | ~270 KB buffer + ~50 KB image     |
| fr965   | No buffer, full image    | ~100 KB image (streamed directly) |

### Rendering Performance

| Device  | Strategy                    | Frame Time                                       |
| ------- | --------------------------- | ------------------------------------------------ |
| fenix5x | Render tiles once to buffer | 5-10 ms per frame (mostly hand rotation)         |
| fenix6  | Render tiles once to buffer | 5-10 ms per frame (mostly hand rotation)         |
| fenix7  | Render full to buffer       | 3-5 ms per frame (mostly hand rotation)          |
| fr965   | Render directly to screen   | 10-20 ms per frame (full background every frame) |

## References

- [Garmin Connect IQ Resources & Build System](https://developer.garmin.com/connect-iq/programmers-guide/resources-and-build-system/)
- [Monkey C Language Reference](https://developer.garmin.com/connect-iq/reference/)
- Project example: `class-l-experiment` repository showing multi-device fēnix 5X/6/7 + FR965 implementation

## Lessons Learned (Session Transcript)

1. **Rez Symbol Generation Is Static**: The Monkey C compiler generates all Rez symbols from ALL drawables.xml files found via resourcePath, before any code execution. Try-catch cannot gracefully handle missing resources because the symbol reference itself fails at compile time.

2. **SourcePath Override Pattern Works**: Putting device-specific module implementations in device-specific sourcePath folders allows the compiler to use the correct implementation per device without symbol conflicts.

3. **Resource Path Filters Resources Only**: monkey.jungle's `resourcePath` controls which resource FILES are compiled in, but it doesn't prevent Rez symbol generation if conflicts exist. SourcePath is the proper mechanism for avoiding conflicts.

4. **AMOLED Requires Different Rendering Path**: FR965 AMOLED doesn't allocate background buffers for memory efficiency, requiring direct-to-screen rendering in the main onUpdate() cycle.

5. **Always Handle Both Code Paths**: When supporting both MIP (with buffer) and AMOLED (without buffer), implement rendering logic for both:
   - MIP: Render to buffer in one location
   - AMOLED: Render directly to screen in onUpdate()

6. **Fenix6 Profile Detection Must Match Resolution**: The project layout profile for fenix6 is `260`. Device-specific branches in shared display code must check the device resolution/profile consistently.

7. **Transient Polygon Seconds Hands**: On fenix5x and fenix6, keep the 12-point seconds-hand JSON resource device-specific and load it inside the renderer’s draw call. Rotate the parsed points in place, fill the polygon, and release the local reference; retaining parsed geometry or a second transformed array defeats the low-memory goal.

8. **Avoid Angle-Dependent Pivot Corrections**: For rotating hand assets, use a fixed transform sequence of center translation, angle rotation, and pivot translation. World-space corrections based on sine/cosine vary by angle and appear as wobble.

9. **Retain MIP Background Buffers**: fenix5x and fenix6 keep a `Graphics.BufferedBitmap` for partial-update restoration. Their 16 background tiles should be loaded one at a time and rendered into the buffer; low-memory handling must not remove the cache required by the clipping path.
