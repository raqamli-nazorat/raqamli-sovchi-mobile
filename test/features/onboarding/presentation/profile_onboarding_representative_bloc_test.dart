import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/core/security/auth_session_manager.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/commit_pending_auth_session.dart';
import 'package:raqamli_sovchi/features/onboarding/application/services/onboarding_location_service.dart';
import 'package:raqamli_sovchi/features/onboarding/application/services/onboarding_media_service.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/candidate_type.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/profile_onboarding_draft.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/repositories/onboarding_draft_repository.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/bloc/profile_onboarding_bloc.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/bloc/profile_onboarding_event.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/bloc/profile_onboarding_state.dart';

final class _MockOnboardingRepository extends Mock
    implements OnboardingRepository {}

final class _MockDraftRepository extends Mock
    implements OnboardingDraftRepository {}

final class _MockMediaService extends Mock implements OnboardingMediaService {}

final class _MockLocationService extends Mock
    implements OnboardingLocationService {}

final class _MockAuthSessionManager extends Mock
    implements AuthSessionManager {}

void main() {
  late _MockOnboardingRepository onboardingRepository;
  late _MockDraftRepository draftRepository;
  late _MockMediaService mediaService;
  late _MockLocationService locationService;
  late _MockAuthSessionManager authSessionManager;

  setUpAll(() {
    registerFallbackValue(
      ProfileOnboardingDraft(
        ownerUserId: 'fallback',
        updatedAt: DateTime.utc(2026, 8, 13),
      ),
    );
  });

  setUp(() {
    onboardingRepository = _MockOnboardingRepository();
    draftRepository = _MockDraftRepository();
    mediaService = _MockMediaService();
    locationService = _MockLocationService();
    authSessionManager = _MockAuthSessionManager();
    when(() => mediaService.dispose()).thenAnswer((_) async {});
    when(
      () => draftRepository.save(any()),
    ).thenAnswer((_) async => const Right<Failure, void>(null));
  });

  ProfileOnboardingBloc buildBloc() {
    return ProfileOnboardingBloc(
      onboardingRepository: onboardingRepository,
      draftRepository: draftRepository,
      mediaService: mediaService,
      locationService: locationService,
      commitPendingAuthSession: CommitPendingAuthSessionUseCase(
        authSessionManager,
      ),
      now: () => DateTime.utc(2026, 8, 13),
    );
  }

  blocTest<ProfileOnboardingBloc, ProfileOnboardingState>(
    'representative selection opens the dedicated introduction',
    build: () {
      when(() => draftRepository.load('user-1')).thenAnswer(
        (_) async => const Right<Failure, ProfileOnboardingDraft?>(null),
      );
      return buildBloc();
    },
    act: (bloc) async {
      final started = bloc.stream.firstWhere((state) => state.draft != null);
      bloc.add(const ProfileOnboardingStarted('user-1'));
      await started;
      final selected = bloc.stream.firstWhere(
        (state) => state.draft?.candidateType == CandidateType.representative,
      );
      bloc.add(const CandidateTypeSaved(CandidateType.representative));
      await selected;
      bloc.add(const CandidateTypeContinuePressed());
    },
    expect: () => [
      isA<ProfileOnboardingState>().having(
        (state) => state.status,
        'status',
        ProfileOnboardingStatus.loading,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.status,
        'status',
        ProfileOnboardingStatus.editing,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.draft?.candidateType,
        'candidate type',
        CandidateType.representative,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.draft?.currentStep,
        'current step',
        OnboardingStep.representativeIntro,
      ),
    ],
  );

  blocTest<ProfileOnboardingBloc, ProfileOnboardingState>(
    'representative main photo skips face verification',
    build: () {
      final draft = ProfileOnboardingDraft(
        ownerUserId: 'user-1',
        candidateType: CandidateType.representative,
        representedCandidateType: CandidateType.bride,
        currentStep: OnboardingStep.mainPhoto,
        profileServerId: 'profile-1',
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
        updatedAt: DateTime.utc(2026, 8, 13),
      );
      when(
        () => draftRepository.load('user-1'),
      ).thenAnswer((_) async => Right<Failure, ProfileOnboardingDraft?>(draft));
      return buildBloc();
    },
    act: (bloc) async {
      final started = bloc.stream.firstWhere(
        (state) => state.draft?.currentStep == OnboardingStep.mainPhoto,
      );
      bloc.add(const ProfileOnboardingStarted('user-1'));
      await started;
      bloc.add(const MainPhotoContinuePressed());
    },
    expect: () => [
      isA<ProfileOnboardingState>().having(
        (state) => state.status,
        'status',
        ProfileOnboardingStatus.loading,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.draft?.currentStep,
        'loaded step',
        OnboardingStep.mainPhoto,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.draft?.currentStep,
        'next step',
        OnboardingStep.aboutMe,
      ),
    ],
  );
}
