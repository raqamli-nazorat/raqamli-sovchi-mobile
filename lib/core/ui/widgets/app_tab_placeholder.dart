import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';

final class AppTabPlaceholder extends StatelessWidget {
  const AppTabPlaceholder({
    required this.title,
    required this.message,
    this.footer,
    super.key,
  });

  final String title;
  final String message;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.pageTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(color: AppColors.mutedText),
              ),
              if (footer != null) ...[
                const SizedBox(height: AppSpacing.xl),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
