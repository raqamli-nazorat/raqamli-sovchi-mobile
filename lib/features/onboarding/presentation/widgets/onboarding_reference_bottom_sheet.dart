import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/profile_onboarding_state.dart';

final class OnboardingReferenceBottomSheet extends StatelessWidget {
  const OnboardingReferenceBottomSheet({
    required this.title,
    required this.status,
    required this.onRetry,
    required this.child,
    super.key,
  });

  final String title;
  final ReferenceStatus status;
  final VoidCallback onRetry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 520),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: AppTypography.onboardingTitle),
          ),
          const SizedBox(height: AppSpacing.md),
          Flexible(
            child: switch (status) {
              ReferenceStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              ReferenceStatus.failure => Center(
                child: AppButton(
                  label: AppLocalizations.of(context).retry,
                  onPressed: onRetry,
                ),
              ),
              ReferenceStatus.empty => const SizedBox.shrink(),
              _ => child,
            },
          ),
        ],
      ),
    );
  }
}

final class OnboardingReferenceOptionTile extends StatelessWidget {
  const OnboardingReferenceOptionTile({
    required this.label,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: AppTypography.onboardingSelectorValue),
      trailing: selected
          ? const Icon(Icons.check_rounded, color: AppColors.primary)
          : null,
      onTap: onPressed,
    );
  }
}
