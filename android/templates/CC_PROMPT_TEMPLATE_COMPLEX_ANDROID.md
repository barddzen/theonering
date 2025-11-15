# Claude Code Prompt Template - COMPLEX Features (Android)

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
- [Architectural patterns to adapt for Android]
- [Algorithm approaches that apply]
- [Integration patterns to reuse]
- [iOS frameworks → Android equivalents]

BUILD (PHASED):
Phase 1: [path/to/first/file.kt] - [what it does]
Phase 2: [path/to/second/file.kt] - [what it does]
Phase 3: [path/to/third/file.kt] - [what it does]

KEY FACTS:
- [Critical constraint 1]
- [Critical constraint 2]
- [Critical constraint 3]
- [Algorithm detail 1]
- [Algorithm detail 2]
- [Data format requirement]
- [Integration requirement]
- [Android-specific considerations]
[Max 10 bullets - be thorough for complex features]

REQUIREMENTS:
- [Exact algorithm behavior needed]
- [Exact data transformations needed]
- [Exact calculation thresholds needed]
- [Exact UI presentation needed (iOS → Android translation)]
- [Exact integration requirements (iOS frameworks → Android equivalents)]

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

BUILD CLEAN: ./gradlew assembleDebug must pass after EACH phase

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
- Weighted factor approach - adapt for aviation with Kotlin
- Score calculation and combination method
- Factor breakdown UI pattern for Material Design
- Color-coded presentation approach

BUILD (PHASED):
Phase 1: app/src/main/java/com/flightready/app/models/FlightScore.kt + FlightConditions.kt (data classes)
Phase 2: app/src/main/java/com/flightready/app/services/FlightScoreCalculator.kt (scoring algorithm)
Phase 3: app/src/main/java/com/flightready/app/ui/activities/ScoreDetailActivity.kt (UI with factor breakdown)

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
- Use Kotlin data classes for immutability
- Calculate scores in background thread (use Coroutines)

REQUIREMENTS:
- Weighted scoring algorithm combining all factors
- Factor values normalized to 0-100 scale
- Final score accounts for both weather and airspace
- Score-to-rating mapping clear and consistent
- Color coding follows aviation safety standards
- Individual factor scores visible in breakdown
- Algorithm handles missing data gracefully
- Calculations run asynchronously

VERIFY (PHASE 1):
- FlightScore data class has all 6 factor properties
- FlightConditions enum/sealed class has all 5 rating levels
- Weights sum to 1.0
- Color resource ID returns correct color for each rating

VERIFY (PHASE 2):
- Test case 1: wind=5mph, vis=10mi, ceil=5000ft, precip=none, airspace=clear → score ~95 (Excellent)
- Test case 2: wind=18mph, vis=3mi, ceil=800ft, precip=light, airspace=clear → score ~25 (Poor)
- Test case 3: wind=5mph, vis=10mi, ceil=5000ft, precip=none, airspace=restricted → score ~0 (Restricted)
- All 6 factors contribute to final score
- Edge cases: missing data uses conservative defaults
- Airspace restrictions override weather when severe
- Calculations run in background (viewModelScope.launch)

VERIFY (PHASE 3):
- Detail activity displays overall score with correct color background
- Factor breakdown shows individual scores with Material Icons
- Airspace restrictions clearly highlighted
- Updates in real-time when weather data changes (observes StateFlow/LiveData)
- Handles loading state gracefully (shimmer effect or progress indicator)
- NOTAM/TFR information integrated into display

BUILD CLEAN: ./gradlew assembleDebug must pass after EACH phase

STOP AFTER PHASE 1, verify data models before algorithm
STOP AFTER PHASE 2, verify algorithm accuracy and aviation-specific thresholds before UI
```

---

## Example: Background Location Monitoring

```
Background Location Monitoring - Geofence alerting for saved flight locations

