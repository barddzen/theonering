# Claude Code Prompt Template - COMPLEX Features (iOS)

**Use for:** 3+ files, algorithms, multi-step implementation, requires phased approach with checkpoints

---

## Template

```
[FEATURE NAME] - [Multi-file system description]

ANALYZE FIRST (if adapting from GetHooked):
Read these Swift files in order:
1. [path/to/first/file.swift] - [what to learn from this]
2. [path/to/second/file.swift] - [what to learn from this]
3. [path/to/third/file.swift] - [what to learn from this]

Document: 
- [Architectural patterns to adapt]
- [Algorithm approaches that apply]
- [Integration patterns to reuse]
- [What to change for aviation use case]

BUILD (PHASED):
Phase 1: [path/to/first/file.swift] - [what it does]
Phase 2: [path/to/second/file.swift] - [what it does]
Phase 3: [path/to/third/file.swift] - [what it does]

KEY FACTS:
- [Critical constraint 1]
- [Critical constraint 2]
- [Critical constraint 3]
- [Algorithm detail 1]
- [Algorithm detail 2]
- [Data format requirement]
- [Integration requirement]
[Max 10 bullets - be thorough for complex features]

REQUIREMENTS:
- [Exact algorithm behavior needed]
- [Exact data transformations needed]
- [Exact calculation thresholds needed]
- [Exact UI presentation needed]
- [Exact integration requirements]

VERIFY (PHASE 1):
- [Test case 1 for Phase 1]
- [Test case 2 for Phase 1]

VERIFY (PHASE 2):
- [Test case 1 for Phase 2]
- [Test case 2 for Phase 2]

VERIFY (PHASE 3):
- [Integration test 1]
- [Integration test 2]
- [End-to-end test]

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass after EACH phase

STOP AFTER PHASE 1, let me verify before Phase 2
```

---

## Example: Flight Scoring System

```
Flight Scoring System - Multi-factor weather/airspace scoring algorithm

ANALYZE FIRST:
Read these Swift files in order:
1. /Users/davidyutzy/Development/GetHooked/GetHooked/Models/ForecastWeights.swift - weighted scoring pattern
2. /Users/davidyutzy/Development/GetHooked/GetHooked/Services/ForecastCalculator.swift - factor combination approach
3. /Users/davidyutzy/Development/GetHooked/GetHooked/ViewControllers/ForecastViewController.swift - UI presentation pattern

Document: 
- Weighted factor approach - adapt for aviation
- Score calculation and combination method
- Factor breakdown UI pattern
- Color-coded presentation approach

BUILD (PHASED):
Phase 1: FlightReady/Models/FlightScore.swift + FlightConditions.swift (data models)
Phase 2: FlightReady/Services/FlightScoreCalculator.swift (scoring algorithm)
Phase 3: FlightReady/ViewControllers/ScoreDetailViewController.swift (UI with factor breakdown)

KEY FACTS:
- 6 factors: wind speed, wind gusts, visibility, cloud ceiling, precipitation, airspace restrictions
- Each factor weighted 0-1, total weights sum = 1.0
- Final score on 0-100 scale
- Wind: calm (0-5mph)=100, light (5-10)=80, moderate (10-15)=60, strong (15-20)=30, dangerous (20+)=0
- Visibility: >10mi=100, 6-10mi=80, 3-6mi=50, 1-3mi=20, <1mi=0
- Ceiling: >3000ft=100, 1000-3000ft=70, 500-1000ft=30, <500ft=0
- Precipitation: none=100, light=50, moderate=20, heavy=0
- Airspace restrictions: 0=clear, -50=caution, -100=restricted
- Rating thresholds: 80-100=Excellent, 60-79=Good, 40-59=Fair, 20-39=Poor, 0-19=Restricted

REQUIREMENTS:
- Weighted scoring algorithm combining all factors
- Factor values normalized to 0-100 scale
- Final score accounts for both weather and airspace
- Score-to-rating mapping clear and consistent
- Color coding follows aviation safety standards
- Individual factor scores visible in breakdown
- Algorithm handles missing data gracefully

VERIFY (PHASE 1):
- FlightScore model has all 6 factor properties
- FlightConditions enum has all 5 rating levels
- Weights sum to 1.0
- Color property returns correct UIColor for each rating

VERIFY (PHASE 2):
- Test case 1: wind=5mph, vis=10mi, ceil=5000ft, precip=none, airspace=clear → score ~95 (Excellent)
- Test case 2: wind=18mph, vis=3mi, ceil=800ft, precip=light, airspace=clear → score ~25 (Poor)
- Test case 3: wind=5mph, vis=10mi, ceil=5000ft, precip=none, airspace=restricted → score ~0 (Restricted)
- All 6 factors contribute to final score
- Edge cases: missing data uses conservative defaults
- Airspace restrictions override weather when severe

VERIFY (PHASE 3):
- Detail view displays overall score with correct color background
- Factor breakdown shows individual scores with aviation-appropriate icons
- Airspace restrictions clearly highlighted
- Updates in real-time when weather data changes
- Handles loading state gracefully
- NOTAM/TFR information integrated into display

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass after EACH phase

STOP AFTER PHASE 1, verify data models before algorithm
STOP AFTER PHASE 2, verify algorithm accuracy and aviation-specific thresholds before UI
```

