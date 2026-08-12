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
import 'onboarding_date_wheel_picker.dart';
import 'onboarding_face_camera.dart';
import 'onboarding_height_weight_input.dart';
import 'onboarding_location_selector_row.dart';
import 'onboarding_photo_grid.dart';
import 'onboarding_photo_selector.dart';
import 'onboarding_reference_bottom_sheet.dart';
import 'onboarding_voice_recorder.dart';

final class ProfileOnboardingStepContent extends StatefulWidget {
  const ProfileOnboardingStepContent({
    required this.step,
    required this.state,
    super.key,
  });

  final OnboardingStep step;
  final ProfileOnboardingState state;

  @override
  State<ProfileOnboardingStepContent> createState() =>
      _ProfileOnboardingStepContentState();
}

final class _ProfileOnboardingStepContentState
    extends State<ProfileOnboardingStepContent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _patronymicController = TextEditingController();
  DateTime? _selectedBirthDate;
  int? _selectedHeight;
  int? _selectedWeight;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _patronymicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<ProfileOnboardingBloc>();
    final draft = widget.state.draft!;
    final content = switch (widget.step) {
      OnboardingStep.candidateType => _candidateType(l10n, draft, bloc),
      OnboardingStep.pledge => _pledge(l10n, draft, bloc),
      OnboardingStep.birthDate => _birthDate(l10n, draft, bloc),
      OnboardingStep.identity => _identity(l10n, draft, bloc),
      OnboardingStep.education => _education(l10n, draft, bloc),
      OnboardingStep.height => _height(l10n, draft, bloc),
      OnboardingStep.location => _location(l10n, draft, bloc),
      OnboardingStep.photos => _photos(l10n, draft, bloc),
      OnboardingStep.voiceIntro => _voice(l10n, draft, bloc),
      OnboardingStep.faceVerification => _face(l10n, draft, bloc),
      OnboardingStep.success => _success(l10n, bloc),
    };
    return Padding(
      padding:
          widget.step == OnboardingStep.candidateType ||
              widget.step == OnboardingStep.pledge
          ? const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg + AppSpacing.xs,
              AppSpacing.xl,
              AppSpacing.xl,
            )
          : const EdgeInsets.all(AppSpacing.xl),
      child: content,
    );
  }

  Widget _candidateType(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    return _FigmaStepLayout(
      title: l10n.candidateTypeTitle,
      subtitle: l10n.candidateTypeSubtitle,
      bottom: _FigmaPrimaryButton(
        label: l10n.continueLabel,
        onPressed: draft.candidateType == null
            ? null
            : () => bloc.add(const CandidateTypeContinuePressed()),
      ),
      child: Column(
        children: [
          _SelectionCard(
            label: l10n.groomCandidateTitle,
            detail: l10n.groomCandidateSubtitle,
            selected: draft.candidateType == CandidateType.groom,
            onPressed: () =>
                bloc.add(const CandidateTypeSaved(CandidateType.groom)),
          ),
          const SizedBox(height: AppSpacing.md),
          _SelectionCard(
            label: l10n.brideCandidateTitle,
            detail: l10n.brideCandidateSubtitle,
            selected: draft.candidateType == CandidateType.bride,
            onPressed: () =>
                bloc.add(const CandidateTypeSaved(CandidateType.bride)),
          ),
          const SizedBox(height: AppSpacing.md),
          _SelectionCard(
            label: l10n.representativeCandidateTitle,
            detail: l10n.representativeCandidateSubtitle,
            selected: draft.candidateType == CandidateType.representative,
            onPressed: () => bloc.add(
              const CandidateTypeSaved(CandidateType.representative),
            ),
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
    return _FigmaStepLayout(
      title: l10n.pledgeTitle,
      bottom: _FigmaPrimaryButton(
        label: l10n.pledgeStart,
        onPressed: draft.pledgeAcceptedTerms
            ? () => bloc.add(const PledgeContinuePressed())
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PledgeCard(
            points: [
              l10n.pledgePointOne,
              l10n.pledgePointTwo,
              l10n.pledgePointThree,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _AgreementRow(
            accepted: draft.pledgeAcceptedTerms,
            label: l10n.pledgeAgreement,
            onChanged: (value) => bloc.add(PledgeAcceptanceChanged(value)),
          ),
        ],
      ),
    );
  }

  Widget _birthDate(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final now = DateTime.now();
    final minimumDate = DateTime(now.year - 60, 1, 1);
    final maximumDate = DateTime(now.year - 18, 12, 31);
    final selectedDate =
        _selectedBirthDate ?? draft.birthDate ?? DateTime(now.year - 25, 1, 1);
    return _StepLayout(
      step: widget.step,
      title: l10n.birthDateTitle,
      subtitle: l10n.birthDateSubtitle,
      dateWheel: true,
      bottom: _FigmaPrimaryButton(
        label: l10n.continueLabel,
        onPressed: () => bloc.add(BirthDateSaved(selectedDate)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingDateWheelPicker(
            value: selectedDate,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            onChanged: (value) => setState(() => _selectedBirthDate = value),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.birthDateHint,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingBody,
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
    if (_firstNameController.text.isEmpty && draft.firstName != null) {
      _firstNameController.text = draft.firstName!;
    }
    if (_lastNameController.text.isEmpty && draft.lastName != null) {
      _lastNameController.text = draft.lastName!;
    }
    if (_patronymicController.text.isEmpty && draft.patronymic != null) {
      _patronymicController.text = draft.patronymic!;
    }
    return _StepLayout(
      step: widget.step,
      title: l10n.identityTitle,
      subtitle: l10n.identitySubtitle,
      keyboardAware: true,
      bottom: _FigmaPrimaryButton(
        label: l10n.continueLabel,
        onPressed:
            _firstNameController.text.trim().isEmpty ||
                _lastNameController.text.trim().isEmpty ||
                _patronymicController.text.trim().isEmpty
            ? null
            : () => bloc.add(
                IdentitySaved(
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  patronymic: _patronymicController.text,
                ),
              ),
      ),
      child: Column(
        children: [
          _OnboardingTextField(
            label: l10n.firstNameLabel,
            controller: _firstNameController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          _OnboardingTextField(
            label: l10n.lastNameLabel,
            controller: _lastNameController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          _OnboardingTextField(
            label: l10n.patronymicLabel,
            controller: _patronymicController,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _education(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final chips = widget.state.educationLevels
        .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
        .map(
          (item) => _EducationChip(
            label: item.name,
            selected: draft.educationLevelId == item.id,
            onPressed: () => bloc.add(EducationLevelSaved(item.id)),
          ),
        )
        .toList(growable: false);
    return _StepLayout(
      step: widget.step,
      title: l10n.educationTitle,
      bottom: _FigmaPrimaryButton(
        label: l10n.continueLabel,
        onPressed: draft.educationLevelId?.isNotEmpty == true
            ? () => bloc.add(const EducationContinuePressed())
            : null,
      ),
      child: switch (widget.state.educationStatus) {
        ReferenceStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
        ReferenceStatus.empty => const SizedBox.shrink(),
        ReferenceStatus.failure => AppButton(
          label: l10n.retry,
          onPressed: () => bloc.add(const EducationLevelsRequested()),
        ),
        _ => Wrap(
          spacing: AppSpacing.inline,
          runSpacing: AppSpacing.inline,
          children: chips,
        ),
      },
    );
  }

  Widget _height(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final height = _selectedHeight ?? draft.heightCm ?? 179;
    final weight = _selectedWeight ?? draft.weightKg ?? 68;
    return _StepLayout(
      step: widget.step,
      title: l10n.heightWeightTitle,
      bottom: _FigmaPrimaryButton(
        label: l10n.continueLabel,
        onPressed: () => bloc.add(HeightSaved(height, weightKg: weight)),
      ),
      child: OnboardingHeightWeightInput(
        height: height,
        weight: weight,
        heightLabel: l10n.heightInputLabel,
        weightLabel: l10n.weightInputLabel,
        heightUnit: l10n.heightUnit,
        weightUnit: l10n.weightUnit,
        decreaseHeightLabel: l10n.decreaseHeightLabel,
        increaseHeightLabel: l10n.increaseHeightLabel,
        decreaseWeightLabel: l10n.decreaseWeightLabel,
        increaseWeightLabel: l10n.increaseWeightLabel,
        onHeightChanged: (value) => setState(() => _selectedHeight = value),
        onWeightChanged: (value) => setState(() => _selectedWeight = value),
      ),
    );
  }

  Widget _location(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final regionName = _selectedRegionName(draft);
    final districtName = _selectedDistrictName(draft);
    return _StepLayout(
      step: widget.step,
      title: l10n.locationTitle,
      bottom: _FigmaPrimaryButton(
        label: l10n.continueLabel,
        onPressed: draft.regionId == null || draft.districtId == null
            ? null
            : () => bloc.add(const ProfileBootstrapRequested()),
      ),
      child: Column(
        children: [
          OnboardingLocationSelectorRow(
            label: l10n.regionLabel,
            value: regionName,
            onPressed: () => _showRegionSheet(l10n, bloc),
          ),
          const SizedBox(height: AppSpacing.md),
          OnboardingLocationSelectorRow(
            label: l10n.districtLabel,
            value: districtName,
            onPressed: draft.regionId == null
                ? null
                : () => _showDistrictSheet(l10n, bloc),
          ),
        ],
      ),
    );
  }

  String? _selectedRegionName(ProfileOnboardingDraft draft) {
    final regionId = draft.regionId;
    if (regionId == null) return null;
    return widget.state.regions
        .where((item) => item.id == regionId)
        .firstOrNull
        ?.name;
  }

  String? _selectedDistrictName(ProfileOnboardingDraft draft) {
    final districtId = draft.districtId;
    if (districtId == null) return null;
    return widget.state.districts
        .where((item) => item.id == districtId)
        .firstOrNull
        ?.name;
  }

  Future<void> _showRegionSheet(
    AppLocalizations l10n,
    ProfileOnboardingBloc bloc,
  ) {
    if (bloc.state.regionStatus == ReferenceStatus.idle) {
      bloc.add(const RegionsRequested());
    }
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<ProfileOnboardingBloc, ProfileOnboardingState>(
          builder: (context, state) {
            return OnboardingReferenceBottomSheet(
              title: l10n.regionLabel,
              status: state.regionStatus,
              onRetry: () => bloc.add(const RegionsRequested()),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: state.regions.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: AppColors.border),
                itemBuilder: (context, index) {
                  final item = state.regions[index];
                  return OnboardingReferenceOptionTile(
                    label: item.name,
                    selected: state.draft?.regionId == item.id,
                    onPressed: () {
                      bloc.add(RegionSaved(item.id));
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDistrictSheet(
    AppLocalizations l10n,
    ProfileOnboardingBloc bloc,
  ) {
    if (bloc.state.draft?.regionId != null &&
        bloc.state.districtStatus == ReferenceStatus.idle) {
      bloc.add(const DistrictsRequested());
    }
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<ProfileOnboardingBloc, ProfileOnboardingState>(
          builder: (context, state) {
            return OnboardingReferenceBottomSheet(
              title: l10n.districtLabel,
              status: state.districtStatus,
              onRetry: () => bloc.add(const DistrictsRequested()),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: state.districts.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: AppColors.border),
                itemBuilder: (context, index) {
                  final item = state.districts[index];
                  return OnboardingReferenceOptionTile(
                    label: item.name,
                    selected: state.draft?.districtId == item.id,
                    onPressed: () {
                      bloc.add(DistrictSaved(item.id));
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _photos(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    return _StepLayout(
      title: l10n.photoTitle,
      step: widget.step,
      bottom: _FigmaPrimaryButton(
        label: l10n.continueLabel,
        onPressed: draft.photos.isEmpty || widget.state.isBusy
            ? null
            : () => bloc.add(const VoiceIntroStepRequested()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingPhotoGrid(
            photos: draft.photos,
            addLabel: l10n.photoSlotAddLabel,
            removeLabel: l10n.removePhoto,
            retryLabel: l10n.retry,
            filledLabelBuilder: l10n.photoSlotFilledLabel,
            onAdd: draft.photos.length >= 4 || widget.state.isBusy
                ? null
                : () => bloc.add(const ProfilePhotoPickRequested()),
            onRemove: (localFilePath) =>
                bloc.add(ProfilePhotoRemoveRequested(localFilePath)),
            onRetry: (localFilePath) =>
                bloc.add(ProfilePhotoUploadRetryRequested(localFilePath)),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.photoPrivacyHint,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingBody,
          ),
        ],
      ),
    );
  }

  Widget _voice(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    return _StepLayout(
      title: l10n.voiceTitle,
      step: widget.step,
      bottom: Column(
        children: [
          _FigmaPrimaryButton(
            label: l10n.continueLabel,
            onPressed:
                widget.state.isVoiceRecording ||
                    draft.voiceIntroMetadata?.uploaded != true ||
                    widget.state.isBusy
                ? null
                : () => bloc.add(const VoiceIntroContinuePressed()),
          ),
          const SizedBox(height: AppSpacing.md),
          _FigmaGhostButton(
            label: l10n.skipLabel,
            onPressed: widget.state.isVoiceRecording || widget.state.isBusy
                ? null
                : () => bloc.add(const VoiceIntroContinuePressed()),
          ),
        ],
      ),
      child: OnboardingVoiceRecorder(
        isRecording: widget.state.isVoiceRecording,
        hasRecording: draft.voiceIntroMetadata != null,
        recordLabel: widget.state.isVoiceRecording
            ? l10n.stopRecording
            : l10n.startRecording,
        playLabel: l10n.playRecording,
        hint: l10n.voiceShortHint,
        onRecordPressed: () => bloc.add(
          widget.state.isVoiceRecording
              ? const VoiceRecordingStopped()
              : const VoiceRecordingStarted(),
        ),
        onPlayPressed: draft.voiceIntroMetadata == null
            ? null
            : () => bloc.add(const VoicePlaybackRequested()),
      ),
    );
  }

  Widget _face(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final verifying =
        draft.faceVerificationStatus == FaceVerificationStatus.verifying;
    return _StepLayout(
      title: l10n.faceCaptureTitle,
      subtitle: l10n.faceCaptureSubtitle,
      bottom: _FigmaPrimaryButton(
        label: l10n.verifyFace,
        onPressed: verifying
            ? null
            : () => bloc.add(const FaceVerificationRequested()),
      ),
      child: Column(
        children: [
          OnboardingFaceCamera(
            key: ValueKey(
              draft.faceVerificationStatus ==
                      FaceVerificationStatus.retryableFailure
                  ? 'face-camera-retry'
                  : 'face-camera-live',
            ),
            hint: l10n.faceHint,
            errorLabel: l10n.faceCameraError,
            retryLabel: l10n.retry,
            onCaptured: (path) => bloc.add(FaceSelfieCaptured(path)),
          ),
          const SizedBox(height: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final rule in [
                l10n.faceRuleOne,
                l10n.faceRuleTwo,
                l10n.faceRuleThree,
              ]) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle, color: AppColors.primary, size: 6),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        rule,
                        style: AppTypography.onboardingCardBody,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.mainPhotoSelectionHint,
              style: AppTypography.onboardingCardBody,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          OnboardingPhotoSelector(
            photos: draft.photos,
            onSelected: (serverId) =>
                bloc.add(ProfilePhotoMainSelected(serverId)),
          ),
          const SizedBox(height: AppSpacing.md),
          if (verifying) const CircularProgressIndicator(),
          if (draft.faceVerificationStatus ==
              FaceVerificationStatus.retryableFailure)
            Text(l10n.faceRetryHint, style: AppTypography.onboardingBody),
        ],
      ),
    );
  }

  Widget _success(AppLocalizations l10n, ProfileOnboardingBloc bloc) {
    return _SuccessStep(
      title: l10n.onboardingSuccessTitle,
      subtitle: l10n.onboardingSuccessSubtitle,
      aiTitle: l10n.aiTestTitle,
      aiDescription: l10n.aiTestDescription,
      aiPointOne: l10n.aiTestPointOne,
      aiPointTwo: l10n.aiTestPointTwo,
      aiPointThree: l10n.aiTestPointThree,
      startLabel: l10n.startAiTest,
      laterLabel: l10n.viewCandidatesLater,
      onStart: () => bloc.add(const ProfileOnboardingFinalizationRequested()),
      onLater: () => bloc.add(const ProfileOnboardingFinalizationRequested()),
    );
  }
}

final class _FigmaGhostButton extends StatelessWidget {
  const _FigmaGhostButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.mutedText,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg + AppSpacing.xs,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          textStyle: AppTypography.onboardingAction,
        ),
        child: Text(label),
      ),
    );
  }
}

final class _StepLayout extends StatelessWidget {
  const _StepLayout({
    required this.title,
    required this.child,
    this.subtitle,
    this.step,
    this.bottom,
    this.dateWheel = false,
    this.keyboardAware = false,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final OnboardingStep? step;
  final Widget? bottom;
  final bool dateWheel;
  final bool keyboardAware;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (step != null) ...[
          _OnboardingWizardHeader(
            step: step!,
            onBack: () => context.read<ProfileOnboardingBloc>().add(
              const OnboardingStepBackRequested(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
        ],
        Text(title, style: AppTypography.onboardingTitle),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle!, style: AppTypography.onboardingBody),
        ],
        const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
        if (dateWheel) ...[
          Expanded(
            child: Align(alignment: Alignment.bottomCenter, child: child),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ] else ...[
          child,
          if (bottom != null) const Spacer(),
        ],
        ..._optionalWidget(bottom),
      ],
    );
    if (bottom == null) {
      return SingleChildScrollView(child: content);
    }
    if (!keyboardAware) {
      return content;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: content),
          ),
        );
      },
    );
  }
}

final class _OnboardingTextField extends StatelessWidget {
  const _OnboardingTextField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

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
          const SizedBox(height: AppSpacing.xs - 1),
          TextField(
            controller: controller,
            onChanged: onChanged,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
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

List<Widget> _optionalWidget(Widget? widget) {
  return widget == null ? const <Widget>[] : <Widget>[widget];
}

final class _OnboardingWizardHeader extends StatelessWidget {
  const _OnboardingWizardHeader({required this.step, required this.onBack});

  final OnboardingStep step;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final progress = switch (step) {
      OnboardingStep.identity => .08,
      OnboardingStep.birthDate => .15,
      OnboardingStep.education => .23,
      OnboardingStep.height => .31,
      OnboardingStep.location => .46,
      OnboardingStep.photos => .62,
      OnboardingStep.voiceIntro => .77,
      OnboardingStep.faceVerification => 1.0,
      _ => 0.0,
    };
    final percent = (progress * 100).round();
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          AppRoundIconButton(
            icon: Assets.icons.icArrowLeft01Round,
            semanticLabel: AppLocalizations.of(context).backLabel,
            onPressed: onBack,
          ),
          const SizedBox(width: AppSpacing.md + AppSpacing.xs),
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
          Text('$percent%', style: AppTypography.onboardingProgress),
        ],
      ),
    );
  }
}

final class _FigmaStepLayout extends StatelessWidget {
  const _FigmaStepLayout({
    required this.title,
    required this.child,
    required this.bottom,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.onboardingTitle),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
          Text(subtitle!, style: AppTypography.onboardingBody),
        ],
        const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
        child,
        const Spacer(),
        bottom,
      ],
    );
  }
}

final class _FigmaPrimaryButton extends StatelessWidget {
  const _FigmaPrimaryButton({required this.label, required this.onPressed});

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          textStyle: AppTypography.onboardingAction,
        ),
        child: Text(label),
      ),
    );
  }
}

final class _SuccessStep extends StatelessWidget {
  const _SuccessStep({
    required this.title,
    required this.subtitle,
    required this.aiTitle,
    required this.aiDescription,
    required this.aiPointOne,
    required this.aiPointTwo,
    required this.aiPointThree,
    required this.startLabel,
    required this.laterLabel,
    required this.onStart,
    required this.onLater,
  });

  final String title;
  final String subtitle;
  final String aiTitle;
  final String aiDescription;
  final String aiPointOne;
  final String aiPointTwo;
  final String aiPointThree;
  final String startLabel;
  final String laterLabel;
  final VoidCallback onStart;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(title, style: AppTypography.onboardingTitle),
        const SizedBox(height: AppSpacing.sm),
        Text(subtitle, style: AppTypography.onboardingBody),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: AppColors.subtleSurface,
            border: Border.all(color: AppColors.primary, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  child: Text(
                    l10nAiBadge(context),
                    style: AppTypography.onboardingCardBody.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(aiTitle, style: AppTypography.onboardingCardTitle),
              const SizedBox(height: AppSpacing.sm),
              Text(aiDescription, style: AppTypography.onboardingCardBody),
              const SizedBox(height: AppSpacing.md),
              for (final point in [aiPointOne, aiPointTwo, aiPointThree]) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        point,
                        style: AppTypography.onboardingCardBody,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        ),
        const Spacer(),
        _FigmaPrimaryButton(label: startLabel, onPressed: onStart),
        const SizedBox(height: AppSpacing.md),
        _FigmaGhostButton(label: laterLabel, onPressed: onLater),
      ],
    );
  }

  String l10nAiBadge(BuildContext context) {
    return AppLocalizations.of(context).aiTestBadge;
  }
}

final class _EducationChip extends StatelessWidget {
  const _EducationChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.subtleSurface : Colors.white,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            label,
            style: AppTypography.onboardingChip.copyWith(
              color: selected ? AppColors.primary : AppColors.bodyText,
            ),
          ),
        ),
      ),
    );
  }
}

final class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.label,
    required this.detail,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.card),
          decoration: BoxDecoration(
            color: selected ? AppColors.subtleSurface : Colors.white,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.onboardingCardTitle),
              const SizedBox(height: AppSpacing.xs),
              Text(detail, style: AppTypography.onboardingCardBody),
            ],
          ),
        ),
      ),
    );
  }
}

final class _PledgeCard extends StatelessWidget {
  const _PledgeCard({required this.points});

  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          for (var index = 0; index < points.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SizedBox.square(
                    dimension: AppSpacing.lg,
                    child: Center(
                      child: Container(
                        width: AppSpacing.sm,
                        height: AppSpacing.sm,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.inline),
                Expanded(
                  child: Text(
                    points[index],
                    style: AppTypography.onboardingPledgeBody,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

final class _AgreementRow extends StatelessWidget {
  const _AgreementRow({
    required this.accepted,
    required this.label,
    required this.onChanged,
  });

  final bool accepted;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!accepted),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accepted ? AppColors.primary : Colors.white,
              border: Border.all(
                color: accepted ? AppColors.primary : AppColors.border,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm - 2),
            ),
            child: accepted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(label, style: AppTypography.onboardingPledgeBody),
          ),
        ],
      ),
    );
  }
}
