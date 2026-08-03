import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    required this.label,
    required this.asset,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(asset, width: 20, height: 20),
        label: Text(
          label,
          style: AppTypography.body.copyWith(
            fontSize: 14,
            height: 19 / 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ),
    );
  }
}
