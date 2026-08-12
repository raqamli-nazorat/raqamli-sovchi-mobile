import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raqamli_sovchi/core/security/auth_session_manager.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/commit_pending_auth_session.dart';
import 'package:raqamli_sovchi/features/onboarding/application/services/onboarding_media_service.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/profile_onboarding_draft.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/repositories/onboarding_draft_repository.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/bloc/profile_onboarding_bloc.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/bloc/profile_onboarding_state.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/profile_onboarding_step_content.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

final class _MockOnboardingRepository extends Mock
    implements OnboardingRepository {}

final class _MockOnboardingDraftRepository extends Mock
    implements OnboardingDraftRepository {}

final class _MockOnboardingMediaService extends Mock
    implements OnboardingMediaService {}

final class _MockAuthSessionManager extends Mock
    implements AuthSessionManager {}

void main() {
  testWidgets('identity step stays scrollable in a keyboard-height viewport', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 420);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final mediaService = _MockOnboardingMediaService();
    when(() => mediaService.dispose()).thenAnswer((_) async {});

    final bloc = ProfileOnboardingBloc(
      onboardingRepository: _MockOnboardingRepository(),
      draftRepository: _MockOnboardingDraftRepository(),
      mediaService: mediaService,
      commitPendingAuthSession: CommitPendingAuthSessionUseCase(
        _MockAuthSessionManager(),
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('uz'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: bloc,
          child: Scaffold(
            body: SafeArea(
              child: ProfileOnboardingStepContent(
                step: OnboardingStep.identity,
                state: ProfileOnboardingState(
                  status: ProfileOnboardingStatus.editing,
                  draft: ProfileOnboardingDraft(
                    ownerUserId: 'user-1',
                    updatedAt: DateTime.utc(2026),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });
}
