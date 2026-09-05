---
name: monkeyc-build
description: Build and verify Monkey C watch face projects, checking for syntax errors, type issues, and import problems. Validates against Garmin Connect IQ SDK compiler.
---

# Monkey C Watch Face Build & Verification Skill

Use this skill to compile Monkey C watch face projects, verify syntax correctness, catch type errors early, and validate all imports resolve properly.

## When to Use This Skill

- **Compiling Monkey C code**: After writing or modifying source files
- **Syntax verification**: Before attempting device testing
- **Error diagnosis**: When getting compilation failures
- **Type checking**: Ensuring proper Monkey C type system compliance
- **Build optimization**: Verifying warnings are non-critical

## Build Command Structure

The standard Garmin Connect IQ Monkey C build command:

```bash
java -Xms1g \
  "-Dfile.encoding=UTF-8" \
  "-Dapple.awt.UIElement=true" \
  -jar <SDK_PATH>/bin/monkeybrains.jar \
  -o <OUTPUT_PRG> \
  -f <JUNGLE_FILE> \
  -y <DEVELOPER_KEY> \
  -d <TARGET_DEVICE_SIM> \
  -w
```

**Parameters**:
- `-Xms1g`: Allocate 1GB heap (required for larger projects)
- `-Dfile.encoding=UTF-8`: Set UTF-8 encoding for cross-platform compatibility
- `-Dapple.awt.UIElement=true`: Suppress AWT warnings on macOS
- `-o`: Output PRG file path
- `-f`: Jungle project file (manifest configuration)
- `-y`: Developer signing key
- `-d`: Target device simulator (e.g., fenix7_sim)
- `-w`: Show compiler warnings

## Common Monkey C Syntax Errors & Fixes

### Error 1: `Cannot resolve type 'Dc'`

**Symptom**: 
```
ERROR: Cannot resolve type 'Dc'
File: SomeFile.mc:20
```

**Root Cause**: Graphics.Dc must be explicitly imported and qualified.

**Fix**:
```monkey
// WRONG ❌
function myFunc(dc as Dc) as Void { }

// CORRECT ✅
import Toybox.Graphics;
function myFunc(dc as Graphics.Dc) as Void { }
```

### Error 2: `Undefined symbol ':timeInMillis'` or `':timeInSeconds'`

**Symptom**:
```
ERROR: Undefined symbol ':timeInMillis' detected
File: WatchFaceView.mc:89
```

**Root Cause**: `System.getClockTime()` does NOT have `timeInMillis` or `timeInSeconds` properties in Monkey C.

**Fix**:
```monkey
// WRONG ❌
var millis = System.getClockTime().timeInMillis;
var seconds = System.getClockTime().timeInSeconds;

// CORRECT ✅
import Toybox.Time;
var now = Time.now();
var timeInSeconds = now.value();
var millisIntoSecond = (now.value() * 1000) % 1000;
```

### Error 3: `Cannot find symbol ':Timer' on type '$.Toybox.WatchUi'`

**Symptom**:
```
ERROR: Cannot find symbol ':Timer' on type WatchUi
File: UpdateTimer.mc:13
```

**Root Cause**: `WatchUi.Timer` does not exist in Connect IQ API. Use system-driven update cycles instead.

**Fix**:
```monkey
// WRONG ❌
import Toybox.WatchUi;
updateTimerHandle = WatchUi.Timer.start(method(:callback), 1000, true);

// CORRECT ✅
// Rely on system calling onUpdate() automatically
// Or use a background service if sustained timing is needed
// Use onPartialUpdate() for high-frequency updates (supported on MIP displays)
```

**Alternative**: For truly independent timing, use `System.ServiceDelegate` or schedule via complications/background service (more complex, requires separate architecture).

### Error 4: `Cannot perform operation 'not' on type 'WatchFace'`

**Symptom**:
```
ERROR: Cannot perform operation 'not' on type '$.Toybox.WatchUi.WatchFace'
File: WatchFaceView.mc:107
```

**Root Cause**: The `has :method` operator doesn't work on class types in Monkey C; it's used for checking module/object properties, not class methods.

