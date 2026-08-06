import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const pageTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 26,
    height: 31 / 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
    color: AppColors.text,
  );
  static const pinTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.text,
  );
  static const onboardingTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.text,
  );
  static const body = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 15,
    height: 20 / 15,
  );
  static const caption = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mutedText,
  );
}
