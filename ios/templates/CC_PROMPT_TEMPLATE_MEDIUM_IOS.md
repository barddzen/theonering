# Claude Code Prompt Template - MEDIUM Features (iOS)

**Use for:** 2-3 files, moderate complexity, UI + business logic, potential integration challenges

---

## Template

```
[FEATURE NAME] - [Brief description]

ANALYZE FIRST (if adapting from GetHooked):
Read [exact Swift file path from GetHooked iOS]
Document: architectural patterns to adapt, integration approaches, what translates well to aviation use case

BUILD:
File: [exact iOS file path to create/modify]
Implementation: [2-3 sentence description including what it integrates with]

KEY FACTS:
- [Critical constraint 1]
- [Critical constraint 2]
- [Critical constraint 3]
- [Critical constraint 4]
- [Critical constraint 5]
[Max 7 bullets - include integration gotchas]

REQUIREMENTS:
- [Specific behavior requirement]
- [Specific UI pattern requirement]
- [Specific data format requirement]
- [Integration requirement]

VERIFY:
- [Test case 1]
- [Test case 2]
- [Test case 3]
- [Integration test]

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass

CRITICAL: [Add this section if there are known gotchas or tricky interactions]
```

---

## Example: Location Detail View

```
Location Detail View - Weather and airspace status display

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/ViewControllers/LocationDetailViewController.swift
Document: layout structure, color-coded rating display, data binding patterns - adapt for aviation data

BUILD:
File: FlightReady/ViewControllers/LocationDetailViewController.swift
Implementation: Shows current weather conditions, airspace status, and flight score with color-coded UI

KEY FACTS:
- Displays flight score (0-100) with color background
- Shows weather details: wind, pressure, visibility, clouds
- Shows airspace status: clear, caution, restricted
- Pull-to-refresh updates all data
- Color scheme: green (excellent), yellow (good/caution), orange (fair), red (poor/restricted)
- Must handle nil data gracefully (loading state)
- Updates when location changes

REQUIREMENTS:
- Display all critical aviation weather metrics
- Color coding matches aviation safety standards
- Pull-to-refresh triggers data reload
- Loading state shows activity indicator
- Graceful handling of missing data
- Real-time updates when data changes

VERIFY:
- View displays all weather metrics correctly
- Score background color matches rating (80+=green, 60-79=yellow, etc.)
- Pull-to-refresh triggers data reload
- Loading state shows activity indicator
- Nil data doesn't crash, shows placeholder text
- NOTAM/TFR information displays correctly

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass

CRITICAL: Use Auto Layout constraints for safe area compatibility. Test on both iPhone and iPad to ensure layout adapts properly. Aviation data must be clearly readable in all lighting conditions.
```

---

## Example: Map Annotation Callouts

```
Map Annotation Callouts - Custom callout views for flight location pins

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Views/LocationAnnotationView.swift
Document: callout pattern, custom view hierarchy - adapt for saved flight locations

BUILD:
File: FlightReady/Views/LocationAnnotationView.swift
Implementation: Custom MKAnnotationView with callout showing location name, DMS coordinates, and current status

KEY FACTS:
- Inherits from MKMarkerAnnotationView
- Custom callout accessory view
- Shows location name (top), DMS coords (middle), status (bottom)
- Tap callout to open detail view
- Marker color matches flight conditions status
- Must handle clustering (multiple nearby locations)

REQUIREMENTS:
- Display location name and coordinates in callout
- Show current flight conditions status
- Marker color reflects airspace/weather status
- Tap callout opens detail view
- Handle map clustering properly
- Status updates refresh marker appearance

VERIFY:
- Tap marker shows callout
- Callout displays correct location data and status
- Marker colors match conditions (green/yellow/orange/red)
- Tap callout opens detail view controller
- Clustering works correctly
- No marker flashing during updates
- Restricted airspace clearly indicated

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass

CRITICAL: MapKit reuses annotation views. Must properly configure view in prepareForReuse() to avoid displaying stale data. Status colors must be consistent with aviation safety conventions.
```

---

## Example: Notification Permission Manager

```
Notification Permission Manager - Request and track notification permissions

ANALYZE FIRST:
Read /Users/davidyutzy/Development/GetHooked/GetHooked/Managers/NotificationManager.swift
Document: permission flow, authorization tracking - adapt for flight condition alerts

BUILD:
File: FlightReady/Managers/NotificationPermissionManager.swift
Implementation: Handles requesting, tracking notification permissions for airspace and weather alerts

KEY FACTS:
- Uses UNUserNotificationCenter
- Three states: notDetermined, authorized, denied
- Must request authorization before scheduling notifications
- User can change permission in Settings app
- Need to check status before each notification
- Different permission levels: badge, sound, alert
- iOS 15+ supports provisional auth

REQUIREMENTS:
- Request notification permission appropriately
- Track authorization status
- Handle permission state changes
- Support different notification types (urgent vs informational)
- Provide clear rationale for permission request
- Graceful degradation when denied

VERIFY:
- First launch prompts for permission with clear aviation context
- Authorized state allows notification scheduling
- Denied state handled without crashes
- Permission changes detected when app resumes
- Provisional notifications work on iOS 15+
- Critical alerts (airspace violations) clearly distinguished

BUILD CLEAN: xcodebuild -scheme FlightReady clean build must pass

CRITICAL: Always check authorization status before scheduling notifications. Status can change while app is backgrounded if user visits Settings. Aviation alerts require urgent notification treatment.
```

---

## When to Use This Template

✅ **Use MEDIUM template when:**
- Feature spans 2-3 Swift files
- Requires UI + business logic
- Integrates with existing system (MapKit, CoreLocation, notifications)
- Has UI interactions that affect other components
- Known gotchas or integration challenges exist
- Example features: view controllers with services, custom views with delegates, permission managers

❌ **Don't use MEDIUM template when:**
- Feature is simple enough for SIMPLE template (1 file, no integration)
- Feature is so complex it needs phased implementation (use COMPLEX template)
- Algorithm-heavy with minimal UI
