import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/monitoring/crash_reporter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CrashReporter.initialize();
  runApp(const ProviderScope(child: WattFlowApp()));
}