**Fix**:
```monkey
// WRONG ❌
if (!WatchUi.WatchFace has :onPartialUpdate) {
    return;
}

// CORRECT ✅ - Option 1: Just implement the method (called conditionally by system)
function onPartialUpdate(dc as Graphics.Dc) as Void {
    // Implementation - only called if system supports it
}

// CORRECT ✅ - Option 2: Use try-catch for API version detection
try {
    // Code that uses onPartialUpdate features
} catch (ex) {
    // Fallback for older SDK versions
}
```

### Error 5: `Invalid 'Float' passed as parameter of type 'Number'`

**Symptom**:
```
ERROR: Invalid '$.Toybox.Lang.Float' passed as parameter 1 of type '$.Toybox.Lang.Number'
File: WatchFaceView.mc:128
```

**Root Cause**: Monkey C maintains strict separation between Float and Number types. Float literals or Float casts don't automatically convert to Number.

**Fix**:
```monkey
// WRONG ❌
var millisIntoSecond = 500;
var exactAngle = (seconds * 6) + ((millisIntoSecond as Float) * 0.006);
PIDController.calculateSmoothedAngle(exactAngle);  // expects Number

// CORRECT ✅
var millisIntoSecond = 500;
var exactAngle = (seconds * 6) + ((millisIntoSecond * 0.006) as Number);
PIDController.calculateSmoothedAngle(exactAngle);  // accepts Number
```

## Build Verification Checklist

After compilation, verify:

- [ ] **Build Status**: Output contains "BUILD SUCCESSFUL"
- [ ] **Syntax Errors**: 0 errors in output
- [ ] **Type Errors**: 0 type-related errors
- [ ] **Import Errors**: 0 "Cannot resolve" or "Undefined symbol" errors
- [ ] **Code Warnings**: Any warnings are non-critical (marked as TODO, or informational)
- [ ] **Output File**: PRG file generated at expected location
- [ ] **File Size**: PRG is reasonable size (50-300 KB typical for watch faces)
- [ ] **Configuration Warnings**: Only manifest/permission warnings are acceptable
  - ✅ OK: "No supported languages defined" (resolved in Phase N with localization)
  - ✅ OK: "Background permission enabled but no source annotated" (expected for background watch faces)
  - ❌ NOT OK: Any actual code syntax/type errors

## Build Success Criteria

| Item | Status | Notes |
|------|--------|-------|
| Compilation | ✅ PASS | "BUILD SUCCESSFUL" in output |
| Syntax | ✅ PASS | 0 syntax errors |
| Types | ✅ PASS | 0 type errors (Float/Number casting correct) |
| Imports | ✅ PASS | All symbols resolve (Graphics.Dc imported, etc.) |
| Output | ✅ PASS | PRG file generated successfully |
| Warnings | ⚠️ CHECK | Only non-critical warnings (config, not code) |

## Example: Complete Build Workflow

```powershell
# 1. Verify paths and setup
$sdkPath = "C:\Users\volod\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-9.2.0-2026-06-09-92a1605b2"
$projectDir = "C:\Users\volod\dev\garmin\class-l-experiment"
$outputFile = "$projectDir\bin\classlexperiment.prg"
$keyFile = "C:\Users\volod\dev\developer_key.der"

# 2. Create output directory
New-Item -ItemType Directory -Path "$projectDir\bin" -Force | Out-Null

# 3. Build with proper argument quoting
& java -Xms1g "-Dfile.encoding=UTF-8" "-Dapple.awt.UIElement=true" `
    -jar "$sdkPath\bin\monkeybrains.jar" `
    -o "$outputFile" `
    -f "$projectDir\monkey.jungle" `
    -y "$keyFile" `
    -d fenix7_sim `
    -w

# 4. Verify output
if (Test-Path $outputFile) {
    $fileSize = (Get-Item $outputFile).Length
    Write-Host "✅ Build successful: $fileSize bytes" -ForegroundColor Green
} else {
    Write-Host "❌ Build failed: no output file" -ForegroundColor Red
}
```

## Type System Quick Reference

### Correct Type Annotations

```monkey
// Numbers
var count as Number = 42;
var ratio = 0.5;  // Inferred as Number if used with Number operations
var exact = 6 + ((500 * 0.006) as Number);  // Explicit cast

// Strings
var name as String = "fenix7";
var formatted = Lang.format("$1$", [name]);

// Collections
var data as Dictionary = {"key" => "value"};
var items as Array = [1, 2, 3];

// Graphics
import Toybox.Graphics;
var dc as Graphics.Dc;  // MUST be Graphics.Dc, not just Dc
var buffer as Graphics.BufferedBitmap;

// Time
import Toybox.Time;
var now = Time.now();
var seconds = now.value();  // Returns Number (seconds since epoch)
```

