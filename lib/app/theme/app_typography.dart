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
  static const onboardingBody = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 13,
    height: 21 / 13,
    color: AppColors.mutedText,
  );
  static const onboardingCardTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.text,
  );
  static const onboardingCardBody = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    height: 19 / 12,
    color: AppColors.mutedText,
  );
  static const onboardingAction = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
  );
  static const onboardingPledgeBody = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 13,
    height: 21 / 13,
    color: AppColors.bodyText,
  );
  static const onboardingWheel = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 17,
    height: 28 / 17,
    fontWeight: FontWeight.w500,
  );
  static const onboardingChip = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    height: 21 / 14,
    color: AppColors.bodyText,
  );
  static const onboardingName = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    height: 24 / 18,
    color: AppColors.text,
  );
  static const onboardingProgress = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static const onboardingNumeric = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 34,
    height: 40 / 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.primary,
  );
  static const onboardingSelectorLabel = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 11,
    height: 17 / 11,
    color: AppColors.placeholder,
  );
  static const onboardingSelectorValue = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );
}
