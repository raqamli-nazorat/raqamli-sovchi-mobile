import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_candidate_card.dart';
import '../../../../core/ui/widgets/app_candidate_grid.dart';
import '../../../../core/ui/widgets/app_filter_pill.dart';
import '../../../../core/ui/widgets/app_screen_header.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

final class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final candidates = _mockSavedCandidates(l10n);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, AppSpacing.lg),
            sliver: SliverList.list(
              children: [
                AppScreenHeader(title: l10n.savedTabLabel),
                const SizedBox(height: AppSpacing.lg),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppFilterPill(label: l10n.savedFilterAll, selected: true),
                      const SizedBox(width: AppSpacing.sm),
                      AppFilterPill(label: l10n.savedFilterInvited),
                      const SizedBox(width: AppSpacing.sm),
                      AppFilterPill(label: l10n.savedFilterWaiting),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.savedLimitLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _body13.copyWith(color: const Color(0xFF525252)),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        l10n.savedPremiumCta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: _body13.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, AppSpacing.lg),
            sliver: AppCandidateGrid(
              candidates: candidates,
              privatePhotoLabel: l10n.privatePhotoLabel,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.savedUpsellTitle, style: _upsellTitle),
                      const SizedBox(height: AppSpacing.xs),
                      Text(l10n.savedUpsellMessage, style: _upsellBody),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _body13 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w600,
  );

  static const _upsellTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    height: 19 / 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF92400E),
  );

  static const _upsellBody = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    height: 19 / 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF92400E),
  );

  List<AppCandidateCardData> _mockSavedCandidates(AppLocalizations l10n) {
    return [
      AppCandidateCardData(
        nameAge: l10n.mockCandidateMohira,
        city: l10n.mockCityTashkent,
        matchPercent: '82%',
        image: Assets.images.image1,
      ),
      AppCandidateCardData(
        nameAge: l10n.mockCandidateZilola,
        city: l10n.mockCitySamarkand,
        matchPercent: '74%',
        image: Assets.images.image2,
      ),
      AppCandidateCardData(
        nameAge: l10n.mockCandidateNilufar,
        city: l10n.mockCityFergana,
        matchPercent: '79%',
        image: Assets.images.image3,
      ),
      AppCandidateCardData(
        nameAge: l10n.mockCandidateDilnoza,
        city: l10n.mockCityBukhara,
        matchPercent: '55%',
        image: Assets.images.image4,
      ),
    ];
  }
}
