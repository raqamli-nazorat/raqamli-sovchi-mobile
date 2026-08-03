import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      colorScheme: scheme,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? AppColors.surfaceLight
          : AppColors.surfaceDark,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: AppTypography.pageTitle,
        bodyLarge: AppTypography.body,
      ),
    );
  }
}
