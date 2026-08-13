import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../domain/entities/candidate_type.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import '../bloc/profile_onboarding_bloc.dart';
import '../bloc/profile_onboarding_event.dart';
import '../bloc/profile_onboarding_state.dart';
import '../widgets/profile_onboarding_step_content.dart';
import '../widgets/representative_onboarding_step_content.dart';

final class ProfileOnboardingPage extends StatelessWidget {
  const ProfileOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerUserId = context.select<AuthBloc, String?>(
      (bloc) => bloc.state.session?.userId,
    );
    if (ownerUserId == null || ownerUserId.isEmpty) {
      return const SizedBox.shrink();
    }
    return BlocProvider(
      create: (_) =>
          serviceLocator<ProfileOnboardingBloc>()
            ..add(ProfileOnboardingStarted(ownerUserId)),
      child: const _ProfileOnboardingView(),
    );
  }
}

final class _ProfileOnboardingView extends StatefulWidget {
  const _ProfileOnboardingView();

  @override
  State<_ProfileOnboardingView> createState() => _ProfileOnboardingViewState();
}

final class _ProfileOnboardingViewState extends State<_ProfileOnboardingView> {
  final PageController _pageController = PageController();
  bool _facePageLaunchRequested = false;

  List<OnboardingStep> _stepsForDraft(ProfileOnboardingDraft draft) {
    return draft.candidateType == CandidateType.representative
        ? representativeOnboardingSteps
        : standardOnboardingSteps;
  }

  void _syncCurrentStep(ProfileOnboardingDraft draft) {
    final page = _stepsForDraft(draft).indexOf(draft.currentStep);
    if (page < 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) return;
      if (_pageController.page?.round() == page) return;
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<ProfileOnboardingBloc, ProfileOnboardingState>(
      listener: (context, state) {
        final draft = state.draft;
        final step = draft?.currentStep;
        if (step != null && draft != null) {
          _syncCurrentStep(draft);
          if (step == OnboardingStep.faceVerification &&
              !_facePageLaunchRequested) {
            _facePageLaunchRequested = true;
            context.read<ProfileOnboardingBloc>().add(
              const FaceVerificationPageOpened(),
            );
          } else if (step != OnboardingStep.faceVerification) {
            _facePageLaunchRequested = false;
          }
          if (step == OnboardingStep.education &&
              state.educationStatus == ReferenceStatus.idle) {
            context.read<ProfileOnboardingBloc>().add(
              const EducationLevelsRequested(),
            );
          }
          if (step == OnboardingStep.location &&
              state.regionStatus == ReferenceStatus.idle) {
            context.read<ProfileOnboardingBloc>().add(const RegionsRequested());
          }
          if (step == OnboardingStep.healthStatus &&
              state.healthStatusStatus == ReferenceStatus.idle) {
            context.read<ProfileOnboardingBloc>().add(
              const HealthStatusesRequested(),
            );
          }
          if (step == OnboardingStep.maritalStatus &&
              state.maritalStatusStatus == ReferenceStatus.idle) {
            context.read<ProfileOnboardingBloc>().add(
              const MaritalStatusesRequested(),
            );
          }
          if (step == OnboardingStep.representativeRelation &&
              state.kinshipStatus == ReferenceStatus.idle) {
            context.read<ProfileOnboardingBloc>().add(
              const KinshipsRequested(),
            );
          }
        }
        if (state.status == ProfileOnboardingStatus.completed) {
          context.read<AuthBloc>().add(const AuthOnboardingCompleted());
        }
        if (state.status == ProfileOnboardingStatus.cancelled) {
          context.read<AuthBloc>().add(const AuthFlowCancelled());
        }
      },
      builder: (context, state) {
        final draft = state.draft;
        if (state.status == ProfileOnboardingStatus.initial ||
            state.status == ProfileOnboardingStatus.loading ||
            draft == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final steps = _stepsForDraft(draft);
        final representativeMode =
            draft.candidateType == CandidateType.representative;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                if (state.failure != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: AppErrorView(
                      message: l10n.failureMessage(state.failure!.type.name),
                    ),
                  ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      final step = steps[index];
                      return representativeMode
                          ? RepresentativeOnboardingStepContent(
                              step: step,
                              state: state,
                            )
                          : ProfileOnboardingStepContent(
                              step: step,
                              state: state,
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
