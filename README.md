# Context-Aware Recipe Discovery (Flutter)

This project implements the Flutter assignment: **Context-Aware Recipe Discovery** using **Bloc**, offline-first behavior, Location/Time context, and **meal-time scheduled notifications**.

## What to show in interview (2–3 minute demo script)

- **Context-aware home**
  - Launch app → it automatically loads recipes using **Time context** (Breakfast/Lunch/Dinner).
  - Location permission prompt may appear; if denied, app still works.
- **Search**
  - Type `chicken` / `fish` → see debounced search (no API spam).
  - Check console logs: `[RecipeAPI]` + `[RecipeBloc]`.
- **Offline-first**
  - Favorite 2–3 recipes.
  - Turn off internet → app still shows cached/favorite data.
- **Notifications**
  - Explain: app schedules **daily** notifications at **8:00 AM / 2:00 PM / 8:00 PM**.
  - If notification permission is denied, banner shows **Open Settings**.

## Assignment Mapping (PDF A/B/C)

### A) Smart Discovery & Search
- Uses public API: **TheMealDB** (`search.php?s=`).
- Time-based suggestions:
  - Morning -> Breakfast
  - Afternoon -> Lunch
  - Evening -> Dinner
- Location-based prioritization:
  - Country is detected (with permission handling).
  - Matching cuisine/area is moved higher in results.
- Debounced search:
  - 500ms debounce in `RecipeBloc` to reduce API spam.

### B) Offline-First Experience
- Favorites saved locally in Hive (`favorites` box).
- Recipe list/search cache saved in Hive (`cache` box).
- Viewed recipe entries also cached.
- On network failure:
  - app shows cached/favorite data instead of blank screen.
- Images are loaded with `CachedNetworkImage` for better cache usage.

### C) Proactive Engagement
- Daily local notifications scheduled at:
  - 8:00 AM (Breakfast)
  - 2:00 PM (Lunch)
  - 8:00 PM (Dinner)
- Notification bodies can include meal suggestions from fetched/cached recipes.
- Permission denied states (location/notifications) are handled and surfaced in UI banner.

## How to use (for reviewer)

- **Search**
  - Use the top search box.
  - Examples: `chicken`, `pasta`, `cake`.
- **Favorites**
  - Tap the heart icon on any recipe to save offline.
  - Switch to the **Favorites** tab to view saved recipes.
- **Recipe details**
  - Tap any recipe → opens details with Hero transition.
- **Permissions**
  - If Location/Notification permission is denied, app continues with fallback behavior.
  - If notifications are denied, use **Open Settings** button in the banner.

## Architecture

- **State Management:** Bloc
- **DI:** GetIt (`lib/injection_container.dart`)
- **Data Layer:** Repository pattern
- **Storage:** Hive (`favorites`, `cache`)
- **Notifications:** `flutter_local_notifications` + `timezone`
- **Location:** `geolocator` + `geocoding`

## Key files (quick navigation)

- **UI**
  - `lib/presentation/ui/recipe/recipe_home_page.dart` (Home, Search, Favorites, Banner)
  - `lib/presentation/ui/recipe/recipe_detail_page.dart` (Detail, Hero)
- **Bloc**
  - `lib/presentation/bloc/recipeBloc/recipe_bloc.dart`
  - `lib/presentation/bloc/recipeBloc/recipe_event.dart`
  - `lib/presentation/bloc/recipeBloc/recipe_state.dart`
- **Data**
  - `lib/data/respositoryImpl/repository_recipe_impl.dart` (TheMealDB API call + logs)
  - `lib/data/services/cache_service.dart` (cache)
  - `lib/data/services/fav_service.dart` (favorites)
  - `lib/data/services/location_context_service.dart` (country context)
  - `lib/data/services/meal_notification_service.dart` (scheduling)
- **Notification init**
  - `lib/utils/local_notification.dart` (plugin init, channel, icon)
  - `android/app/src/main/AndroidManifest.xml` (receivers/permissions)

## Main Flow

1. App opens `RecipeHomePage` as initial route.
2. `LoadInitialEvent` runs:
   - finds meal type by current time
   - fetches location context
   - calls recipe API
   - falls back to cache/favorites on failure
   - schedules daily meal notifications
3. User can:
   - search recipes (debounced)
   - favorite/unfavorite
   - switch between `All` and `Favorites`
   - manage notification permission (if denied, UI provides **Open Settings** button)

## Console Logs (for interview/demo)

Clear debug logs are added with tags:
- `[RecipeAPI]` -> API request/response/failure logs
- `[RecipeBloc]` -> search flow, fallback path, favorites, scheduling logs

Open debug console while running app to demonstrate behavior.

## Run Instructions

1. Install dependencies:
   - `flutter pub get`
2. Run app:
   - `flutter run`
3. First screen will be recipe module.

## Offline test steps

1. Open app once (loads initial recipes)
2. Favorite 2–3 recipes
3. Turn off internet (Airplane mode)
4. Relaunch app → it should show cached/favorite data instead of blank UI

## Notification behavior notes

- Notifications are **scheduled locally** (no server required).
- After first app launch, the daily schedule continues even if app is closed.
- On some OEM devices, battery optimization may delay scheduled notifications. For best results:
  - set the app to **Unrestricted / Don’t optimize** battery mode
  - ensure the notification channel is **High importance**

## Feature Verification Checklist

- Search with terms like `chicken`, `fish`, `cake`.
- Toggle favorite heart and open `Favorites` tab.
- Turn off internet and verify cached/favorite fallback.
- Keep app installed and verify scheduled notifications at meal times.

## Notes

- Local notifications generally work in foreground/background/terminated, but behavior may vary by device battery policies.
- CI/CD workflow for GitHub Releases can be added in `.github/workflows/main.yml` if required by final submission.
