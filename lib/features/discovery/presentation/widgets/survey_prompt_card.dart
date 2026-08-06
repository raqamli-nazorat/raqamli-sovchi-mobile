import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

final class SurveyPromptCard extends StatelessWidget {
  const SurveyPromptCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Assets.icons.icGlyph.svg(
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    AppColors.placeholder,
                    BlendMode.srcIn,
                  ),
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.surveyPromptTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      height: 19 / 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.surveyPromptMessage,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                height: 19 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surfaceLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: AppSpacing.lg,
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                child: Text(l10n.surveyPromptButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
