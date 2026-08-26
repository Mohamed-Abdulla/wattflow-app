# WattFlow

WattFlow is a production-oriented Flutter application for energy monitoring and device management.

## Current feature

The current vertical slice is Device Management:

- List, search, and filter devices
- Add, edit, view, and delete devices
- Responsive Material 3 UI
- Loading, empty, error, retry, and refresh states
- Mock datasource behind a replaceable repository boundary
- Firebase Crashlytics integration

## Quick start

```bash
flutter pub get
dart run build_runner build
flutter run
```

Run the full local workflow with:

```bash
bash tool/verify.sh
```

## Architecture

```text
UI page/widget
    ↓
Riverpod controller
    ↓
Domain repository contract
    ↓
Repository implementation
    ↓
Datasource contract
    ↓
Mock datasource today / Dio REST datasource later
```

See [docs/developer-guide.md](docs/developer-guide.md) for the detailed contributor guide.

## Project structure

```text
lib/
├── app/                  # App shell, router, theme
├── core/                 # Errors, logging, networking, monitoring, shared UI
├── features/devices/     # Data, domain, presentation, and providers
└── main.dart             # Initialization and app startup
```

## Important commands

```bash
flutter pub get
dart run build_runner build
dart format lib
flutter analyze
flutter test
```

Generated `.g.dart` and `.freezed.dart` files must be regenerated, not edited manually.

## Firebase Crashlytics

These environment-specific files are ignored by Git:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `macos/Runner/GoogleService-Info.plist`

Configure Firebase with:

```bash
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

`lib/firebase_options.dart` should stay synchronized with the selected Firebase project. Crashlytics startup is fail-safe when Firebase is unavailable.

## Current production boundaries

The foundation is production-oriented, but device data is still mock-only, authentication is not implemented, the cache is in-memory, and automated tests still need to be added. The iOS deployment target is 15.0 because of the selected Firebase SDK.