ANALYZE FIRST:
Read these Swift files in order:
1. /Users/davidyutzy/Development/GetHooked/GetHooked/Managers/LocationManager.swift - CLLocationManager pattern
2. /Users/davidyutzy/Development/GetHooked/GetHooked/Models/SavedLocation.swift - location storage approach
3. /Users/davidyutzy/Development/GetHooked/GetHooked/Services/GeofenceService.swift - region monitoring pattern

Document:
- Location manager configuration pattern - adapt to Android
- Region monitoring approach - translate to Geofencing API
- Background modes - translate to Android services/WorkManager
- Battery optimization strategies

BUILD (PHASED):
Phase 1: app/src/main/java/com/flightready/app/managers/LocationMonitoringManager.kt (Location Services setup)
Phase 2: app/src/main/java/com/flightready/app/services/GeofenceManager.kt (geofence management)
Phase 3: app/src/main/java/com/flightready/app/workers/BackgroundAlertWorker.kt (WorkManager for background checks)

KEY FACTS:
- Android geofencing uses Geofencing API (com.google.android.gms.location.GeofencingClient)
- Android 10+ requires ACCESS_BACKGROUND_LOCATION permission (separate from foreground)
- Maximum 100 geofences per app (vs iOS 20 regions)
- Must use PendingIntent to receive geofence transitions
- GeofencingEvent contains trigger type (ENTER, EXIT, DWELL)
- Battery optimization: use RESPONSIVENESS_DELAY for less aggressive monitoring
- WorkManager for periodic background weather updates
- Geofence radius from saved location radius (0.8km-40km, convert from miles)
- Must handle Play Services availability
- Foreground service required for continuous location on Android 8+

REQUIREMENTS:
- Monitor up to 100 saved flight locations simultaneously
- Prioritize locations by proximity and recency if needed
- Trigger alerts when entering monitored geofences
- Check airspace/weather conditions when triggered
- Alert only on significant condition changes
- Respect user notification preferences per location
- Handle authorization changes gracefully
- Optimize for battery life
- Work with PendingIntent even when app is killed

VERIFY (PHASE 1):
- FusedLocationProviderClient properly configured
- Permission requests work correctly (foreground, then background)
- Foreground service for continuous tracking (if needed)
- Handles permission changes without crashes

VERIFY (PHASE 2):
- Creates Geofence objects for each saved location
- Properly adds geofences via GeofencingClient
- PendingIntent receives geofence transitions
- GeofencingEvent parsed correctly (ENTER/EXIT/DWELL)
- Geofences update when saved locations change
- Start/stop monitoring works correctly

VERIFY (PHASE 3):
- Entering geofence triggers condition check via WorkManager
- Notification sent only when conditions change (e.g., airspace becomes restricted)
- WorkManager periodic task updates weather/NOTAM data
- Notifications respect user preferences (enabled/disabled per location)
- Battery impact is reasonable (check with Battery Historian)
- Critical airspace alerts prioritized

INTEGRATION TEST:
- Save 50 locations, verify all are monitored (Android allows 100)
- Simulate entering monitored geofence, verify notification with current conditions
- Simulate airspace change (new TFR), verify alert when entering geofence
- Kill app, enter geofence, verify notification still works (PendingIntent)
- Revoke location permission, verify graceful degradation
- Test on Android 10+ with background location permission
- Test battery usage over 24 hours

BUILD CLEAN: ./gradlew assembleDebug must pass after EACH phase

STOP AFTER PHASE 1, verify Location Services setup before geofences
STOP AFTER PHASE 2, verify geofence management before WorkManager integration
```

---

## Example: Visual Crossing API Integration

```
Visual Crossing Weather API - Full integration with Room database caching

ANALYZE FIRST:
Read these Swift files in order:
1. /Users/davidyutzy/Development/GetHooked/GetHooked/Services/WeatherService.swift - API integration pattern
2. /Users/davidyutzy/Development/GetHooked/GetHooked/Services/CacheManager.swift - caching approach
3. /Users/davidyutzy/Development/GetHooked/GetHooked/Models/WeatherData.swift - data model structure

Document:
- Visual Crossing API integration pattern (already have subscription)
- Caching strategy - adapt to Room database
- Error handling approach - translate to sealed classes
- Data model structure

