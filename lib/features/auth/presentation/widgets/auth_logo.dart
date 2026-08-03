import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

final class AuthLogo extends StatelessWidget {
  const AuthLogo({this.onPrimary = false, this.large = false, super.key});

  final bool onPrimary;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final firstColor = onPrimary ? Colors.white : AppColors.mutedText;
    final secondColor = onPrimary ? Colors.white : AppColors.text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/auth/logo.png',
          width: large ? 38 : 32,
          height: large ? 38 : 32,
        ),
        SizedBox(width: large ? 5 : 4),
        RichText(
          text: TextSpan(
            style: AppTypography.body.copyWith(
              fontSize: large ? 28 : 24,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
            children: [
              TextSpan(
                text: 'Raqamli ',
                style: TextStyle(
                  color: firstColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Sovchi',
                style: TextStyle(color: secondColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
