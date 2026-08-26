import 'package:flutter/material.dart';

import 'app_radii.dart';
import 'app_sizes.dart';
import 'app_typography.dart';
import 'wattflow_colors.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFF146B5B);
  static ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    final brandColors = brightness == Brightness.light
        ? WattFlowColors.light
        : WattFlowColors.dark;
    return ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      useMaterial3: true,
      textTheme: AppTypography.textTheme(brightness),
      scaffoldBackgroundColor: scheme.surface,
      extensions: [brandColors],
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: AppRadii.card),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.card),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(
            AppSizes.minInteractiveDimension,
            AppSizes.minInteractiveDimension,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.button),
        ),
      ),
    );
  }

  static final light = _theme(Brightness.light);
  static final dark = _theme(Brightness.dark);
}
