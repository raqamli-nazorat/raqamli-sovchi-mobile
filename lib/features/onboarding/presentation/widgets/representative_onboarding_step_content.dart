import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate_type.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import '../bloc/profile_onboarding_bloc.dart';
import '../bloc/profile_onboarding_event.dart';
import '../bloc/profile_onboarding_state.dart';
import 'profile_onboarding_step_content.dart';

final class RepresentativeOnboardingStepContent extends StatefulWidget {
  const RepresentativeOnboardingStepContent({
    required this.step,
    required this.state,
    super.key,
  });

  final OnboardingStep step;
  final ProfileOnboardingState state;

  @override
  State<RepresentativeOnboardingStepContent> createState() =>
      _RepresentativeOnboardingStepContentState();
}

final class _RepresentativeOnboardingStepContentState
    extends State<RepresentativeOnboardingStepContent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = widget.state.draft!;
    final bloc = context.read<ProfileOnboardingBloc>();
    return switch (widget.step) {
      OnboardingStep.representativeIntro => _intro(l10n, bloc),
      OnboardingStep.representativeIdentity => _identity(l10n, draft, bloc),
      OnboardingStep.representativeRelation => _relation(l10n, draft, bloc),
      OnboardingStep.representativeCandidateType => _candidateType(
        l10n,
        draft,
        bloc,
      ),
      OnboardingStep.representativeContact => _contact(l10n, draft, bloc),
      OnboardingStep.representativeConsentSent => _consentSent(
        l10n,
        draft,
        bloc,
      ),
      OnboardingStep.representativePledge => _pledge(l10n, draft, bloc),
      OnboardingStep.representativeReady => _ready(l10n, bloc),
      _ => ProfileOnboardingStepContent(
        step: widget.step,
        state: widget.state,
        representativeMode: widget.step != OnboardingStep.candidateType,
      ),
    };
  }

  Widget _intro(AppLocalizations l10n, ProfileOnboardingBloc bloc) {
    return _RepresentativeLayout(
      title: l10n.representativeIntroTitle,
      subtitle: l10n.representativeIntroSubtitle,
      bottom: _PrimaryAction(
        label: l10n.startLabel,
        onPressed: () => bloc.add(const RepresentativeIntroContinuePressed()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoPanel(
            title: l10n.representativeConsentRequiredTitle,
            body: l10n.representativeConsentRequiredBody,
            tone: _InfoTone.warning,
          ),
          const SizedBox(height: AppSpacing.card),
          Text(
            l10n.representativeIntroFootnote,
            style: AppTypography.onboardingCardBody,
          ),
        ],
      ),
    );
  }

  Widget _identity(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    if (_firstNameController.text.isEmpty &&
        draft.representativeFirstName != null) {
      _firstNameController.text = draft.representativeFirstName!;
    }
    if (_lastNameController.text.isEmpty &&
        draft.representativeLastName != null) {
      _lastNameController.text = draft.representativeLastName!;
    }
    final enabled =
        _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty;
    return _RepresentativeLayout(
      progress: .06,
      eyebrow: l10n.representativeSelfSection,
      title: l10n.representativeSelfTitle,
      keyboardAware: true,
      bottom: _PrimaryAction(
        label: l10n.continueLabel,
        onPressed: enabled && !widget.state.isBusy
            ? () {
                FocusScope.of(context).unfocus();
                bloc.add(
                  RepresentativeIdentitySaved(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                  ),
                );
              }
            : null,
      ),
      child: Column(
        children: [
          _RepresentativeTextField(
            label: l10n.firstNameLabel,
            controller: _firstNameController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          _RepresentativeTextField(
            label: l10n.lastNameLabel,
            controller: _lastNameController,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.representativeSelfSubtitle,
              style: AppTypography.onboardingCardBody,
            ),
          ),
        ],
      ),
    );
  }

  Widget _relation(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final kinships = [...widget.state.kinships]
      ..sort(
        (left, right) =>
            _kinshipRank(left.name).compareTo(_kinshipRank(right.name)),
      );
    return _RepresentativeLayout(
      progress: .12,
      eyebrow: l10n.representativeSelfSection,
      title: l10n.representativeRelationTitle,
      bottom: _PrimaryAction(
        label: l10n.continueLabel,
        onPressed: draft.kinshipId?.isNotEmpty == true && !widget.state.isBusy
            ? () => bloc.add(const RepresentativeRelationContinuePressed())
            : null,
      ),
      child: switch (widget.state.kinshipStatus) {
        ReferenceStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
        ReferenceStatus.failure => AppButton(
          label: l10n.retry,
          onPressed: () => bloc.add(const KinshipsRequested()),
        ),
        ReferenceStatus.empty => const SizedBox.shrink(),
        _ => Column(
          children: [
            for (final kinship in kinships) ...[
              _RepresentativeSelectionCard(
                label: kinship.name,
                selected: draft.kinshipId == kinship.id,
                onPressed: () =>
                    bloc.add(RepresentativeRelationSaved(kinship.id)),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      },
    );
  }

  int _kinshipRank(String name) {
    final normalized = name.toLowerCase().replaceAll('‘', "'");
    if (normalized.contains('ota')) return 0;
    if (normalized.contains('xola')) return 1;
    if (normalized.contains('amma')) return 2;
    if (normalized.contains('amaki')) return 3;
    if (normalized.contains('tog') || normalized.contains("tog'")) return 4;
    return 5;
  }

  Widget _candidateType(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    return _RepresentativeLayout(
      progress: .18,
      eyebrow: l10n.representativeCandidateSection,
      title: l10n.representativeCandidateTypeTitle,
      subtitle: l10n.representativeCandidateTypeSubtitle,
      bottom: _PrimaryAction(
        label: l10n.continueLabel,
        onPressed: draft.representedCandidateType == null
            ? null
            : () => bloc.add(const RepresentedCandidateTypeContinuePressed()),
      ),
      child: Column(
        children: [
          _RepresentativeSelectionCard(
            label: l10n.representativeBrideTitle,
            detail: l10n.representativeBrideSubtitle,
            selected: draft.representedCandidateType == CandidateType.bride,
            onPressed: () => bloc.add(
              const RepresentedCandidateTypeSaved(CandidateType.bride),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _RepresentativeSelectionCard(
            label: l10n.representativeGroomTitle,
            detail: l10n.representativeGroomSubtitle,
            selected: draft.representedCandidateType == CandidateType.groom,
            onPressed: () => bloc.add(
              const RepresentedCandidateTypeSaved(CandidateType.groom),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contact(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    if (_contactController.text.isEmpty && draft.candidateContact != null) {
      _contactController.text = draft.candidateContact!;
    }
    return _RepresentativeLayout(
      progress: .94,
      eyebrow: l10n.representativeConsentSection,
      title: l10n.representativeContactTitle,
      subtitle: l10n.representativeContactSubtitle,
      keyboardAware: true,
      bottom: Column(
        children: [
          _PrimaryAction(
            label: l10n.representativeSendConsent,
            onPressed:
                _contactController.text.trim().isEmpty || widget.state.isBusy
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    bloc.add(
                      RepresentativeContactSubmitted(_contactController.text),
                    );
                  },
          ),
          const SizedBox(height: AppSpacing.md),
          _SecondaryAction(
            label: l10n.representativeCandidateNoApp,
            onPressed: widget.state.isBusy
                ? null
                : () => bloc.add(const RepresentativeCandidateDoesNotUseApp()),
          ),
        ],
      ),
      child: Column(
        children: [
          _RepresentativeTextField(
            label: l10n.representativeContactLabel,
            controller: _contactController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.none,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.card),
          _InfoPanel(
            title: l10n.representativeContactWarningTitle,
            body: l10n.representativeContactWarningBody,
            tone: _InfoTone.warning,
          ),
        ],
      ),
    );
  }

  Widget _consentSent(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final candidateName = draft.firstName?.trim() ?? '';
    final representativeName = [
      draft.representativeFirstName,
      draft.representativeLastName,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' ');
    return _RepresentativeLayout(
      eyebrow: l10n.representativeConsentSection,
      title: l10n.representativeConsentSentTitle,
      subtitle: l10n.representativeConsentSentSubtitle(candidateName),
      bottom: Column(
        children: [
          _PrimaryAction(
            label: l10n.understoodLabel,
            onPressed: () =>
                bloc.add(const RepresentativeConsentAcknowledged()),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed:
                widget.state.isBusy ||
                    draft.candidateContact?.isNotEmpty != true
                ? null
                : () => bloc.add(
                    RepresentativeContactSubmitted(draft.candidateContact!),
                  ),
            child: Text(l10n.resendRequestLabel),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: AppColors.subtleSurface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Assets.icons.icTelegramIcon.svg(
              width: 44,
              height: 44,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.card),
          _InfoPanel(
            title: l10n.representativeSmsSentTitle,
            body: l10n.representativeSmsSentBody(representativeName),
          ),
          const SizedBox(height: AppSpacing.card),
          Text(
            l10n.representativeConsentRevocation,
            style: AppTypography.onboardingCardBody,
          ),
        ],
      ),
    );
  }

  Widget _pledge(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final values = [
      draft.representativeAccuracyAccepted,
      draft.representativePrivacyAccepted,
      draft.representativeInterestAccepted,
    ];
    final labels = [
      l10n.representativePledgePointOne,
      l10n.representativePledgePointTwo,
      l10n.representativePledgePointThree,
    ];
    return _RepresentativeLayout(
      progress: 1,
      eyebrow: l10n.representativeConsentSection,
      title: l10n.representativePledgeTitle,
      subtitle: l10n.representativePledgeSubtitle,
      bottom: _PrimaryAction(
        label: l10n.confirmLabel,
        onPressed:
            draft.hasAcceptedRepresentativeResponsibility &&
                !widget.state.isBusy
            ? () => bloc.add(const RepresentativePledgeContinuePressed())
            : null,
      ),
      child: Column(
        children: [
          for (var index = 0; index < labels.length; index++) ...[
            _ResponsibilityCard(
              label: labels[index],
              accepted: values[index],
              onChanged: (accepted) => bloc.add(
                RepresentativeResponsibilityChanged(
                  index: index,
                  accepted: accepted,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }

  Widget _ready(AppLocalizations l10n, ProfileOnboardingBloc bloc) {
    return _RepresentativeReadyLayout(
      title: l10n.representativeReadyTitle,
      subtitle: l10n.representativeReadySubtitle,
      primaryLabel: l10n.representativeSetCriteria,
      secondaryLabel: l10n.laterLabel,
      onPressed: () => bloc.add(const ProfileReadyHomeRequested()),
    );
  }
}

final class RepresentativeCandidateConsentView extends StatelessWidget {
  const RepresentativeCandidateConsentView({
    required this.representativeName,
    required this.relation,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final String representativeName;
  final String relation;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: _RepresentativeLayout(
        eyebrow: l10n.candidateConsentEyebrow,
        title: l10n.candidateConsentTitle,
        subtitle: l10n.candidateConsentBody(representativeName, relation),
        bottom: Column(
          children: [
            _PrimaryAction(label: l10n.agreeLabel, onPressed: onApprove),
            const SizedBox(height: AppSpacing.md),
            TextButton(onPressed: onReject, child: Text(l10n.rejectLabel)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoPanel(
              title: l10n.candidateConsentApproveTitle,
              body: l10n.candidateConsentApproveBody,
              tone: _InfoTone.success,
            ),
            const SizedBox(height: AppSpacing.card),
            Text(
              l10n.candidateConsentRejectHint,
              style: AppTypography.onboardingCardBody,
            ),
          ],
        ),
      ),
    );
  }
}

final class _RepresentativeLayout extends StatelessWidget {
  const _RepresentativeLayout({
    required this.title,
    required this.child,
    required this.bottom,
    this.subtitle,
    this.eyebrow,
    this.progress,
    this.keyboardAware = false,
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final double? progress;
  final Widget child;
  final Widget bottom;
  final bool keyboardAware;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (progress != null) ...[
          _RepresentativeHeader(progress: progress!),
          const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
        ],
        if (eyebrow != null) ...[
          Text(
            eyebrow!,
            style: AppTypography.onboardingFieldLabel.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        Text(title, style: AppTypography.onboardingTitle),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle!, style: AppTypography.onboardingBody),
        ],
        const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
        child,
        const Spacer(),
        bottom,
      ],
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: keyboardAware
          ? LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(child: content),
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(child: content),
                ),
              ),
            ),
    );
  }
}

final class _RepresentativeHeader extends StatelessWidget {
  const _RepresentativeHeader({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          AppRoundIconButton(
            icon: Assets.icons.icArrowLeft01Round,
            semanticLabel: AppLocalizations.of(context).backLabel,
            onPressed: () => context.read<ProfileOnboardingBloc>().add(
              const OnboardingStepBackRequested(),
            ),
          ),
          const SizedBox(width: AppSpacing.lg + 2),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: SizedBox(
                height: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AppColors.mutedSurface),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: const ColoredBox(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '${(progress * 100).round()}%',
            style: AppTypography.onboardingProgress,
          ),
        ],
      ),
    );
  }
}

final class _RepresentativeTextField extends StatelessWidget {
  const _RepresentativeTextField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.words,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.onboardingFieldLabel),
          const SizedBox(height: 3),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            style: AppTypography.onboardingFieldValue,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

final class _RepresentativeSelectionCard extends StatelessWidget {
  const _RepresentativeSelectionCard({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.detail,
  });

  final String label;
  final String? detail;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.onboardingReferenceSelected),
                  if (detail != null) ...[
                    const SizedBox(height: 3),
                    Text(detail!, style: AppTypography.onboardingCardBody),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.mutedText,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _InfoTone { neutral, warning, success }

final class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.title,
    required this.body,
    this.tone = _InfoTone.neutral,
  });

  final String title;
  final String body;
  final _InfoTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, titleColor) = switch (tone) {
      _InfoTone.warning => (AppColors.warningSurface, AppColors.warningText),
      _InfoTone.success => (AppColors.successSurface, AppColors.successText),
      _InfoTone.neutral => (AppColors.subtleSurface, AppColors.text),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.onboardingChip.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(body, style: AppTypography.onboardingCardBody),
        ],
      ),
    );
  }
}

final class _ResponsibilityCard extends StatelessWidget {
  const _ResponsibilityCard({
    required this.label,
    required this.accepted,
    required this.onChanged,
  });

  final String label;
  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!accepted),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.mutedSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: accepted,
              activeColor: AppColors.primary,
              onChanged: (value) => onChanged(value ?? false),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(label, style: AppTypography.onboardingPledgeBody),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.border,
          foregroundColor: Colors.white,
          disabledForegroundColor: AppColors.mutedText,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg + AppSpacing.xs,
            vertical: AppSpacing.lg,
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(AppRadius.full),
          // ),
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: AppTypography.onboardingAction,
        ),
        child: Text(label),
      ),
    );
  }
}

final class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: AppColors.representativeSecondaryAction,
          foregroundColor: AppColors.text,
          shape: const StadiumBorder(),
          textStyle: AppTypography.onboardingAction,
        ),
        child: Text(label),
      ),
    );
  }
}

final class _RepresentativeReadyLayout extends StatelessWidget {
  const _RepresentativeReadyLayout({
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const Spacer(flex: 3),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Assets.icons.icVerifyCheck.svg(width: 28, height: 28),
          ),
          const SizedBox(height: AppSpacing.card),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingBody,
          ),
          const Spacer(flex: 5),
          _PrimaryAction(label: primaryLabel, onPressed: onPressed),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onPressed, child: Text(secondaryLabel)),
        ],
      ),
    );
  }
}
