---
description: "Monkey C coding standards and API compatibility. Applied to .mc files in Garmin Connect IQ projects."
applyTo: '**/*.mc'
---

# Monkey C Coding Standards & API Compatibility

These standards ensure Garmin Connect IQ Monkey C code compiles successfully and avoids common type system and API pitfalls.

## Syntax Fundamentals

### Variable Declaration & Scoping

```monkey
// Standard variable declaration with optional type annotation
var count as Number = 0;
var name as String = "Garmin";

// Compile-time constants (cannot be reassigned)
const MAX_HEART_RATE as Number = 220;

// Enums for named integer values
enum Color { RED = 0, GREEN = 1, BLUE = 2 };

// Scoping rules:
// - Global: Outside any class/module (avoid unless necessary)
// - Module: Shared within a module namespace (preferred for utilities)
// - Class: Instance or static members
// - Local: Function-level scope (automatically cleaned up at function end)
```

### Advanced Type Features

**Union Types** - A variable can hold multiple specified types:
```monkey
var data as Number or String;
data = 42;           // Valid
data = "value";      // Also valid
data = 3.14;         // Invalid - not declared as acceptable
```

**Null Safety** - Types are non-nullable by default. Use `?` for optional values:
```monkey
var name as String = "test";        // Cannot be null
name = null;  // ❌ Compile error

var optional as String? = null;     // Can be null
optional = "test";                  // Valid
```

**Type Aliases** - Create semantic type names with `typedef`:
```monkey
typedef GPS as { :latitude as Number, :longitude as Number };
var location as GPS = { :latitude => 47.6, :longitude => 8.8 };
```

**Type Casting** - Explicit conversion with `as` keyword:
```monkey
// Casting from generic type to specific type
var label = view.findDrawableById("TimeLabel") as WatchUi.Text;

// Numeric casting (required for Float/Number conversions)
var result = ((value * 0.5) as Number);

// Safe casting with instanceof check
if (obj instanceof Lang.String) {
    var text = obj as String;
}
```

## Collections & Data Structures

### Arrays (Preferred for Performance)

```monkey
// Fixed-size array with type annotation
var scores = [100, 95, 87, 92] as Array<Number>;

// Dynamic array (grows as needed)
var items = new Array<String>();
items.add("apple");
items.add("banana");

// Array access is O(1) - extremely fast
var first = items[0];
var last = items[items.size() - 1];
```

**Why Arrays?** Minimal overhead, O(1) access, no hash table complexity.

### Dictionaries (Use Cautiously)

```monkey
// Key-value pairs with heterogeneous values
var config = {
    "id" => 101,
    "name" => "Garmin",
    "active" => true
} as Dictionary<String, Number or String or Boolean>;

// Access by key
var deviceId = config.get("id");
```

**⚠️ WARNING**: Dictionaries are memory-expensive. Avoid them for:
- High-frequency loops
- Storing hundreds of items
- Hot paths (onUpdate/onPartialUpdate)

**Better Alternative: Parallel Arrays**
```monkey
// Instead of { "id" => 101, "name" => "Alice" }
var ids = [101, 102, 103] as Array<Number>;
var names = ["Alice", "Bob", "Charlie"] as Array<String>;
// Lookup: find index in ids, use same index in names
```

### Tuples (System 7+) - New & Efficient

```monkey
// Fixed-size, typed collections with minimal overhead
var coordinate = [47.6, 8.8] as [Number, Number];
var sensorData = [10, 20, 30] as [Number, Number, Number];

// Why Tuples?
// - More memory-efficient than Dictionaries
// - Faster access than Arrays
// - Perfect for returning multiple values
function getLocation() as [Number, Number] {
    return [47.6, 8.8];  // Latitude, Longitude
}

var [lat, lon] = getLocation();
```

## Classes & Inheritance

### Class Fundamentals

```monkey
class MyView extends WatchUi.View {
    // Instance variables (one per object)
    var buffer as Graphics.BufferedBitmap?;
    var counter as Number;
    
    // Constructor - always called via ParentClass.initialize()
    function initialize() {
        View.initialize();  // Call parent constructor
        counter = 0;
        buffer = new Graphics.BufferedBitmap(
            { :width => 240, :height => 240 }
        );
    }
    
    // Instance method
    function onUpdate(dc as Graphics.Dc) as Void {
        // Uses 'self' (implicit) to access members
        counter++;
    }
    
    // Static method (shared across all instances)
    static function getVersion() as String {
        return "1.0";
    }
}
```

