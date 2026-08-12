import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/profile_onboarding_state.dart';

final class OnboardingReferenceBottomSheet extends StatefulWidget {
  const OnboardingReferenceBottomSheet({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onRetry,
    required this.onConfirm,
    required this.confirmEnabled,
    required this.child,
    this.searchPlaceholder,
    this.onSearch,
    super.key,
  });

  final String title;
  final String subtitle;
  final ReferenceStatus status;
  final VoidCallback onRetry;
  final VoidCallback onConfirm;
  final bool confirmEnabled;
  final Widget child;
  final String? searchPlaceholder;
  final ValueChanged<String>? onSearch;

  @override
  State<OnboardingReferenceBottomSheet> createState() =>
      _OnboardingReferenceBottomSheetState();
}

final class _OnboardingReferenceBottomSheetState
    extends State<OnboardingReferenceBottomSheet> {
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) widget.onSearch?.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchPlaceholder = widget.searchPlaceholder;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .84,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm + AppSpacing.xs,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(widget.title, style: AppTypography.onboardingSheetTitle),
          const SizedBox(height: AppSpacing.xs),
          Text(widget.subtitle, style: AppTypography.onboardingSheetCaption),
          if (searchPlaceholder != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextField(
              onChanged: _onSearchChanged,
              style: AppTypography.onboardingSearch,
              decoration: InputDecoration(
                hintText: searchPlaceholder,
                hintStyle: AppTypography.onboardingSearch,
                filled: true,
                fillColor: AppColors.mutedSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md + AppSpacing.xs,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Flexible(
            child: switch (widget.status) {
              ReferenceStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              ReferenceStatus.failure => Center(
                child: AppButton(
                  label: AppLocalizations.of(context).retry,
                  onPressed: widget.onRetry,
                ),
              ),
              ReferenceStatus.empty => const SizedBox.shrink(),
              _ => widget.child,
            },
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: widget.confirmEnabled ? widget.onConfirm : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.border,
              foregroundColor: Colors.white,
              disabledForegroundColor: AppColors.mutedText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              textStyle: AppTypography.onboardingAction,
            ),
            child: Text(AppLocalizations.of(context).selectLabel),
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
    return Material(
      color: selected ? AppColors.mutedSurface : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md + AppSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: selected
                      ? AppTypography.onboardingReferenceSelected
                      : AppTypography.onboardingReferenceOption,
                ),
              ),
              _ReferenceRadio(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ReferenceRadio extends StatelessWidget {
  const _ReferenceRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primary : const Color(0xFFA3A3A3),
          width: 1.5,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
