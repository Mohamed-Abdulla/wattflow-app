# WattFlow developer guide

This document is the source of truth for extending WattFlow. Follow these boundaries when adding features so the app remains testable, replaceable, and understandable.

## Production-practice audit

The current implementation follows the intended production patterns:

- Feature-first structure keeps feature code together.
- UI pages render state and collect input; they do not call datasources.
- Riverpod controllers own asynchronous actions and state transitions.
- Repository contracts hide storage and transport choices.
- Datasources isolate mock data today and REST data later.
- Freezed models are immutable and generated JSON serialization is used.
- `AppFailure` provides a controlled error family.
- `userFacingErrorMessage` prevents technical details leaking into UI.
- `AppSnackBar` centralizes transient error feedback and styling.
- Dio is configured centrally with timeouts, request IDs, and error mapping.
- Crashlytics handles uncaught Flutter and asynchronous errors.
- Firebase platform files are ignored and must be provisioned per environment.
- Theme and reusable widgets prevent styling drift.
- Responsive layouts use constraints rather than device-specific widths.

Known boundaries are explicit: device data is mock-only, authentication is not implemented, the cache is in-memory, and automated tests still need to be added.

## Folder responsibilities

```text
lib/
├── app/                  App shell, router, and theme
├── core/                 Cross-feature capabilities
│   ├── error/            Failure types and user-facing error mapping
│   ├── logging/          Centralized safe logging
│   ├── monitoring/       Crashlytics bootstrap
│   ├── network/          Dio client and HTTP error mapping
│   └── widgets/          Reusable UI and feedback components
├── features/
│   └── devices/
│       ├── data/         Datasources and repository implementation
│       ├── domain/       Entities and repository contracts
│       ├── presentation/ Pages, widgets, and controllers
│       └── providers/    Feature dependency wiring
└── main.dart             Startup initialization
```

Keep dependencies flowing inward:

```text
Presentation → Domain contracts ← Data implementations
```

The domain must not import Flutter, Dio, or a concrete datasource.

## Riverpod rules

Use generated providers with `@riverpod`.

Use `ref.watch` when a widget must rebuild when state changes:

```dart
final state = ref.watch(devicesControllerProvider);
```

Use `ref.read` for one-time reads, callbacks, and controller actions:

```dart
await ref.read(devicesControllerProvider.notifier).delete(id);
```

Render `AsyncValue` explicitly with `.when` whenever loading, error, and data require different UI. Do not treat loading as not-found.

Controllers should:

- Keep business actions out of widgets.
- Preserve the last successful list when a mutation fails.
- Rethrow mutation errors after restoring state so pages can show feedback.
- Use `AsyncValue` for initial load and refresh.
- Avoid one giant global state object.

Mutation flow in WattFlow is:

```text
Page action → controller mutation → repository → datasource
                                      ↓
                              refresh cached list
                                      ↓
                              AsyncData<List<Device>>
```

## Data and repository rules

The repository is application-facing. It owns caching, error normalization, and orchestration. The datasource is storage-facing. It owns mock memory data or future Dio calls.

It is acceptable for the two interfaces to have similar CRUD methods while the feature is small. They remain separate because their responsibilities and dependencies differ. If a repository becomes a pure pass-through, either add meaningful behavior or remove the unnecessary layer.

When replacing mock data:

1. Add `RemoteDeviceDataSource` implementing `DeviceDataSource`.
2. Use `ApiClient` for REST calls.
3. Map response JSON into immutable domain models.
4. Map transport errors to `AppFailure`.
5. Change the datasource provider only.

Pages and controllers should not change for this migration.

## Error handling and feedback

Throw `AppFailure` subclasses for expected application failures. Unknown errors are wrapped as `UnexpectedFailure` by the repository.

Use `userFacingErrorMessage(error)` when a widget needs text. It exposes safe user messaging and avoids showing technical details.

Use `AppSnackBar.showError(context, error)` for transient mutation failures. Do not create ad-hoc `ScaffoldMessenger` or `SnackBar` styling in individual pages.

Log technical details through `AppLogger` or Crashlytics, never in user-facing text. Do not log tokens, passwords, secrets, or sensitive personal data.

## Models and Dart language choices

- `abstract interface class` defines replaceable contracts such as repositories and datasources.
- `sealed class` defines the closed `AppFailure` family, enabling exhaustive handling.
- `factory` constructors such as `Device.fromJson` return generated immutable implementations.
- Freezed provides immutable models, equality, and `copyWith`.
- JSON serialization keeps API parsing out of widgets.
- `final class` prevents unintended subclassing for concrete infrastructure components.

Do not edit generated `.g.dart` or `.freezed.dart` files. Edit the annotated source and run the generator.

## Page rules

Pages should be responsible for layout, accessibility, navigation intent, form validation, and feedback presentation.

Pages should not:

- Call a datasource directly.
- Construct a repository.
- Perform API requests.
- Contain cache logic.
- Convert raw exceptions into technical messages.
- Use arbitrary widget-instance navigation when a GoRouter route exists.

Use mounted checks after awaiting before using `BuildContext` or calling `setState`.

## Testing expectations

Add tests with every production feature:

- Repository tests use fake datasources.
- Controller tests override generated providers with fake repositories.
- Form tests cover required fields and submission.
- Widget tests cover loading, error, empty, populated, search, filters, and mutation feedback.
- Integration tests cover important GoRouter flows.

The current verification script is `bash tool/verify.sh`. It runs dependency resolution, code generation, formatting, analysis, and tests.

## Firebase and environments

Run `flutterfire configure` for each supported environment/platform. Keep `google-services.json` and `GoogleService-Info.plist` out of Git as configured in `.gitignore`. Provision them through local setup or CI.

`firebase_options.dart` contains generated client configuration identifiers and must match the Firebase project. Crashlytics initialization is fail-safe before configuration, but release builds must be tested with Crashlytics enabled.

The selected Firebase SDK requires iOS 15. Keep the Podfile and Xcode deployment target aligned.

## Dependency and code-generation policy

Every dependency needs a clear responsibility. Prefer Dart and Flutter standard APIs when they are sufficient. Before adding a package, check whether it supports all target platforms and whether the existing core abstractions already solve the problem.

Run:

```bash
dart run build_runner build
dart format lib
flutter analyze
```

Commit `pubspec.yaml` and `pubspec.lock` changes together. Review generated platform changes after adding plugins.