BUILD (PHASED):
Phase 1: app/src/main/java/com/flightready/app/models/WeatherData.kt + WeatherConditions.kt (data classes with @Serializable)
Phase 2: app/src/main/java/com/flightready/app/services/VisualCrossingService.kt (Retrofit API client)
Phase 3: app/src/main/java/com/flightready/app/services/WeatherCacheManager.kt (Room database caching)

KEY FACTS:
- API endpoint: https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline
- Authentication: X-Api-Key header (add via OkHttp interceptor)
- Query params: coordinates, unitGroup=us, elements=temp,humidity,windspeed,windgust,visibility,cloudcover,precip,pressure
- Response is JSON with current conditions + forecast
- Cache TTL: 10 minutes for current conditions, 1 hour for forecast
- Rate limit: 1000 calls/day on paid plan
- Must handle network errors gracefully (sealed class Result<T>)
- Use Retrofit with Gson/kotlinx.serialization for JSON parsing
- Use Room database for persistent cache
- Cache keyed by "lat,lon" rounded to 2 decimals
- Use Coroutines for async operations
- Aviation-specific: ceiling height, visibility, wind gusts critical

REQUIREMENTS:
- Fetch aviation-relevant weather data
- Include all drone-critical parameters (wind, gusts, visibility, ceiling)
- Cache responses in Room to minimize API calls
- Handle rate limiting gracefully
- Provide clear error messages
- Support both current and forecast data
- Parse all aviation-relevant fields
- Convert units appropriately (knots to mph, etc.)
- Async operations with Coroutines

VERIFY (PHASE 1):
- WeatherData model deserializes Visual Crossing JSON correctly (@SerializedName annotations)
- All required properties present (temp, humidity, wind, windgust, visibility, ceiling, etc.)
- Optional properties handle null gracefully (nullable types)
- Data classes work with Room @Entity
- Aviation-specific fields properly typed

VERIFY (PHASE 2):
- API call returns valid weather data via Retrofit
- Authentication header included correctly (OkHttp interceptor)
- Network errors return proper sealed class error types
- Invalid API key returns clear error message
- Rate limit error detected and surfaced to user
- Coroutine-based async calls work properly
- All aviation-critical fields retrieved

VERIFY (PHASE 3):
- Room database stores and retrieves weather data correctly
- Cache TTL enforced via timestamp comparison
- Cache invalidation works (delete old entries)
- Database size is reasonable (<10MB)
- Stale cache data returns null, triggering fresh API call
- Room queries run on IO dispatcher
- Cache survives app restarts

INTEGRATION TEST:
- Fresh install makes API call, then uses Room cache for 10 minutes
- After 10 minutes, makes new API call and updates cache
- Network unreachable returns cached data if available from Room
- Invalid coordinates return error without caching
- 100 consecutive calls don't exceed rate limit (use cache)
- App restart retrieves data from Room cache
- All aviation weather fields display correctly in UI

BUILD CLEAN: ./gradlew assembleDebug must pass after EACH phase

STOP AFTER PHASE 1, verify JSON parsing with real Visual Crossing API response
STOP AFTER PHASE 2, verify API calls work with existing subscription before implementing Room cache
```

---

## When to Use This Template

✅ **Use COMPLEX template when:**
- Feature spans 3+ Swift files → 3+ Kotlin files
- Contains complex algorithms or calculations
- Requires phased implementation with checkpoints
- Integration with multiple Android frameworks (Location Services, WorkManager, Room, etc.)
- High risk of subtle bugs if not done carefully
- Example features: scoring systems, background monitoring, API integrations with caching

✅ **Requires phased approach because:**
- Can't verify correctness until algorithm is isolated
- UI depends on business logic working correctly
- Data models must be validated before building on them
- Integration testing needed at each step
- Android lifecycle complexities require careful testing

❌ **Don't use COMPLEX template when:**
- Feature can be built and tested in one shot
- No complex algorithms or calculations
- Simple enough for MEDIUM or SIMPLE template
