# Claude Code Prompt Template - SIMPLE Features (Android)

**Use for:** Single file, < 200 LOC, straightforward implementation

---

## Template

```
[FEATURE NAME] - [Brief description]

ANALYZE FIRST (if adapting from GetHooked):
Read [exact Swift file path from GetHooked iOS]
Document: patterns to adapt for Android, architectural lessons, what translates to Kotlin

BUILD:
File: [exact Android Kotlin file path to create/modify]
Implementation: [1-2 sentence description]

KEY FACTS:
- [Critical constraint 1]
- [Critical constraint 2]
- [Critical constraint 3]
[Max 5 bullets - ONLY non-obvious stuff]

REQUIREMENTS:
- [Specific behavior requirement]
- [Specific UI pattern requirement (Android equivalent)]
- [Specific data format requirement]

VERIFY:
- [Test case 1]
- [Test case 2]
- [Test case 3]

BUILD CLEAN: ./gradlew assembleDebug must pass
```

---

## Example: Weather Icon Helper

```
Weather Icon Helper - Icon mapping utility

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Extensions/WeatherIcon+Extensions.swift
Document: icon mapping pattern - adapt for Material Icons on Android

BUILD:
File: app/src/main/java/com/flightready/app/utils/WeatherIcon.kt
Implementation: Maps Visual Crossing weather codes to Material Icons

KEY FACTS:
- Visual Crossing uses numeric weather codes (0-999)
- Use Material Icons for Android (not SF Symbols)
- Fallback to cloud icon if unknown code
- Support both day and night variants
- Must work with Material Icons library

REQUIREMENTS:
- Return appropriate Material Icon resource ID for each weather code
- Handle day/night variants appropriately
- Provide sensible fallback for unknown codes
- Support aviation-relevant conditions (wind, visibility, ceiling)

VERIFY:
- Code 0 (clear) returns appropriate sun/moon icon
- Code 1000 (rain) returns rain cloud icon
- Unknown code returns generic cloud icon
- Aviation conditions have appropriate icons

BUILD CLEAN: ./gradlew assembleDebug must pass
```

---

## Example: Coordinate Formatter

```
Coordinate Formatter - DMS coordinate display

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Extensions/CLLocationCoordinate2D+Extensions.swift
Document: DMS conversion approach - proven pattern to adapt for Kotlin

BUILD:
File: app/src/main/java/com/flightready/app/utils/CoordinateFormatter.kt
Implementation: Converts decimal coordinates to DMS (Degrees Minutes Seconds) format

KEY FACTS:
- Format: 41°23'45"N, 82°04'23"W
- Round seconds to nearest integer
- Use proper symbols: ° ' "
- Cardinal directions: N/S for lat, E/W for lon
- Handle negative coordinates correctly
- Extension function on LatLng or standalone formatter

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

BUILD CLEAN: ./gradlew assembleDebug must pass
```

---

## Example: Color Constants

```
App Color Palette - Standard color definitions

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Extensions/UIColor+AppColors.swift
Document: semantic color approach - adapt for Android XML resources

BUILD:
File: app/src/main/res/values/colors.xml + values-night/colors.xml
Implementation: Defines Flight Ready app color palette with dark mode variants in XML resources

KEY FACTS:
- Use semantic color names (e.g., excellent_conditions not green)
- Support dark mode via values-night directory
- Status colors: excellent, good, fair, poor, restricted
- All colors must meet WCAG AA contrast requirements
- Define in colors.xml, reference in layouts/code

REQUIREMENTS:
- Semantic naming for aviation status levels
- Dark mode support via values-night directory
- Meet accessibility contrast requirements
- Clear visual hierarchy for safety-critical information
- Status colors clearly distinguishable

VERIFY:
- excellent_conditions is green in light mode
- restricted_conditions is red in light mode
- values-night/colors.xml provides dark mode alternatives
- Colors readable on both white and black backgrounds
- Status colors follow aviation safety conventions

BUILD CLEAN: ./gradlew assembleDebug must pass
```

---

## When to Use This Template

✅ **Use SIMPLE template when:**
- Feature is contained in 1-2 Swift files
- Implementation is 1 Kotlin file or simple XML resource
- No complex algorithms or state management
- Straightforward implementation with no tricky Android lifecycle issues
- Example features: utilities, extensions, simple XML resources, constants

❌ **Don't use SIMPLE template when:**
- Feature spans 3+ Swift files
- Requires multiple Android files (models + services + activities)
- Has complex business logic or algorithms
- Involves tricky Android lifecycle or integration challenges
- Needs phased implementation
