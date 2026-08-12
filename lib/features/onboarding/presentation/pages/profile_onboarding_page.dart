import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import '../bloc/profile_onboarding_bloc.dart';
import '../bloc/profile_onboarding_event.dart';
import '../bloc/profile_onboarding_state.dart';
import '../widgets/profile_onboarding_step_content.dart';

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
  static const _steps = OnboardingStep.values;
  final PageController _pageController = PageController();
  bool _facePageLaunchRequested = false;

  void _syncCurrentStep(OnboardingStep step) {
    final page = _steps.indexOf(step);
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
        final step = state.draft?.currentStep;
        if (step != null) {
          _syncCurrentStep(step);
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
        if (state.status == ProfileOnboardingStatus.representativeFlow) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.representativeFlowMessage,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: l10n.backLabel,
                    onPressed: () => context.read<ProfileOnboardingBloc>().add(
                      const ProfileOnboardingCancelled(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

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
                    itemCount: _steps.length,
                    itemBuilder: (context, index) =>
                        ProfileOnboardingStepContent(
                          step: _steps[index],
                          state: state,
                        ),
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
