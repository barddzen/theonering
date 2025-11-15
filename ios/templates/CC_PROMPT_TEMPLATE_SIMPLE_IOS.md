# Claude Code Prompt Template - SIMPLE Features (iOS)

**Use for:** Single file, < 200 LOC, straightforward implementation

---

## Template

```
[FEATURE NAME] - [Brief description]

ANALYZE FIRST (if adapting from GetHooked):
Read [exact Swift file path from GetHooked iOS]
Document: patterns to adapt, architectural lessons, what to keep vs change for Flight Ready

BUILD:
File: [exact iOS file path to create/modify]
Implementation: [1-2 sentence description]

KEY FACTS:
- [Critical constraint 1]
- [Critical constraint 2]
- [Critical constraint 3]
[Max 5 bullets - ONLY non-obvious stuff]

REQUIREMENTS:
- [Specific behavior requirement]
- [Specific UI pattern requirement]
- [Specific data format requirement]

VERIFY:
- [Test case 1]
- [Test case 2]
- [Test case 3]

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass
```

---

## Example: Weather Icon Helper

```
Weather Icon Helper - Icon mapping utility

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Extensions/WeatherIcon+Extensions.swift
Document: icon mapping pattern, SF Symbols approach - adapt for aviation weather codes

BUILD:
File: FlightReady/Extensions/WeatherIcon+Extensions.swift
Implementation: Maps Visual Crossing weather codes to SF Symbols icons for aviation conditions

KEY FACTS:
- Visual Crossing uses numeric weather codes (0-999)
- SF Symbols provides built-in weather icons
- Fallback to cloud.fill if unknown code
- Support both day and night variants
- Must work with iOS 15+ SF Symbols

REQUIREMENTS:
- Return appropriate SF Symbol name for each weather code
- Handle day/night variants appropriately
- Provide sensible fallback for unknown codes
- Support aviation-relevant conditions (wind, visibility, ceiling)

VERIFY:
- Code 0 (clear) returns "sun.max.fill" (day) or "moon.stars.fill" (night)
- Code 1000 (rain) returns "cloud.rain.fill"
- Unknown code returns "cloud.fill"
- Aviation conditions have appropriate icons

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass
```

---

## Example: Coordinate Formatter

```
Coordinate Formatter - DMS coordinate display

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Extensions/CLLocationCoordinate2D+Extensions.swift
Document: DMS conversion approach - proven pattern to reuse for Flight Ready

BUILD:
File: FlightReady/Extensions/CLLocationCoordinate2D+Extensions.swift
Implementation: Converts decimal coordinates to DMS (Degrees Minutes Seconds) format

KEY FACTS:
- Format: 41°23'45"N, 82°04'23"W
- Round seconds to nearest integer
- Use proper symbols: ° ' "
- Cardinal directions: N/S for lat, E/W for lon
- Handle negative coordinates correctly

REQUIREMENTS:
- Format output as DMS with proper symbols
- Cardinal directions based on sign
- Seconds rounded to nearest integer
- Handle edge cases (0,0) and extreme coordinates

VERIFY:
- 41.395833,-82.073056 → "41°23'45\"N 82°04'23\"W"
- 0.0,0.0 → "0°0'0\"N 0°0'0\"E"
- Negative coordinates show correct cardinal
- Extreme coordinates (near poles) handled correctly

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass
```

---

## Example: Color Constants

```
App Color Palette - Standard color definitions

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Extensions/UIColor+AppColors.swift
Document: semantic color approach - adapt for aviation status colors

BUILD:
File: FlightReady/Extensions/UIColor+AppColors.swift
Implementation: Defines Flight Ready app color palette with dark mode variants

KEY FACTS:
- Use semantic color names (e.g., .excellentConditions not .green)
- Support dynamic colors for dark mode
- Status colors: excellent, good, fair, poor, restricted
- All colors must meet WCAG AA contrast requirements

REQUIREMENTS:
- Semantic naming for aviation status levels
- Dynamic color support for dark mode
- Meet accessibility contrast requirements
- Clear visual hierarchy for safety-critical information

VERIFY:
- .excellentConditions is green in light mode
- .restrictedConditions is red in light mode
- All colors adapt to dark mode
- Colors readable on both white and black backgrounds
- Status colors clearly distinguishable from each other

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass
```

---

## When to Use This Template

✅ **Use SIMPLE template when:**
- Feature is contained in 1-2 Swift files
- Implementation is 1 iOS file
- No complex algorithms or state management
- Straightforward UI with no tricky interactions
- Example features: extensions, utilities, simple views, constants

❌ **Don't use SIMPLE template when:**
- Feature spans 3+ Swift files
- Requires multiple iOS files (models + services + view controllers)
- Has complex business logic or algorithms
- Involves tricky UI interactions or lifecycle management
- Needs phased implementation
