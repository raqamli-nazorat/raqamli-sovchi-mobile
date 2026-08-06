import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_candidate_card.dart';
import '../../../../core/ui/widgets/app_candidate_grid.dart';
import '../../../../core/ui/widgets/app_filter_pill.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../core/ui/widgets/app_screen_header.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/survey_prompt_card.dart';

final class CandidatesPage extends StatelessWidget {
  const CandidatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final candidates = _mockCandidates(l10n);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, AppSpacing.lg),
            sliver: SliverList.list(
              children: [
                AppScreenHeader(
                  title: l10n.candidatesTabLabel,
                  trailing: AppRoundIconButton(
                    icon: Assets.icons.icNotification,
                    semanticLabel: l10n.notificationsActionLabel,
                    showUnreadDot: true,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppFilterPill(
                        label: l10n.candidatesFilterMatches,
                        selected: true,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AppFilterPill(label: l10n.candidatesFilterRecommended),
                      const SizedBox(width: AppSpacing.sm),
                      AppFilterPill(label: l10n.candidatesFilterNearby),
                      const SizedBox(width: AppSpacing.sm),
                      AppFilterPill(label: l10n.candidatesFilterRepresentative),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const SurveyPromptCard(),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, AppSpacing.xl),
            sliver: AppCandidateGrid(
              candidates: candidates,
              privatePhotoLabel: l10n.privatePhotoLabel,
            ),
          ),
        ],
      ),
    );
  }

  List<AppCandidateCardData> _mockCandidates(AppLocalizations l10n) {
    return [
      AppCandidateCardData(
        nameAge: l10n.mockCandidateMohira,
        city: l10n.mockCityTashkent,
        matchPercent: l10n.matchLockedLabel,
        image: Assets.images.image1,
      ),
      AppCandidateCardData(
        nameAge: l10n.mockCandidateZilola,
        city: l10n.mockCitySamarkand,
        matchPercent: l10n.matchLockedLabel,
        image: Assets.images.image2,
      ),
      AppCandidateCardData(
        nameAge: l10n.mockCandidateNilufar,
        city: l10n.mockCityFergana,
        matchPercent: l10n.matchLockedLabel,
        image: Assets.images.image3,
      ),
      AppCandidateCardData(
        nameAge: l10n.mockCandidateDilnoza,
        city: l10n.mockCityBukhara,
        matchPercent: l10n.matchLockedLabel,
        image: Assets.images.image4,
      ),
      AppCandidateCardData(
        nameAge: l10n.mockCandidateMohira,
        city: l10n.mockCityTashkent,
        matchPercent: l10n.matchLockedLabel,
        image: Assets.images.image1,
      ),
      AppCandidateCardData(
        nameAge: l10n.mockCandidateZilola,
        city: l10n.mockCitySamarkand,
        matchPercent: l10n.matchLockedLabel,
        image: Assets.images.image2,
      ),
    ];
  }
}
