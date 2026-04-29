# Context-Aware Recipe Discovery (Flutter)

Production-style Flutter app built for the IVTEX assignment.  
The app suggests recipes using **time + location context**, supports **offline-first fallback**, and includes **scheduled meal notifications** with CI/CD release automation.

## Quick Interview Demo (2-3 minutes)

1. Launch app and show context-based loading (Breakfast/Lunch/Dinner by current time).
2. Deny location permission once and show graceful fallback (app still usable).
3. Search `chicken` or `pasta` and explain debounced API calls.
4. Favorite 2 recipes, disable internet, relaunch app, show cached/favorite data.
5. Show notification section and explain daily schedule (8:00 AM, 2:00 PM, 8:00 PM).
6. Tap the alarm icon in AppBar to trigger a quick test notification flow.

## Assignment Requirement Mapping

### A) Smart Discovery & Search
- Public API integration: **TheMealDB**.
- Time-based suggestions:
  - Morning -> Breakfast
  - Midday -> Lunch
  - Evening -> Dinner
- Location-aware prioritization:
  - Detects user country (if permission granted).
  - Prioritizes matching cuisine/area.
- Search optimization:
  - Debounced query handling in Bloc to avoid API spamming.

### B) Offline-First Experience
- Local persistence with Hive:
  - `favorites` box for saved recipes.
  - `cache` box for fetched/viewed recipe data.
- Cached image support with `CachedNetworkImage`.
- Network failure fallback:
  - Shows cached/favorited content instead of empty UI.

### C) Proactive Engagement
- Local notifications scheduled daily:
  - 8:00 AM -> Breakfast suggestion
  - 2:00 PM -> Lunch suggestion
  - 8:00 PM -> Dinner suggestion
- Permission handling:
  - Location/notification denial is handled gracefully with UI guidance.
- Manual tester utility:
  - AppBar alarm icon can trigger quick test notifications for easy interviewer verification.

## Tech Stack and Architecture

- State management: `flutter_bloc`
- Dependency injection: `get_it`
- Data pattern: Repository + services
- Local DB/cache: `hive`, `hive_flutter`
- Notifications: `flutter_local_notifications`, `timezone`
- Location: `geolocator`, `geocoding`

## Important Project Files

- UI
  - `lib/presentation/ui/recipe/recipe_home_page.dart`
  - `lib/presentation/ui/recipe/recipe_detail_page.dart`
- Bloc
  - `lib/presentation/bloc/recipeBloc/recipe_bloc.dart`
  - `lib/presentation/bloc/recipeBloc/recipe_event.dart`
  - `lib/presentation/bloc/recipeBloc/recipe_state.dart`
- Data + services
  - `lib/data/respositoryImpl/repository_recipe_impl.dart`
  - `lib/data/services/cache_service.dart`
  - `lib/data/services/fav_service.dart`
  - `lib/data/services/location_context_service.dart`
  - `lib/data/services/meal_notification_service.dart`
- Notification bootstrap
  - `lib/utils/local_notification.dart`
  - `android/app/src/main/AndroidManifest.xml`

## Run Locally

```bash
flutter pub get
flutter run
```

## Test Scenarios for Reviewer

### 1) Search + Debounce
- Type quickly in search bar (`chicken`, `fish`, `cake`).
- Observe smooth updates and no unnecessary repeated calls.

### 2) Offline fallback
1. Open app once with internet.
2. Favorite 2-3 recipes.
3. Disable network.
4. Reopen app and verify cached/favorites still visible.

### 3) Permission resilience
- Deny location -> app continues with generic results.
- Deny notifications -> UI still works; user can open app settings.
- If location or notification permission is denied, banner shows `Open Settings`.
- `Open Settings` opens app settings for both location and notification controls.
- After enabling permission and returning to app, screen refreshes automatically.

### 4) Quick notification test (Alarm icon)
1. Open app home screen.
2. Tap the alarm icon in top-right AppBar.
3. App shows snackbar confirming test schedule.
4. Wait around 30 seconds for test notification.
5. If not received, ensure notification permission is enabled and retry.

## CI/CD Pipeline (GitHub Actions)

Workflow file: `.github/workflows/main.yml`

On push/PR to `main` or `master`, pipeline runs:
1. `flutter analyze`
2. `flutter test`
3. `flutter build apk --release`
4. Upload APK as workflow artifact
5. On push to `main/master`, publish APK to GitHub Releases

### How to trigger CI/CD

```bash
git add .
git commit -m "Trigger CI"
git push origin main
```

After successful run:
- Check **Actions** tab for green pipeline.
- Check **Releases** section for generated release APK.

## Notes

- Notifications are local (no backend required).
- On some devices, battery optimization may delay notifications; allow unrestricted battery mode for accurate timing.
- The AppBar alarm icon is a testing shortcut to validate notification setup quickly during demo/interview.
