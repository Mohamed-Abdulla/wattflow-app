import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class WattFlowApp extends StatelessWidget {
  const WattFlowApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'WattFlow',
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    routerConfig: appRouter,
  );
}
