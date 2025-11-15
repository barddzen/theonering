# Claude Code Prompt Template - MEDIUM Features (Android)

**Use for:** 2-3 files, moderate complexity, UI + business logic, potential integration challenges

---

## Template

```
[FEATURE NAME] - [Brief description]

ANALYZE FIRST (if adapting from GetHooked):
Read [exact Swift file path from GetHooked iOS]
Document: architectural patterns to adapt, integration approaches, translate iOS patterns to Android equivalents

BUILD:
File: [exact Android Kotlin file path to create/modify]
Implementation: [2-3 sentence description including what it integrates with]

KEY FACTS:
- [Critical constraint 1]
- [Critical constraint 2]
- [Critical constraint 3]
- [Critical constraint 4]
- [Critical constraint 5]
[Max 7 bullets - include integration gotchas, Android-specific considerations]

REQUIREMENTS:
- [Specific behavior requirement]
- [Specific UI pattern requirement (iOS → Android translation)]
- [Specific data format requirement]
- [Integration requirement]

VERIFY:
- [Test case 1]
- [Test case 2]
- [Test case 3]
- [Integration test]

BUILD CLEAN: ./gradlew assembleDebug must pass

CRITICAL: [Add this section if there are known gotchas or tricky Android interactions]
```

---

## Example: Location Detail Activity

```
Location Detail Activity - Weather and airspace status display

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/ViewControllers/LocationDetailViewController.swift
Document: layout structure, color-coded rating display, data binding patterns - adapt for Android/Material Design

BUILD:
File: app/src/main/java/com/flightready/app/ui/activities/LocationDetailActivity.kt + activity_location_detail.xml
Implementation: Shows current weather conditions, airspace status, and flight score with color-coded UI using ViewBinding

KEY FACTS:
- Displays flight score (0-100) with color background
- Shows weather details: wind, pressure, visibility, clouds
- Shows airspace status: clear, caution, restricted
- SwipeRefreshLayout for pull-to-refresh
- Color scheme: green (excellent), yellow (good/caution), orange (fair), red (poor/restricted)
- Must handle null data gracefully (loading state, skeleton screens)
- Updates when location changes (observe LiveData or StateFlow)

REQUIREMENTS:
- Display all critical aviation weather metrics
- Color coding matches aviation safety standards
- Pull-to-refresh triggers data reload via ViewModel
- Loading state with skeleton screens or shimmer effect
- Graceful handling of missing data
- Real-time updates when data changes
- NOTAM/TFR information clearly displayed

VERIFY:
- Activity displays all weather metrics correctly
- Score background color matches rating (80+=green, 60-79=yellow, etc.)
- Pull-to-refresh triggers data reload via ViewModel
- Loading state shows shimmer effect or progress indicator
- Null data doesn't crash, shows placeholder text
- Airspace restrictions prominently displayed

BUILD CLEAN: ./gradlew assembleDebug must pass

CRITICAL: Use ViewBinding for type-safe view access. Handle Activity lifecycle properly - observe LiveData/StateFlow in lifecycleScope to avoid leaks. Aviation safety-critical information must be clearly visible.
```

---

## Example: Map Marker Info Windows

```
Map Marker Info Windows - Custom info windows for flight location markers

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Views/LocationAnnotationView.swift
Document: callout pattern, custom view hierarchy - adapt for Google Maps InfoWindowAdapter

BUILD:
File: app/src/main/java/com/flightready/app/ui/adapters/LocationInfoWindowAdapter.kt + marker_info_window.xml
Implementation: Custom GoogleMap.InfoWindowAdapter showing location name, DMS coordinates, and current status

KEY FACTS:
- Implements GoogleMap.InfoWindowAdapter interface
- Custom layout inflated in getInfoWindow() or getInfoContents()
- Shows location name (top), DMS coords (middle), status (bottom)
- Tap info window to open detail activity
- Marker colors must match location status
- Must work WITH ClusterManager (not replace it)
- ClusterManager.cluster() resets click listeners

REQUIREMENTS:
- Display location name and coordinates in info window
- Show current flight conditions status
- Marker color reflects airspace/weather status
- Tap info window opens detail activity
- Handle map clustering properly
- Status updates refresh marker appearance
- Airspace restrictions clearly indicated

VERIFY:
- Tap marker shows info window
- Info window displays correct location data and status
- Marker colors stay correct after info window shown
- Tap info window opens LocationDetailActivity
- Clustering still works properly
- No marker flashing during updates
- Restricted airspace has distinct visual treatment

BUILD CLEAN: ./gradlew assembleDebug must pass

CRITICAL: After every ClusterManager.cluster() call, must re-set map.setOnMarkerClickListener and map.setOnInfoWindowClickListener. ClusterManager overwrites these listeners, breaking custom behavior. Aviation status must follow safety color conventions.
```

---

## Example: Notification Permission Manager

```
Notification Permission Manager - Request and track notification permissions

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Managers/NotificationManager.swift
Document: permission flow pattern - adapt for Android 13+ runtime permissions

BUILD:
File: app/src/main/java/com/flightready/app/managers/NotificationPermissionManager.kt
Implementation: Handles requesting, tracking notification permissions using ActivityResultLauncher for Android 13+

KEY FACTS:
- Android 13+ requires runtime permission (POST_NOTIFICATIONS)
- Use ActivityResultLauncher with ActivityResultContracts.RequestPermission()
- Three states: not determined, granted, denied
- Must request permission before posting notifications
- User can revoke permission in Settings
- Check permission status before each notification
- NotificationManager.areNotificationsEnabled() for system-wide check
- Different permission on Android 12 and below (no runtime permission needed)

REQUIREMENTS:
- Request notification permission appropriately with aviation context
- Track authorization status
- Handle permission state changes
- Support different notification types (urgent airspace alerts vs informational)
- Provide clear rationale for permission request
- Graceful degradation when denied
- Respect system notification settings

VERIFY:
- First launch on Android 13+ prompts for permission with clear context
- Granted state allows notification posting
- Denied state handled without crashes
- Permission changes detected when app resumes (onResume checks)
- Android 12 and below work without runtime permission
- Critical airspace alerts clearly distinguished from routine notifications

BUILD CLEAN: ./gradlew assembleDebug must pass

CRITICAL: Always check permission status before posting notifications. On Android 13+, use ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS). Permission can change while app is paused if user visits Settings. Aviation alerts require urgent notification treatment.
```

---

## When to Use This Template

✅ **Use MEDIUM template when:**
- Feature spans 2-3 Swift files
- Requires Activity/Fragment + layout XML + possibly ViewModel
- Integrates with Android system (Google Maps, Location Services, NotificationManager)
- Has UI interactions that affect other components
- Known gotchas or integration challenges exist
- Example features: activities with services, custom adapters with side effects, permission managers

❌ **Don't use MEDIUM template when:**
- Feature is simple enough for SIMPLE template (1 file, no integration)
- Feature is so complex it needs phased implementation (use COMPLEX template)
- Algorithm-heavy with minimal UI