### Import Requirements

```monkey
// Always qualify types from imported modules
import Toybox.Graphics;
import Toybox.Time;

// WRONG: Missing imports or incorrect qualification
function draw(dc as Dc) { }  // ❌ Dc not imported

// CORRECT: Fully qualified
function draw(dc as Graphics.Dc) { }  // ✅ Graphics imported
var now = Time.now();  // ✅ Time imported
```

## Performance Considerations During Build

- **Build Time**: 10-30 seconds typical (depends on project size)
- **SDK Version**: Use latest stable SDK for best compatibility
- **Target Device**: Always build against primary target first (fenix7_sim for MIP, fr965_sim for AMOLED)
- **Output Size**: 
  - Watch faces: 50-200 KB typical
  - Complex watch faces: up to 300 KB
  - Over 500 KB: likely has excessive resources

## Learnings from Phase 2 Build

### Key Discoveries

1. **Module-based architecture over classes**: Monkey C handles modules more efficiently than classes for stateless utilities. Modules don't require instantiation and are lighter weight.

2. **Graphics.Dc import is critical**: Any function taking `dc` as parameter must use fully qualified `Graphics.Dc` type. This is a common stumbling block because many examples show unqualified `Dc`.

3. **Time API differences**: The Monkey C Time API is very different from standard programming languages:
   - `Time.now()` returns a Moment object
   - `.value()` gives seconds since epoch (as Number)
   - Milliseconds must be calculated manually: `(now.value() * 1000) % 1000`
   - `System.getClockTime()` is for clock-specific operations, NOT time retrieval

4. **No timer API in WatchUi**: Unlike many frameworks, Connect IQ doesn't provide general-purpose timers. Watch faces must rely on system-driven update cycles:
   - `onUpdate()` called by system at natural intervals
   - `onPartialUpdate()` called more frequently (MIP screens only)
   - Background services use different mechanisms
   - Never create busy-wait loops

5. **Float/Number strict separation**: Monkey C enforces strict type distinction:
   - Never assume `0.006` is automatically Number
   - Calculation results must be explicitly cast: `(value * 0.006) as Number`
   - This prevents silent precision losses but requires careful typing

6. **SDK feature detection limitations**: The `has :method` operator doesn't work for class methods. Instead:
   - Just implement the method (it's called conditionally by system)
   - Use try-catch blocks for API version detection
   - Check manifest targets and SDK version separately

### Debugging Strategy

When hitting build errors:
1. **Read the error location carefully**: File name and line number are exact
2. **Check imports first**: 80% of "Cannot resolve" errors are import-related
3. **Verify type qualifications**: All types must be fully qualified (Graphics.Dc, not Dc)
4. **Review method signatures**: Parameter types must match exactly (Number vs Float distinction)
5. **Check API documentation**: Monkey C API is smaller than many languages; verify method/property names

## Integration with CI/CD

To use this skill in automated builds:

```yaml
# Example GitHub Actions workflow
- name: Build Monkey C Watch Face
  run: |
    java -Xms1g \
      -Dfile.encoding=UTF-8 \
      -Dapple.awt.UIElement=true \
      -jar $CONNECTIQ_SDK/bin/monkeybrains.jar \
      -o bin/output.prg \
      -f monkey.jungle \
      -y $DEVELOPER_KEY \
      -d fenix7_sim \
      -w
```

## Next Steps

When build is successful:
1. Test on simulator (Garmin Connect IQ simulator)
2. Verify expected UI rendering
3. Check power consumption metrics
4. Deploy to physical device for final validation
5. Proceed to next development phase

## References

- [Garmin Connect IQ SDK Documentation](https://developer.garmin.com/connect-iq/)
- [Monkey C Language Reference](https://developer.garmin.com/connect-iq/reference/)
- [Watch Face Development Guide](https://developer.garmin.com/connect-iq/programmers-guide/watchfaces/)
- Phase 2 Build Report: See `BUILD_REPORT.md` in project root
