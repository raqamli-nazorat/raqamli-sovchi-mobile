import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class AuthKeypad extends StatelessWidget {
  const AuthKeypad({
    required this.onDigit,
    required this.onBackspace,
    this.showFingerprint = false,
    this.onFingerprint,
    super.key,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool showFingerprint;
  final VoidCallback? onFingerprint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in [
          const ['1', '2', '3'],
          const ['4', '5', '6'],
          const ['7', '8', '9'],
        ]) ...[
          Row(
            children: [
              for (final key in row) ...[
                Expanded(
                  child: _Key(label: key, onTap: () => onDigit(key)),
                ),
                if (key != row.last) const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Row(
          children: [
            Expanded(
              child: showFingerprint
                  ? _Key(
                      icon: Assets.icons.icHugeiconsFingerprintScan.svg(
                        width: 24,
                        height: 24,
                      ),
                      onTap: onFingerprint ?? () {},
                    )
                  : const SizedBox(height: 56),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Key(label: '0', onTap: () => onDigit('0')),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Key(
                icon: const Icon(
                  Icons.backspace_outlined,
                  color: AppColors.text,
                  size: 24,
                ),
                onTap: onBackspace,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final class _Key extends StatelessWidget {
  const _Key({this.label, this.icon, required this.onTap});

  final String? label;
  final Widget? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Material(
        color: AppColors.mutedSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Center(
            child:
                icon ??
                Text(
                  label!,
                  style: AppTypography.body.copyWith(
                    fontSize: 22,
                    height: 28 / 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
