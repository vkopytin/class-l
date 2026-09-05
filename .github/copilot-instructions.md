# GitHub Copilot System Instructions: Multi-Device Garmin Watch Face

You are an expert Garmin Connect IQ developer specializing in Monkey C. Your objective is to scaffold, build, and optimize a highly complex, multi-device hybrid (Analog + Digital) watch face targeting the **fēnix 5X**, **fēnix 6**, **fēnix 7**, and **Forerunner 965**. 

Adhere strictly to Monkey C memory-saving patterns, low-power constraints, and target-specific layout logic.

---

## 1. Target Device Profiles & Display Constraints
Optimize your rendering boundaries, layouts, and memory management structures by dynamically tailoring operations to these four target screen configurations:

| Device ID | Screen Type | Resolution | 1Hz / Low Power Strategy | Memory Management Mode |
| :--- | :--- | :--- | :--- | :--- |
| `fenix5x` | MIP (Round) | **240 x 240** | Supported (Partial Update) | **Ultra-Low Memory:** Split background into **16 memory tiles** |
| `fenix6` | MIP (Round) | **260 x 260** | Supported (Partial Update) | **Low Memory:** Use a buffered tiled background |
| `fenix7` | MIP (Round) | **260 x 260** | Supported (Partial Update) | Standard; Support Solar Intensity Arrays |
| `fr965` | AMOLED (Round) | **454 x 454** | **No 1Hz/Partial Update:** Render full **Black Screen** in Suspend Mode | High-Res Tile Asset Handling |

---

## 2. Structural & Architectural Standards
To bypass heavy object-overhead execution errors on memory-restricted targets (especially `fenix5x`), enforce the following architectural rules:
* **Prefer Modules over Classes:** Declare all widgets, data providers, formatting logic, and coordinates within static `module` namespaces. Use a `class` **only** when explicitly inheriting from an existing Connect IQ API layer (e.g., `WatchUi.WatchFace`, `WatchUi.DataField`).
* **Buffered Frame Rendering:** Every profile uses a retained `Graphics.BufferedBitmap`. A coalesced 10 ms timer prepares the full frame in that buffer, and `onUpdate()` only blits it before drawing the live seconds hand. MIP partial updates restore their clip from the same frame buffer; FR965 renders black while asleep.
* **1Hz Mode & Snap Calculations:** Use a **PID Controller algorithm** to drive the rendering of the seconds hand during high-power active mode to achieve snappy, organic motion.
* **Memory-Optimized Fonts vs. Asset Bitmaps:**
    * **`fenix5x` / `fenix6`**: Use lightweight, system-compiled custom font sheets for the Weather and Moon Phase modules to keep the RAM footprint tiny.
    * **`fenix7` / `fr965`**: Load high-resolution custom icon tiles from explicit bitmap resources optimized for high display density.
* **Seconds-Hand Geometry by Device:**
    * `fenix5x` and `fenix6` use the 12-point polygon defined in their device-specific `jsonData/secondsHand.json` resource.
    * Load polygon coordinates inside the draw call, rotate them in place around the layout center, render them, and release the local reference immediately. Do not retain parsed JSON or allocate a second transformed point array.
    * Use the seconds-hand color `0xFF5500` on polygon-based profiles.
    * Bitmap hands use the transform order `translate(center) -> rotate(angle) -> translate(-pivotX, -pivotY)`. Do not add angle-dependent world-coordinate corrections; those introduce visible wobble.

---

## 3. Screen Layout & Component Matrix

### Central Vertical Alignment (Top to Bottom)
1. **Weather Sector:** Displays a context-aware weather condition icon alongside current temperature readings. 
    * **Data Sourcing:** Fetch native weather metrics via `Weather.getCurrentConditions()` on `fenix6`, `fenix7`, and `fr965`. Use OpenWeather via `Communications` background configurations for the `fenix5x`.
    * **Metric Evaluation:** Parse and map active system preferences seamlessly to either **Celsius (°C)** or **Fahrenheit (°F)** scales.
2. **Analog Clock Sector (Positioned Slightly Above Center):** 
    * Renders precise configurations for Hour, Minute, and Seconds hands.
    * **1Hz Power Savings Rule:** During partial update modes (`onPartialUpdate`), never render the seconds hand directly into the persistent background memory bitmap. Instead, calculate the clipping region covering the previous seconds hand path, restore that bounding clip region immediately from the buffered background frame, and redraw the active seconds hand over it.
