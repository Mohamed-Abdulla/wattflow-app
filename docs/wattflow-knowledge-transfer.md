# WattFlow architecture knowledge transfer

## What we built

WattFlow currently contains one vertical slice: device management. It supports fetching mock devices, searching and filtering, adding, editing, viewing details, deleting, refreshing, and presenting loading, empty, and error states.

The application is deliberately structured as if the backend already exists. The UI depends on a repository contract, not on mock data or Dio.

## Verification command file

Run the commented workflow with:

```bash
bash tool/verify.sh
```

The script stops at the first failure, making it suitable for local checks and CI.

## Packages and why they exist

| Package | Why WattFlow uses it |
| --- | --- |
| `flutter_riverpod` | Dependency injection and reactive application state without coupling widgets to repositories. |
| `riverpod_annotation` | Declares providers/controllers with annotations. |
| `riverpod_generator` | Generates provider boilerplate consistently. |
| `go_router` | Centralized URL navigation, path parameters, browser support, and deep-linkable detail routes. |
| `dio` | Future REST client with timeouts, interceptors, request IDs, and centralized error mapping. It is configured now but the feature still uses mock data. |
| `freezed_annotation` | Immutable model declarations and generated value semantics. |
| `freezed` | Generates immutable implementations and `copyWith`. |
| `json_annotation` | JSON serialization annotations for API-ready models. |
| `json_serializable` | Generates `fromJson`/`toJson` implementations. |
| `build_runner` | Runs the code generators. |
| `firebase_core` | Initializes Firebase after a Firebase project is connected. |
| `firebase_crashlytics` | Captures uncaught Flutter and asynchronous errors in production. It safely continues without remote reporting until FlutterFire configuration is completed. |

We intentionally did not add `fpdart`, secure storage, or persistent caching yet. There are no auth tokens, complex result pipelines, or offline requirements in this feature that justify them.

## Feature-first folder structure

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/app_router.dart
│   └── theme/app_theme.dart
├── core/
│   ├── error/app_failure.dart
│   ├── logging/app_logger.dart
│   ├── monitoring/crash_reporter.dart
│   ├── network/api_client.dart
│   └── widgets/app_widgets.dart
├── features/
│   └── devices/
│       ├── data/datasources/
│       ├── data/repositories/
│       ├── domain/entities/
│       ├── domain/repositories/
│       ├── presentation/controllers/
│       ├── presentation/pages/
│       ├── presentation/widgets/
│       └── providers/
└── main.dart
```

Feature-first grouping keeps all device-management code discoverable. When energy usage, automations, or authentication are added, each can own its domain, data, state, and UI without creating one giant global module.

The layers have distinct responsibilities:

- `domain` contains business concepts and repository contracts. It does not know about Flutter, Dio, or mock data.
- `data` implements those contracts. `MockDeviceDataSource` can later be replaced by `RemoteDeviceDataSource` without changing pages or controllers.
- `presentation` renders state and collects input. Widgets do not call datasources or repositories directly.
- `providers` contains feature dependency wiring and keeps state granular.
- `core` contains cross-feature errors, logging, networking, monitoring, and reusable UI primitives.

This is a good long-term plan because boundaries, ownership, state flow, and error handling are established before a real backend arrives, without adding abstractions that the current feature does not need.

## Dart language choices

### `abstract interface class`

`DeviceRepository` and `DeviceDataSource` are contracts. Consumers depend on the API, while concrete implementations live elsewhere. This makes fake testing and replacement with a REST implementation straightforward.

### `sealed class`

`AppFailure` is sealed so the application owns the complete family of known failures: timeout, network, server, authorization, not-found, validation, and unexpected errors. Future switches over failures can be exhaustively checked by the analyzer.

### `factory` constructors

`Device.fromJson` is a factory because deserialization returns the generated immutable implementation. Callers use the stable `Device` API without knowing about `_Device` or JSON mapping details.

### Freezed immutability

Devices are immutable values. Updates create new objects with `copyWith`, preventing hidden mutation and making Riverpod state predictable. Generated equality also helps tests and rebuild decisions.

### Generated providers

`@riverpod` declarations generate provider wiring from a single source of truth. `DevicesController` owns async CRUD actions and exposes `AsyncValue<List<Device>>`, giving the UI explicit loading, data, and error states without a manually maintained global store.

## Data flow

```text
Page/widget
  → DevicesController
    → DeviceRepository
      → DeviceDataSource
        → MockDeviceDataSource today
        → RemoteDeviceDataSource + Dio later
```

The repository maintains a small memory cache for the current list and updates or invalidates it after mutations. Persistent caching is deferred until offline behavior or cold-start performance makes it valuable.

## Replacing mock data with Spring Boot API

Add `RemoteDeviceDataSource` using the existing `ApiClient`, map response DTOs into `Device`, and switch `deviceDataSourceProvider` from `MockDeviceDataSource` to the remote implementation. Routes, pages, widgets, and controller actions should remain unchanged.

Authentication and response validation belong at the API/data boundary, not inside widgets. `ApiClient.mapError` is the central HTTP-to-application failure mapping point.

## Testing plan

- Repository tests: fake the datasource and verify cache reads, invalidation, CRUD mapping, and failures.
- Controller tests: override `deviceRepositoryProvider` with a fake repository and verify loading, success, retry, and mutation errors.
- Form tests: verify required name, type, and room validation plus successful submission.
- Widget tests: verify loading, empty, error, search/filter, cards, confirmation dialogs, and responsive layouts.
- Integration tests: verify GoRouter list/detail/edit flows on supported platforms.

## Crashlytics setup

The app now initializes Crashlytics defensively in `lib/core/monitoring/crash_reporter.dart`. Before Firebase is configured, it logs the configuration failure and continues startup. Once configured, it registers Flutter fatal-error and uncaught async-error handlers.

Complete project-specific setup from the repository root:

```bash
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
flutter run
```

In Firebase Console, enable Crashlytics for the selected Android/iOS apps. Google Analytics is optional but recommended by Firebase for automatic breadcrumb logs. Force one test crash on a non-production build and confirm it appears in the Crashlytics dashboard before relying on the integration.

Do not put tokens or secrets in `firebase_options.dart`; Firebase configuration identifiers are platform app identifiers, not credentials. Keep production collection policy and privacy/consent requirements explicit before release.

## Useful commands

```bash
bash tool/verify.sh
dart run build_runner build
dart run build_runner watch
flutterfire configure
flutter build apk --release --split-debug-info=build/symbols
```
