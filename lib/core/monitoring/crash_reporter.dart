import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Initializes Crashlytics when the app has been configured with FlutterFire.
/// Local development can run before `flutterfire configure`.
final class CrashReporter {
  CrashReporter._(this._crashlytics);
  final FirebaseCrashlytics? _crashlytics;

  static Future<CrashReporter> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final crashlytics = FirebaseCrashlytics.instance;
      FlutterError.onError = crashlytics.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        crashlytics.recordError(error, stack, fatal: true);
        return true;
      };
      return CrashReporter._(crashlytics);
    } catch (error, stackTrace) {
      developer.log(
        'Crashlytics is not configured; continuing without remote crash reporting.',
        name: 'WattFlow.monitoring',
        error: error,
        stackTrace: stackTrace,
      );
      return CrashReporter._(null);
    }
  }

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  }) async {
    await _crashlytics?.recordError(error, stackTrace, fatal: fatal);
  }
}