**Constructor Pattern**: Always call parent `initialize()` first:
```monkey
function initialize() {
    WatchFace.initialize();  // REQUIRED: call parent
    // Then initialize your own members
}
```

## Modules: The Lightweight Alternative

```monkey
// Modules are for grouping utility functions (no instantiation)
module MathUtils {
    // Static functions only - no 'self' member
    function clamp(value as Number, min as Number, max as Number) as Number {
        if (value < min) { return min; }
        if (value > max) { return max; }
        return value;
    }
    
    function degreesToRadians(degrees as Number) as Number {
        return (degrees * 3.14159 / 180.0) as Number;
    }
}

// Usage (no instantiation needed)
var result = MathUtils.clamp(150, 0, 100);
```

**Module vs Class Trade-off**:
| Aspect | Module | Class |
|--------|--------|-------|
| **Instance Cost** | Zero | ~96 bytes + member overhead |
| **Best For** | Utilities, helpers | Stateful objects, inheritance |
| **Memory Efficient** | ✅ Yes | ❌ High overhead |
| **Can Inherit** | ❌ No | ✅ Yes |
| **Recommended Use** | 80% of code | 20% of code |

## Runtime Type Checking & Capabilities

### The `instanceof` Operator

```monkey
// Check an object's type at runtime
if (myObj instanceof Lang.String) {
    var text = myObj as String;
    System.println(text);
}

if (data instanceof Array) {
    var items = data as Array;
    // Process array...
}
```

### The `has` Operator (Critical for Compatibility)

**For Namespace/Module Checks** ✅ WORKS:
```monkey
// Check if a module exists (good for weather, fitness data)
if (Toybox has :Weather) {
    var conditions = Toybox.Weather.getCurrentConditions();
}

if (Toybox has :Sensor) {
    // Sensor data available
}
```

**For Class Method Checks** ❌ DOES NOT WORK:
```monkey
// WRONG - This will not compile
if (WatchUi.WatchFace has :onPartialUpdate) { }

// RIGHT - Just implement the method
function onPartialUpdate(dc as Graphics.Dc) as Void {
    // Called if supported, ignored if not
}
```

**Rule of Thumb**: `has` checks modules/namespaces, not individual methods. For method availability, use try-catch or just implement it.

## Callbacks & Methods as Objects

Monkey C does NOT support first-class functions. To pass a function as a callback, wrap it in a **Method** object:

```monkey
// Create a method reference
var callback = method(:onTimerUpdate);

// Use for callbacks/listeners
var timer = new Timer.Timer();
timer.start(callback, 1000, true);  // Calls onTimerUpdate every 1000ms

// Define the callback function
function onTimerUpdate() as Void {
    System.println("Timer fired!");
}
```

## Symbols: The Foundation of Monkey C

A **Symbol** (prefixed with `:`) is a unique identifier resolved at compile-time to an integer. Symbols are used for:

```monkey
// 1. Method references (callbacks)
var cb = method(:onUpdate);

// 2. Resource access
var icon = Rez.Drawables.WeatherIcon;
var font = Rez.Fonts.LargeFont;

// 3. Capability checking
if (Toybox has :Weather) { }

// 4. Key access in some APIs
view.findDrawableById(:TimeLabel);
```

**Why Symbols?** More efficient than strings—resolved to integer IDs at compile time, saving memory and CPU cycles.

## The Rez (Resources) System

Resources (layouts, images, fonts, strings) are defined in XML files and compiled into integer IDs. Access via the `Rez` module:

```monkey
// Accessing Drawable resources (images, bitmaps)
var icon = Rez.Drawables.WeatherIcon;
dc.drawBitmap(x, y, icon);

// Accessing font resources
var font = Rez.Fonts.CustomFont;
dc.setFont(font);

// Loading string resources (localization)
var title = WatchUi.loadResource(Rez.Strings.AppTitle);

// Instantiating layout resources
var view = Rez.Layouts.MainLayout(dc);
```