---

## Example: Background Location Monitoring

```
Background Location Monitoring - Geofence alerting for saved flight locations

ANALYZE FIRST:
Read these Swift files in order:
1. /Users/davidyutzy/Development/GetHooked/GetHooked/Managers/LocationManager.swift - CLLocationManager setup pattern
2. /Users/davidyutzy/Development/GetHooked/GetHooked/Models/SavedLocation.swift - location storage approach
3. /Users/davidyutzy/Development/GetHooked/GetHooked/Services/GeofenceService.swift - region monitoring pattern

Document:
- CLLocationManager configuration approach
- Region monitoring pattern - adapt for flight locations
- Background modes setup
- Battery optimization strategies

BUILD (PHASED):
Phase 1: FlightReady/Managers/LocationMonitoringManager.swift (CoreLocation setup)
Phase 2: FlightReady/Services/GeofenceManager.swift (region management with 20-region limit)
Phase 3: FlightReady/Services/BackgroundAlertService.swift (notification triggers for condition changes)

KEY FACTS:
- iOS limits to 20 monitored regions system-wide
- Must prioritize which regions to monitor if >20 saved locations
- Background location requires "location" background mode in Info.plist
- CLLocationManager must have allowsBackgroundLocationUpdates = true
- Region monitoring continues even when app is terminated
- Significant location changes use less battery than continuous tracking
- Must handle authorization changes (user can revoke permission)
- Distance filter affects update frequency and battery
- Geofence radius from saved location radius (0.5-25 miles)
- Battery optimization: use significant location change API

REQUIREMENTS:
- Monitor up to 20 saved flight locations simultaneously
- Prioritize locations by proximity and recency
- Trigger alerts when entering monitored regions
- Check airspace/weather conditions when triggered
- Alert only on significant condition changes
- Respect user notification preferences per location
- Handle authorization changes gracefully
- Optimize for battery life
- Work even when app is terminated

VERIFY (PHASE 1):
- CLLocationManager properly configured
- Authorization requests work correctly with aviation context
- Background location capability enabled
- Handles authorization changes without crashes
- Always/WhenInUse authorization handled appropriately

VERIFY (PHASE 2):
- Creates CLCircularRegion for each saved location
- Respects 20-region iOS limit
- Prioritizes closest/most recently accessed locations when >20
- Regions update when saved locations change
- Start/stop monitoring works correctly
- Region identifiers unique and meaningful

VERIFY (PHASE 3):
- Entering region triggers condition check
- Notification sent only when conditions change significantly (e.g., airspace becomes restricted)
- Background fetch updates weather/NOTAM data
- Notifications respect user preferences (enabled/disabled per location)
- Battery impact is reasonable (test with Energy Diagnostics)
- Critical airspace alerts prioritized

INTEGRATION TEST:
- Save 25 locations, verify only 20 most important are monitored
- Simulate entering monitored region, verify notification with current conditions
- Simulate airspace change (new TFR), verify alert when entering region
- Kill app, enter region, verify notification still works
- Revoke location permission, verify graceful degradation
- Test battery usage over 24 hours with multiple geofence triggers

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass after EACH phase

STOP AFTER PHASE 1, verify CoreLocation setup before regions
STOP AFTER PHASE 2, verify region management before notification integration
```