3. **Digital Clock Sector (Positioned Slightly Below Center):**
    * Renders standard digital time formats forcing zero-padded hours and minutes (e.g., `08:05`).
4. **Battery Status Sector (Base Bottom):**
    * Renders an expressive physical battery metric gauge constructed out of progressive visual **sectors per charge**, accompanied below by a battery silhouette icon detailing exact numerical percentages.

### Left Vertical Sector Alignment (Top to Bottom)
1. **Barometer Metric Block:** Display numeric barometric metrics constrained strictly between valid ranges of **940 hPa to 1090 hPa**.
2. **Barometer Trend Graph:** Render a historical structural line graph mapping recent pressure trends.
3. **Calendar Multi-Line Matrix:** Displays a clean 3-line structural text block layout:
    * **Line 1:** Current day numerical date (e.g., `31`).
    * **Line 2:** Short Month Name in 3-letter uppercase string values (e.g., `AUG`).
    * **Line 3:** Short Day Name in 3-letter uppercase string values (e.g., `MON`). **Condition:** If the active day is Sunday, render this text line in bold **Red**.
4. **Moon Phase Indicator:** Displays current lunar phase metrics. Rendered using memory-saving fonts on `fenix5x`/`fenix6` and pixel-dense icon tiles on `fenix7`/`fr965`. Positioned to the immediate **Left** of the Digital Clock display space.

### Right Vertical Sector Alignment (Top to Bottom)
1. **Heart Rate Metric Block:** Displays active pulse rates bounded strictly within valid operational boundaries of **25 bpm to 220 bpm**.
2. **Heart Rate History Graph:** Line plot illustrating real-time historical pulse trends.
3. **Steps Counter Block:** Displays numerical tracking totals accumulated throughout the current day.
4. **Steps Historical Bar Chart:** Renders a mandatory, immutable **7-bar historical column chart** representing step activity distributions over the preceding 7-day period.
5. **Day / Night Lifecycle Widget:** A shifting 5-state cyclical status visualization tracking current solar progression. Dynamically switches between these specific asset layers based on local tracking calculations:
    * `NIGHT` | `MORNING` | `DAY` | `EVENING` | `TWILIGHT` (After Evening)
    * Positioned immediately to the **Right** of the Digital Clock display space.

### Central Horizontal Void Utility Links
Because the digital time display block sits slightly below the center, use the resulting empty space on the immediate left and right margins to map micro status indicators:
* **Left Margin Interstitial (Top):** Alarm Enable Status Icon (On / Off).
* **Left Margin Interstitial (Bottom):** Hardware Vibration State Indicator (On / Off).
* **Right Margin Interstitial (Top):**
    * For `fenix7`: Two specific color-coded icons mapping real-time **Solar Charging Intensity levels**.
    * For all other devices: Dual-state standard system battery charging plug indicators (Charging vs. Discharging).
* **Right Margin Interstitial (Bottom):** Wireless Phone Connection Status Icon (Bluetooth Link Active / Broken).

---

## 4. Power Management & Burn-In Mitigation (`fr965`)
The Forerunner 965 features an AMOLED screen prone to pixel degradation and does not support standard 1Hz background partial updates. You must intercept power lifecycle events natively:
* **`onEnterSleep()` Override:** For `fr965`, completely bypass any standard low-power calculations or analog sweep drawings. Instantly enforce a strict **completely black screen rendering execution pass** to protect the display panel and maximize battery longevity.

---

## 5. Execution Workflow Prompt Script
When instructed to generate code modules or layout files for this project:
1. Verify target compilation boundaries matching the active device resolution selection (`240x240`, `260x260`, or `454x454`).
2. Implement spatial translations dynamically or rely on device-specific resource files to keep layout elements from shifting out of round screen borders.
3. Scaffold using strict Module separations for the graph rendering utilities, layout calculations, asset font map assignments, and device-specific seconds-hand renderers.

## 6. Low-Memory Seconds-Hand Requirements

The fenix5x and fenix6 polygon renderers are intentionally transient. `WatchUi.loadResource()` must be called from `draw()`, and the parsed coordinate array must not be stored in module state. Transform the 12 points in place and clear the local reference after `fillPolygon()`. The renderer must remain compatible with the device-specific resource path selected by `monkey.jungle`.

The background buffer is intentionally retained on fenix5x and fenix6; low-memory optimization applies to transient tile and hand-resource loading rather than removing the MIP background cache.