**Power Tip**: You can use `has` to check if a resource exists for specific device builds:
```monkey
if (Rez has :Drawables_HiResBitmap) {
    // High-resolution device - use premium graphics
} else {
    // Standard resolution - use lightweight bitmap
}
```

## Exception Handling

Standard try-catch-finally pattern for error handling:

```monkey
try {
    var result = compute();
    var value = 100 / result;  // May divide by zero
} catch (ex instanceof Lang.DivideByZeroException) {
    // Handle specific exception type
    System.println("Division by zero!");
} catch (ex instanceof Lang.Exception) {
    // Catch broader exception types
    System.println("General error: " + ex.getErrorMessage());
} catch (ex) {
    // Catch-all (works for any object)
    System.println("Unknown error");
} finally {
    // Cleanup code (always runs)
    cleanupResources();
}
```

## Annotations & Conditional Compilation

Annotations provide compile-time metadata and code inclusion/exclusion:

```monkey
// Include code only during unit tests
(:test)
function testCalculation() as Void {
    assert(calculateValue() == 42);
}

// Include for background processes only
(:background)
function backgroundTask() as Void {
    // Limited API access in background
}

// Disable type checking for specific block (advanced)
(:typecheck(false))
function legacyFunction() {
    // Dynamic typing allowed here
}

// Custom device annotations (defined in monkey.jungle)
(:round)
function drawRoundDisplay() { }

(:rect)
function drawRectDisplay() { }
```

## Memory Management: ARC & Weak References

Monkey C uses **Automatic Reference Counting (ARC)** for memory management.

### Circular Reference Pitfall

```monkey
// PROBLEM: Circular reference leak
class Observer {
    var listener as EventSource;
}
class EventSource {
    var observer as Observer;
}

var source = new EventSource();
var obs = new Observer();
source.observer = obs;        // source → obs
obs.listener = source;        // obs → source (CYCLE)
// Neither will ever be deallocated! Memory leak.
```

### Solution: WeakReference

```monkey
class Observer {
    var listener as EventSource?;  // Strong reference
}
class EventSource {
    var observer as WeakReference?;  // Weak reference breaks cycle
}

var source = new EventSource();
var obs = new Observer();
source.observer = WeakReference(obs);  // obs → source (weak)
obs.listener = source;                 // source → obs (strong)
// When obs is no longer used, it CAN be deallocated

// Using weak references
var observerObj = source.observer.get();  // Returns object or null
if (observerObj != null) {
    observerObj.onEvent();
}
```

**Rule**: If you have bidirectional references (A points to B, B points to A), make one of them a WeakReference.

## Memory Part 2: Object Overhead & Efficiency

### The Handle Overhead

Every unique object (Array, Dictionary, Class Instance) consumes one **Handle**:
- Older devices: Strict limit of 256-512 handles
- Modern devices: Limited by Heap Size (e.g., 128 KB), but handles still cost a few bytes in VM table

### Object Memory Costs

| Type | Overhead | Use Case |
|------|----------|----------|
| **Class Instance** | ~96 bytes base + 12 bytes per member | Stateful objects |
| **Inherited Class** | +60 bytes from extends | UI views, components |
| **Module** | Zero (no instance) | Utilities, helpers |
| **Array** | Very low O(n) | Data storage |
| **Dictionary** | Extremely high (hash table) | Avoid in loops |
| **String** | Variable (content length) | Use Rez.Strings |

### Memory Optimization Checklist

- [ ] Prefer Modules over Classes for utilities
- [ ] Use Arrays instead of Dictionaries where possible
- [ ] Store strings in `Rez.Strings` (loaded on demand)
- [ ] Use local variables in hot loops (faster stack access)
- [ ] Pre-allocate collections before loops
- [ ] Use Tuples for multi-value returns (System 7+)
- [ ] Avoid Dictionaries with hundreds of items
- [ ] Break circular references with WeakReference

### Hot Loop Optimization

```monkey
// SLOW ❌ - Class member lookup on every iteration
for (var i = 0; i < 360; i++) {
    var angle = self.currentAngle + i;  // Heap lookup
    dc.drawLine(self.centerX, self.centerY, x, y);  // Multiple lookups
}

// FAST ✅ - Copy to local variable (stack access)
var angle = self.currentAngle;
var cx = self.centerX;
var cy = self.centerY;
for (var i = 0; i < 360; i++) {
    angle = angle + 1;  // Stack access (fast)
    dc.drawLine(cx, cy, x, y);  // Reuse local variables
}
```

