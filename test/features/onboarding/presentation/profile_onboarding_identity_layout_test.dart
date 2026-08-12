import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raqamli_sovchi/core/security/auth_session_manager.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/commit_pending_auth_session.dart';
import 'package:raqamli_sovchi/features/onboarding/application/services/onboarding_location_service.dart';
import 'package:raqamli_sovchi/features/onboarding/application/services/onboarding_media_service.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/candidate_type.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/onboarding_reference.dart';
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

final class _MockOnboardingLocationService extends Mock
    implements OnboardingLocationService {}

final class _MockAuthSessionManager extends Mock
    implements AuthSessionManager {}

void main() {
  testWidgets('identity step stays scrollable in a keyboard-height viewport', (
    tester,
  ) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.identity,
      size: const Size(390, 420),
    );

    expect(find.byType(TextField), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('identity continue closes the active text field focus', (
    tester,
  ) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.identity,
      size: const Size(390, 844),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Ali');
    await tester.enterText(fields.at(1), 'Valiyev');
    await tester.enterText(fields.at(2), 'Karimovich');
    await tester.pump();

    expect(_focusedEditableTextCount(tester), 1);

    final continueButton = find.widgetWithText(FilledButton, 'Davom etish');
    await tester.ensureVisible(continueButton);
    final button = tester.widget<FilledButton>(continueButton);
    expect(button.onPressed, isNotNull);

    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(_focusedEditableTextCount(tester), 0);
  });

  testWidgets('birth date step fits in a keyboard-height viewport', (
    tester,
  ) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.birthDate,
      size: const Size(390, 420),
    );

    expect(find.textContaining('18 yoshdan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final scenario in [
    (type: CandidateType.groom, height: '175', weight: '75'),
    (type: CandidateType.bride, height: '165', weight: '63'),
  ]) {
    testWidgets('height step defaults ${scenario.type.name} measurements', (
      tester,
    ) async {
      final bloc = _createBloc();
      addTearDown(bloc.close);

      await _pumpStep(
        tester,
        bloc: bloc,
        step: OnboardingStep.height,
        size: const Size(390, 844),
        state: ProfileOnboardingState(
          status: ProfileOnboardingStatus.editing,
          draft: ProfileOnboardingDraft(
            ownerUserId: 'user-1',
            candidateType: scenario.type,
            updatedAt: DateTime.utc(2026),
          ),
        ),
      );

      final fields = tester.widgetList<TextField>(find.byType(TextField));
      expect(fields.elementAt(0).controller?.text, scenario.height);
      expect(fields.elementAt(1).controller?.text, scenario.weight);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('location step shows unselected placeholders', (tester) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.location,
      size: const Size(390, 844),
    );

    expect(find.text('Tanlanmagan'), findsOneWidget);
    expect(find.text('Avval viloyatni tanlang'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('health options use API names and keep disability hint above', (
    tester,
  ) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.healthStatus,
      size: const Size(390, 844),
      state: ProfileOnboardingState(
        status: ProfileOnboardingStatus.editing,
        draft: ProfileOnboardingDraft(
          ownerUserId: 'user-1',
          updatedAt: DateTime.utc(2026),
        ),
        healthStatuses: const [
          HealthStatus(id: 'disability', name: 'Nogironligi bor'),
          HealthStatus(id: 'healthy', name: 'Sog‘lom'),
        ],
        healthStatusStatus: ReferenceStatus.loaded,
      ),
    );

    expect(find.text('Sog‘lom'), findsOneWidget);
    expect(find.text('Nogironligi bor'), findsOneWidget);
    expect(
      find.text('Keyingi qadamda qisqacha izohlashingiz mumkin'),
      findsOneWidget,
    );
    expect(
      tester
          .getTopLeft(
            find.text('Keyingi qadamda qisqacha izohlashingiz mumkin'),
          )
          .dy,
      lessThan(tester.getTopLeft(find.text('Nogironligi bor')).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('marital statuses place Ajrashgan second', (tester) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.maritalStatus,
      size: const Size(390, 844),
      state: ProfileOnboardingState(
        status: ProfileOnboardingStatus.editing,
        draft: ProfileOnboardingDraft(
          ownerUserId: 'user-1',
          updatedAt: DateTime.utc(2026),
          maritalStatusId: 'first',
        ),
        maritalStatuses: const [
          MaritalStatus(id: 'divorced', name: 'Ajrashgan'),
          MaritalStatus(id: 'first', name: 'Birinchi nikoh'),
        ],
        maritalStatusStatus: ReferenceStatus.loaded,
      ),
    );

    expect(
      tester.getTopLeft(find.text('Birinchi nikoh')).dy,
      lessThan(tester.getTopLeft(find.text('Ajrashgan')).dy),
    );
    expect(find.text('Farzandlaringiz soni'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'divorced marital status shows children controls without overflow',
    (tester) async {
      final bloc = _createBloc();
      addTearDown(bloc.close);

      await _pumpStep(
        tester,
        bloc: bloc,
        step: OnboardingStep.maritalStatus,
        size: const Size(390, 940),
        state: ProfileOnboardingState(
          status: ProfileOnboardingStatus.editing,
          draft: ProfileOnboardingDraft(
            ownerUserId: 'user-1',
            updatedAt: DateTime.utc(2026),
            maritalStatusId: 'divorced',
            childrenCount: 2,
          ),
          maritalStatuses: const [
            MaritalStatus(id: 'first', name: 'Birinchi nikoh'),
            MaritalStatus(id: 'divorced', name: 'Ajrashgan'),
          ],
          maritalStatusStatus: ReferenceStatus.loaded,
        ),
      );

      expect(find.text('Farzandlaringiz soni'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Farzandlar men bilan yashamaydi'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'children controls are disabled when children details are hidden',
    (tester) async {
      final bloc = _createBloc();
      addTearDown(bloc.close);

      await _pumpStep(
        tester,
        bloc: bloc,
        step: OnboardingStep.maritalStatus,
        size: const Size(390, 940),
        state: ProfileOnboardingState(
          status: ProfileOnboardingStatus.editing,
          draft: ProfileOnboardingDraft(
            ownerUserId: 'user-1',
            updatedAt: DateTime.utc(2026),
            maritalStatusId: 'divorced',
            childrenNotLivingWithMe: true,
          ),
          maritalStatuses: const [
            MaritalStatus(id: 'first', name: 'Birinchi nikoh'),
            MaritalStatus(id: 'divorced', name: 'Ajrashgan'),
          ],
          maritalStatusStatus: ReferenceStatus.loaded,
        ),
      );

      final removeButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.remove),
          matching: find.byType(IconButton),
        ),
      );
      final addButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.add),
          matching: find.byType(IconButton),
        ),
      );

      expect(find.text('0'), findsOneWidget);
      expect(removeButton.onPressed, isNull);
      expect(addButton.onPressed, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty photo step shows five add slots', (tester) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.photos,
      size: const Size(390, 844),
      state: ProfileOnboardingState(
        status: ProfileOnboardingStatus.editing,
        draft: ProfileOnboardingDraft(
          ownerUserId: 'user-1',
          updatedAt: DateTime.utc(2026),
        ),
      ),
    );

    expect(find.text('Suratlaringizni qo‘shing'), findsOneWidget);
    expect(find.text('surat'), findsNWidgets(5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('photo step keeps remaining slots as add slots', (tester) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.photos,
      size: const Size(390, 844),
      state: ProfileOnboardingState(
        status: ProfileOnboardingStatus.editing,
        draft: ProfileOnboardingDraft(
          ownerUserId: 'user-1',
          updatedAt: DateTime.utc(2026),
          photos: const [
            OnboardingPhotoDraft(
              localFilePath: '/private/photo.jpg',
              order: 1,
              isMain: true,
              uploadStatus: PhotoUploadStatus.pending,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Suratlaringizni qo‘shing'), findsOneWidget);
    expect(
      find.text(
        '5 tagacha surat. Ularni faqat siz ruxsat bergan odam ko‘radi.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Kamida 1 ta surat kerak. Yuz aniq ko‘rinishi shart.'),
      findsOneWidget,
    );
    expect(find.text('surat'), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('main photo step shows selected badge and confirm button', (
    tester,
  ) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.mainPhoto,
      size: const Size(390, 844),
      state: ProfileOnboardingState(
        status: ProfileOnboardingStatus.editing,
        draft: ProfileOnboardingDraft(
          ownerUserId: 'user-1',
          updatedAt: DateTime.utc(2026),
          mainPhotoServerId: 'photo-1',
          photos: const [
            OnboardingPhotoDraft(
              localFilePath: '/private/photo.jpg',
              serverId: 'photo-1',
              order: 1,
              isMain: true,
              uploadStatus: PhotoUploadStatus.uploaded,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Asosiy suratni tanlang'), findsOneWidget);
    expect(
      find.text(
        'Profilingizda birinchi shu surat ko‘rinadi va selfi bilan solishtiriladi.',
      ),
      findsOneWidget,
    );
    expect(find.text('ASOSIY'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Tasdiqlash'), findsOneWidget);
    expect(find.text('surat'), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('about me step renders optional textarea and skip action', (
    tester,
  ) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.aboutMe,
      size: const Size(390, 844),
      state: ProfileOnboardingState(
        status: ProfileOnboardingStatus.editing,
        draft: ProfileOnboardingDraft(
          ownerUserId: 'user-1',
          updatedAt: DateTime.utc(2026),
        ),
      ),
    );

    expect(find.text('O‘zingiz haqingizda'), findsOneWidget);
    expect(
      find.text('Ixtiyoriy. Qisqacha yozing — nomzodlar shuni o‘qiydi.'),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('0 / 300 belgi'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Davom etish'), findsOneWidget);
    expect(find.text('O‘tkazib yuborish'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'voice step shows recording controls before and after recording',
    (tester) async {
      final bloc = _createBloc();
      addTearDown(bloc.close);

      await _pumpStep(
        tester,
        bloc: bloc,
        step: OnboardingStep.voiceIntro,
        size: const Size(390, 844),
      );

      expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
      expect(find.text('Yozishni boshlash uchun bosing'), findsOneWidget);
      expect(find.text('Qayta yozish'), findsNothing);
      expect(tester.takeException(), isNull);

      await _pumpStep(
        tester,
        bloc: bloc,
        step: OnboardingStep.voiceIntro,
        size: const Size(390, 844),
        state: ProfileOnboardingState(
          status: ProfileOnboardingStatus.editing,
          draft: ProfileOnboardingDraft(
            ownerUserId: 'user-1',
            updatedAt: DateTime.utc(2026),
            voiceIntroMetadata: const VoiceIntroMetadata(
              localFilePath: '/private/voice.m4a',
              duration: Duration(seconds: 12),
              sizeBytes: 100,
              uploaded: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.text('0:12'), findsOneWidget);
      expect(find.text('Qayta yozish'), findsOneWidget);
      expect(find.text('O‘chirish'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('location permission step requires enabling location', (
    tester,
  ) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.locationPermission,
      size: const Size(390, 844),
    );

    expect(find.text('Joylashuvingiz'), findsOneWidget);
    expect(find.text('Joylashuvni yoqish'), findsOneWidget);
    expect(find.text('O‘tkazib yuborish'), findsNothing);
    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pledge confirmation step matches final confirmation copy', (
    tester,
  ) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.success,
      size: const Size(390, 844),
    );

    expect(find.text('Niyatingizni tasdiqlang'), findsOneWidget);
    expect(
      find.text('Ma’lumotlarim to‘g‘ri va o‘zimga tegishli.'),
      findsOneWidget,
    );
    expect(find.text('Qasamni tasdiqlash'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile ready step shows AI test choices', (tester) async {
    final bloc = _createBloc();
    addTearDown(bloc.close);

    await _pumpStep(
      tester,
      bloc: bloc,
      step: OnboardingStep.profileReady,
      size: const Size(390, 844),
    );

    expect(find.text('Profillingiz tayyor!'), findsOneWidget);
    expect(find.text('AI MOSLIK TESTI'), findsOneWidget);
    expect(find.text('Ha, testni boshlayman'), findsOneWidget);
    expect(find.text('Keyinroq — avval nomzodlarni ko‘raman'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

ProfileOnboardingBloc _createBloc({
  OnboardingDraftRepository? draftRepository,
}) {
  final mediaService = _MockOnboardingMediaService();
  final locationService = _MockOnboardingLocationService();
  when(() => mediaService.dispose()).thenAnswer((_) async {});

  return ProfileOnboardingBloc(
    onboardingRepository: _MockOnboardingRepository(),
    draftRepository: draftRepository ?? _MockOnboardingDraftRepository(),
    mediaService: mediaService,
    locationService: locationService,
    commitPendingAuthSession: CommitPendingAuthSessionUseCase(
      _MockAuthSessionManager(),
    ),
  );
}

Future<void> _pumpStep(
  WidgetTester tester, {
  required ProfileOnboardingBloc bloc,
  required OnboardingStep step,
  required Size size,
  ProfileOnboardingState? state,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

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
              step: step,
              state:
                  state ??
                  ProfileOnboardingState(
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
}

int _focusedEditableTextCount(WidgetTester tester) {
  return tester
      .widgetList<EditableText>(find.byType(EditableText))
      .where((widget) => widget.focusNode.hasFocus)
      .length;
}
