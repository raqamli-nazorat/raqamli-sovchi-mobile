import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class OnboardingLocationSelectorRow extends StatelessWidget {
  const OnboardingLocationSelectorRow({
    required this.label,
    required this.value,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String? value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.onboardingSelectorLabel),
                    if (value?.isNotEmpty == true) ...[
                      const SizedBox(height: AppSpacing.xs - 1),
                      Text(
                        value!,
                        style: AppTypography.onboardingSelectorValue.copyWith(
                          color: enabled ? AppColors.text : AppColors.mutedText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: enabled ? AppColors.mutedText : AppColors.border,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