## System 7 & 8 Enhancements

### Code Density & Paged Code (System 8)

- **System 7**: Improved bytecode compression reduces PRG file size
- **System 8**: Supports up to 16 MB of **Paged Code Space** (loaded on demand)
  - Older limits: App logic size constrained by device RAM
  - New capability: Complex apps now feasible on memory-limited devices

## Duck Typing vs Static Typing

Monkey C has evolved from purely dynamic ("duck-typed") to **Gradual Type System**:

```monkey
// LEGACY: Pure duck typing (no type safety)
function process(obj) {
    return obj.getValue();  // Works if obj has getValue(), fails otherwise
}

// MODERN: Static typing (recommended)
function process(obj as MyClass) as Number {
    return obj.getValue();  // Compile error if MyClass lacks getValue()
}

// HYBRID: Use (:typecheck) for selective strict typing
(:typecheck(false))
function legacyCode() {
    // Dynamic typing allowed (not recommended)
}

(:typecheck(true))
function modernCode() {
    // Strict static typing enforced
}
```

**Recommendation**: Use static typing everywhere unless legacy compatibility required.

### Always Qualify Types from Imports

```monkey
// WRONG ❌
function draw(dc as Dc) { }

// CORRECT ✅
import Toybox.Graphics;
function draw(dc as Graphics.Dc) { }
```

**Why**: Graphics.Dc must be fully qualified. Other types like Number, String can be used directly, but imported module types require qualification.

### Strict Float/Number Separation

```monkey
// WRONG ❌
var angle = (seconds * 6) + ((millis as Float) * 0.006);
function setPIDGain(value as Float) { }
PIDController.calculateAngle(angle);  // expects Number

// CORRECT ✅
var angle = (seconds * 6) + ((millis * 0.006) as Number);
function setPIDGain(value as Number) { }
PIDController.calculateAngle(angle);  // accepts Number
```

**Why**: Monkey C doesn't auto-convert Float to Number. Explicit casting required.

## Common API Mistakes (DO NOT USE)

### ❌ System.getClockTime() Time Properties

NEVER use:
- `.timeInMillis` - **does not exist**
- `.timeInSeconds` - **does not exist**

**CORRECT** alternative:
```monkey
import Toybox.Time;
var now = Time.now();
var seconds = now.value();  // Returns Number
var millis = (now.value() * 1000) % 1000;  // Calculate manually
```

### ❌ WatchUi.Timer

NEVER use:
```monkey
WatchUi.Timer.start(method(:callback), 1000, true);  // DOES NOT EXIST
```

**CORRECT** alternatives:
1. **For watch faces**: Rely on system-driven onUpdate() and onPartialUpdate() cycles
2. **For background services**: Use ServiceDelegate or other background mechanisms
3. **For repeating tasks**: Never create busy-wait loops

### ❌ Feature Detection with 'has' Operator

NEVER use:
```monkey
if (!WatchUi.WatchFace has :onPartialUpdate) {  // WRONG
    return;
}
```

**CORRECT** approaches:
1. **Just implement the method** - System calls it if supported, ignores it otherwise
2. **Use try-catch** for API version detection
3. **Check manifest targets** - Know which SDK versions you support

## Module vs Class Architecture

**Prefer modules for stateless utilities**:
```monkey
// ✅ PREFERRED - No instantiation, lightweight
module PIDController {
    function calculateAngle(target as Number) as Number { }
    function reset() as Void { }
}
```

**Use classes only for stateful components**:
```monkey
// ✅ ACCEPTABLE - State management needed
class WatchFaceView extends WatchUi.WatchFace {
    var buffer as Graphics.BufferedBitmap;
    function initialize() { }
}
```

## Graphics and Display Requirements

### Always Import Graphics for Dc Types

```monkey
// REQUIRED
import Toybox.Graphics;

function onUpdate(dc as Graphics.Dc) as Void {
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
    dc.clear();
    dc.drawBitmap(0, 0, myBitmap);
}
```