---

## Example: Visual Crossing API Integration

```
Visual Crossing Weather API - Full integration with caching

ANALYZE FIRST:
Read these Swift files in order:
1. /Users/davidyutzy/Development/GetHooked/GetHooked/Services/WeatherService.swift - API integration pattern
2. /Users/davidyutzy/Development/GetHooked/GetHooked/Services/CacheManager.swift - caching approach
3. /Users/davidyutzy/Development/GetHooked/GetHooked/Models/WeatherData.swift - data model structure

Document:
- Visual Crossing API integration approach (already have subscription)
- Caching strategy - proven TTL approach
- Error handling pattern
- Data model structure

BUILD (PHASED):
Phase 1: FlightReady/Models/WeatherData.swift + WeatherConditions.swift (Codable models for aviation data)
Phase 2: FlightReady/Services/VisualCrossingService.swift (API client with URLSession)
Phase 3: FlightReady/Services/WeatherCacheManager.swift (FileManager-based caching)

KEY FACTS:
- API endpoint: https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline
- Authentication: X-Api-Key header (using existing subscription)
- Query params: coordinates, unitGroup=us, elements=temp,humidity,windspeed,windgust,visibility,cloudcover,precip,pressure
- Response is JSON with current conditions + forecast
- Cache TTL: 10 minutes for current conditions, 1 hour for forecast
- Rate limit: 1000 calls/day on paid plan
- Must handle network errors gracefully
- Use Codable for JSON parsing
- URLSession with dataTask for requests
- Cache keyed by "lat,lon" rounded to 2 decimals
- Aviation-specific: ceiling height, visibility, wind gusts critical

REQUIREMENTS:
- Fetch aviation-relevant weather data
- Include all drone-critical parameters (wind, gusts, visibility, ceiling)
- Cache responses to minimize API calls
- Handle rate limiting gracefully
- Provide clear error messages
- Support both current and forecast data
- Parse all aviation-relevant fields
- Convert units appropriately (knots to mph, etc.)

VERIFY (PHASE 1):
- WeatherData model decodes Visual Crossing JSON correctly
- All required properties present (temp, humidity, wind, windgust, visibility, ceiling, etc.)
- Optional properties handle nil gracefully
- Codable encoding/decoding works for cache storage
- Aviation-specific fields properly typed

VERIFY (PHASE 2):
- API call returns valid weather data
- Authentication header included correctly (using your existing API key)
- Network errors return proper Error types
- Invalid API key returns clear error message
- Rate limit error detected and surfaced to user
- All aviation-critical fields retrieved

VERIFY (PHASE 3):
- Cache stores and retrieves weather data correctly
- Cache TTL enforced (10min for current, 1hr for forecast)
- Cache invalidation works
- Disk usage is reasonable (<10MB)
- Stale cache data returns nil, triggering fresh API call
- Cache survives app restarts

INTEGRATION TEST:
- Fresh install makes API call, then uses cache for 10 minutes
- After 10 minutes, makes new API call
- Network unreachable returns cached data if available
- Invalid coordinates return error without caching
- 100 consecutive calls don't exceed rate limit (use cache)
- All aviation weather fields display correctly in UI

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass after EACH phase

STOP AFTER PHASE 1, verify JSON parsing with real Visual Crossing API response
STOP AFTER PHASE 2, verify API calls work with your existing subscription before implementing cache
```

---

## When to Use This Template

✅ **Use COMPLEX template when:**
- Feature spans 3+ Swift files
- Contains complex algorithms or calculations
- Requires phased implementation with checkpoints
- Integration with multiple iOS frameworks (CoreLocation, UserNotifications, etc.)
- High risk of subtle bugs if not done carefully
- Example features: scoring systems, background monitoring, API integrations with caching

✅ **Requires phased approach because:**
- Can't verify correctness until algorithm is isolated
- UI depends on business logic working correctly
- Data models must be validated before building on them
- Integration testing needed at each step

❌ **Don't use COMPLEX template when:**
- Feature can be built and tested in one shot
- No complex algorithms or calculations
- Simple enough for MEDIUM or SIMPLE template
