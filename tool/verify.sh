#!/usr/bin/env bash

# Fail on command errors, unset variables, and failed pipeline commands.
set -euo pipefail

# Resolve dependencies declared in pubspec.yaml.
flutter pub get

# Generate Freezed, JSON serialization, and Riverpod source files.
dart run build_runner build

# Format application Dart code.
dart format lib

# Run static analysis and lints.
flutter analyze

# Run unit/widget/integration tests found under test/.
flutter test