### Proper Import Organization

```monkey
// Standard order:
import Toybox.Application;   // App framework
import Toybox.Graphics;      // Display (MUST for Dc type)
import Toybox.Lang;          // Language features
import Toybox.System;        // System calls
import Toybox.Time;          // Time handling (NOT System.getClockTime)
import Toybox.WatchUi;       // UI framework
import Toybox.Weather;       // Sensor data
using Toybox.Time.Gregorian as Date;  // Time calculation helpers
using MyModules.PIDController;  // Local modules
```

## No Unused Code Warnings

All variables that won't be immediately used should be marked:

```monkey
// For future implementation (next phase)
// TODO: var smoothedAngle = PIDController.calculateSmoothedAngle(angle);

// For variables created for clarity but used later
// var centerX = layout["centerX"] as Number;
// var centerY = layout["centerY"] as Number;
```

## Memory Efficiency Rules

### No Allocations in Hot Loops

```monkey
// WRONG ❌ - Creates new object every loop iteration
for (var i = 0; i < 60; i++) {
    var angle = new PIDState(i * 6);  // BAD
}

// CORRECT ✅ - Pre-allocate or use primitives
var angle = 0;
for (var i = 0; i < 60; i++) {
    angle = i * 6;  // Just numbers
}
```

### Use Modules for Stateless Functions

Modules don't allocate instance memory and execute faster than classes.

## Function Type Annotations

Every function must have explicit parameter and return types:

```monkey
// WRONG ❌
function processTime(time) {
    return time * 1000;
}

// CORRECT ✅
function processTime(time as Number) as Number {
    return (time * 1000) as Number;
}
```

## No Unsafe Type Operations

```monkey
// WRONG ❌ - Assumes type
var value = data["result"];  // Could be any type
var count = value + 1;  // May fail at runtime

// CORRECT ✅ - Explicit type casting
var value = data["result"] as Number;  // Explicit type
var count = (value + 1) as Number;  // Safe arithmetic
```

## Device-Specific Code Patterns

### AMOLED vs MIP Display Handling

```monkey
// Detect device type
var profile = LayoutManager.getProfileName();  // Returns "fr965", "fenix7", etc.
var isAmoled = (profile == "fr965");

// Handle differently
if (isAmoled) {
    // AMOLED-specific: no partial updates, burn-in prevention needed
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();  // Black screen during sleep
} else {
    // MIP-specific: partial updates supported
    // Use onPartialUpdate() for high-frequency updates
}
```

### SDK Version Compatibility

```monkey
// Check at compile time via manifest
// Don't attempt runtime checks with 'has' operator

// Instead, just implement methods conditionally:
function onPartialUpdate(dc as Graphics.Dc) as Void {
    // Called by system if supported; ignored if not
}
```

## Testing Before Compilation

- [ ] All types explicitly annotated (no implicit typing)
- [ ] All imports qualified (Graphics.Dc, not Dc)
- [ ] No System.getClockTime() property access
- [ ] No WatchUi.Timer usage
- [ ] No float-to-number implicit casts
- [ ] No object allocations in hot loops
- [ ] All functions have return types
- [ ] TODO sections clearly marked for future work

## Build Verification

After compilation, verify:
- [ ] BUILD SUCCESSFUL in output
- [ ] 0 syntax errors
- [ ] 0 type errors
- [ ] 0 import errors
- [ ] PRG file generated at correct location
- [ ] Only non-critical warnings (config, not code)

## Learnings from Phase 2 Build

See `.github/skills/monkeyc-build/SKILL.md` for:
- Complete build command with all parameters
- 5 most common Monkey C errors with exact fixes
- Type system quick reference
- Build success criteria
- Performance considerations

## References

- [Monkey C Language Reference](https://developer.garmin.com/connect-iq/reference/)
- [Garmin Connect IQ API Docs](https://developer.garmin.com/connect-iq/api-docs/)
- [Watch Face Development Guide](https://developer.garmin.com/connect-iq/programmers-guide/watchfaces/)
- [Memory Management Best Practices](https://developer.garmin.com/connect-iq/programmers-guide/memory-management/)
- [SDK 4.0+ Type System Guide](https://developer.garmin.com/connect-iq/programmers-guide/type-system/)
