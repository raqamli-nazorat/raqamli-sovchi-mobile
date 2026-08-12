import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../auth/application/use_cases/commit_pending_auth_session.dart';
import '../../application/onboarding_date_validator.dart';
import '../../application/services/onboarding_location_service.dart';
import '../../application/services/onboarding_media_service.dart';
import '../../domain/entities/candidate_type.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import '../../domain/entities/profile_onboarding_models.dart';
import '../../domain/repositories/onboarding_draft_repository.dart';
import '../../domain/repositories/onboarding_repository.dart';
import 'profile_onboarding_event.dart';
import 'profile_onboarding_state.dart';

const _maxProfilePhotos = 5;

final class ProfileOnboardingBloc
    extends Bloc<ProfileOnboardingEvent, ProfileOnboardingState> {
  ProfileOnboardingBloc({
    required OnboardingRepository onboardingRepository,
    required OnboardingDraftRepository draftRepository,
    required OnboardingMediaService mediaService,
    required OnboardingLocationService locationService,
    required CommitPendingAuthSessionUseCase commitPendingAuthSession,
    DateTime Function()? now,
  }) : _onboardingRepository = onboardingRepository,
       _draftRepository = draftRepository,
       _mediaService = mediaService,
       _locationService = locationService,
       _commitPendingAuthSession = commitPendingAuthSession,
       _now = now ?? DateTime.now,
       super(const ProfileOnboardingState()) {
    on<ProfileOnboardingStarted>(_onStarted);
    on<CandidateTypeSaved>(_onCandidateTypeSaved);
    on<CandidateTypeContinuePressed>(_onCandidateTypeContinuePressed);
    on<PledgeAcceptanceChanged>(_onPledgeAcceptanceChanged);
    on<PledgeContinuePressed>(_onPledgeContinuePressed);
    on<BirthDateSaved>(_onBirthDateSaved);
    on<OnboardingStepBackRequested>(_onStepBackRequested);
    on<IdentitySaved>(_onIdentitySaved);
    on<EducationLevelsRequested>(_onEducationLevelsRequested);
    on<EducationLevelSaved>(_onEducationLevelSaved);
    on<EducationContinuePressed>(_onEducationContinuePressed);
    on<HeightSaved>(_onHeightSaved);
    on<RegionsRequested>(_onRegionsRequested);
    on<RegionSaved>(_onRegionSaved);
    on<DistrictsRequested>(_onDistrictsRequested);
    on<DistrictSaved>(_onDistrictSaved);
    on<HealthStatusesRequested>(_onHealthStatusesRequested);
    on<LocationContinuePressed>(_onLocationContinuePressed);
    on<HealthStatusSaved>(_onHealthStatusSaved);
    on<HealthStatusContinuePressed>(_onHealthStatusContinuePressed);
    on<MaritalStatusesRequested>(_onMaritalStatusesRequested);
    on<MaritalStatusSaved>(_onMaritalStatusSaved);
    on<MaritalStatusContinuePressed>(_onMaritalStatusContinuePressed);
    on<ChildrenCountChanged>(_onChildrenCountChanged);
    on<ChildrenNotLivingWithMeChanged>(_onChildrenNotLivingWithMeChanged);
    on<ProfileBootstrapRequested>(_onProfileBootstrapRequested);
    on<ProfilePhotoPickRequested>(_onProfilePhotoPickRequested);
    on<ProfilePhotoUploadRetryRequested>(_onProfilePhotoUploadRetryRequested);
    on<ProfilePhotoMainSelected>(_onProfilePhotoMainSelected);
    on<ProfilePhotoRemoveRequested>(_onProfilePhotoRemoveRequested);
    on<VoiceIntroStepRequested>(_onVoiceIntroStepRequested);
    on<ProfilePhotosContinuePressed>(_onProfilePhotosContinuePressed);
    on<MainPhotoContinuePressed>(_onMainPhotoContinuePressed);
    on<VoiceRecordingStarted>(_onVoiceRecordingStarted);
    on<VoiceRecordingStopped>(_onVoiceRecordingStopped);
    on<VoiceIntroContinuePressed>(_onVoiceIntroContinuePressed);
    on<VoiceIntroSkipped>(_onVoiceIntroSkipped);
    on<VoiceIntroDeleted>(_onVoiceIntroDeleted);
    on<VoicePlaybackRequested>(_onVoicePlaybackRequested);
    on<LocationPermissionRequested>(_onLocationPermissionRequested);
    on<FaceVerificationPageOpened>(_onFaceVerificationPageOpened);
    on<FaceVerificationRequested>(_onFaceVerificationRequested);
    on<FaceSelfieCaptured>(_onFaceSelfieCaptured);
    on<AboutMeContinuePressed>(_onAboutMeContinuePressed);
    on<AboutMeSkipPressed>(_onAboutMeSkipPressed);
    on<ProfileOnboardingFinalizationRequested>(_onFinalizationRequested);
    on<ProfileReadyHomeRequested>(_onProfileReadyHomeRequested);
    on<ProfileOnboardingCancelled>(_onCancelled);
  }

  final OnboardingRepository _onboardingRepository;
  final OnboardingDraftRepository _draftRepository;
  final OnboardingMediaService _mediaService;
  final OnboardingLocationService _locationService;
  final CommitPendingAuthSessionUseCase _commitPendingAuthSession;
  final DateTime Function() _now;

  int _educationPage = 0;
  int _regionPage = 0;
  int _districtPage = 0;
  int _healthStatusPage = 0;
  int _maritalStatusPage = 0;
  String? _districtRegionRequest;
  String _districtSearch = '';
  bool _faceVerificationInFlight = false;

  Future<void> _onStarted(
    ProfileOnboardingStarted event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _draftRepository.load(event.ownerUserId);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure,
        ),
      ),
      (draft) async => emit(
        ProfileOnboardingState(
          status: draft?.candidateType == CandidateType.representative
              ? ProfileOnboardingStatus.representativeFlow
              : ProfileOnboardingStatus.editing,
          draft:
              draft ??
              ProfileOnboardingDraft(
                ownerUserId: event.ownerUserId,
                updatedAt: _now().toUtc(),
              ),
        ),
      ),
    );
  }

  Future<void> _onCandidateTypeSaved(
    CandidateTypeSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    final updated = draft.copyWith(candidateType: event.candidateType);
    await _save(updated, emit);
  }

  Future<void> _onCandidateTypeContinuePressed(
    CandidateTypeContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.candidateType == null) return;
    if (draft!.candidateType == CandidateType.representative) {
      emit(state.copyWith(status: ProfileOnboardingStatus.representativeFlow));
      return;
    }
    await _save(draft.copyWith(currentStep: OnboardingStep.pledge), emit);
  }

  Future<void> _onPledgeAcceptanceChanged(
    PledgeAcceptanceChanged event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    await _save(draft.copyWith(pledgeAcceptedTerms: event.accepted), emit);
  }

  Future<void> _onPledgeContinuePressed(
    PledgeContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.pledgeAcceptedTerms != true) return;
    await _save(draft!.copyWith(currentStep: OnboardingStep.identity), emit);
  }

  Future<void> _onBirthDateSaved(
    BirthDateSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    if (!OnboardingDateValidator.isEligible(event.birthDate, _now())) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    await _save(
      draft.copyWith(
        birthDate: event.birthDate,
        currentStep: OnboardingStep.education,
      ),
      emit,
    );
  }

  Future<void> _onStepBackRequested(
    OnboardingStepBackRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || draft.currentStep.index == 0) return;
    final previousStep = OnboardingStep.values[draft.currentStep.index - 1];
    await _save(draft.copyWith(currentStep: previousStep), emit);
  }

  Future<void> _onIdentitySaved(
    IdentitySaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null ||
        event.firstName.trim().isEmpty ||
        event.lastName.trim().isEmpty ||
        event.patronymic.trim().isEmpty) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    await _save(
      draft.copyWith(
        firstName: event.firstName.trim(),
        lastName: event.lastName.trim(),
        patronymic: event.patronymic.trim(),
        currentStep: OnboardingStep.birthDate,
      ),
      emit,
    );
  }

  Future<void> _onEducationLevelsRequested(
    EducationLevelsRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final page = event.loadNextPage ? _educationPage + 1 : 1;
    emit(
      state.copyWith(
        educationStatus: ReferenceStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.getEducationLevels(page);
    result.fold(
      (failure) => emit(
        state.copyWith(
          educationStatus: ReferenceStatus.failure,
          failure: failure,
        ),
      ),
      (response) {
        _educationPage = page;
        final items = event.loadNextPage
            ? [...state.educationLevels, ...response.items]
            : response.items;
        emit(
          state.copyWith(
            educationLevels: items,
            educationStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onEducationLevelSaved(
    EducationLevelSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.educationLevelId.isEmpty) return;
    await _save(draft.copyWith(educationLevelId: event.educationLevelId), emit);
  }

  Future<void> _onEducationContinuePressed(
    EducationContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.educationLevelId?.isEmpty ?? true) return;
    await _save(draft!.copyWith(currentStep: OnboardingStep.height), emit);
  }

  Future<void> _onHeightSaved(
    HeightSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null ||
        event.heightCm < 100 ||
        event.heightCm > 300 ||
        (event.weightKg != null &&
            (event.weightKg! < 20 || event.weightKg! > 250))) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    await _save(
      draft.copyWith(
        heightCm: event.heightCm,
        weightKg: event.weightKg,
        currentStep: OnboardingStep.location,
      ),
      emit,
    );
  }

  Future<void> _onRegionsRequested(
    RegionsRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final page = event.loadNextPage ? _regionPage + 1 : 1;
    emit(
      state.copyWith(regionStatus: ReferenceStatus.loading, clearFailure: true),
    );
    final result = await _onboardingRepository.getRegions(page);
    result.fold(
      (failure) => emit(
        state.copyWith(regionStatus: ReferenceStatus.failure, failure: failure),
      ),
      (response) {
        _regionPage = page;
        final items = event.loadNextPage
            ? [...state.regions, ...response.items]
            : response.items;
        emit(
          state.copyWith(
            regions: items,
            regionStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onRegionSaved(
    RegionSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.regionId.isEmpty) return;
    _districtPage = 0;
    _districtRegionRequest = event.regionId;
    _districtSearch = '';
    await _save(
      draft.copyWith(
        regionId: event.regionId,
        clearDistrict: true,
        currentStep: OnboardingStep.location,
      ),
      emit,
    );
    add(const DistrictsRequested());
  }

  Future<void> _onDistrictsRequested(
    DistrictsRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final regionId = state.draft?.regionId;
    if (regionId == null || regionId.isEmpty) return;
    final search = event.search ?? _districtSearch;
    final isNewSearch = search != _districtSearch;
    final page = event.loadNextPage && !isNewSearch ? _districtPage + 1 : 1;
    _districtSearch = search;
    final requestId = regionId;
    _districtRegionRequest = requestId;
    emit(
      state.copyWith(
        districtStatus: ReferenceStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.getDistricts(
      regionId: regionId,
      page: page,
      search: search,
    );
    if (_districtRegionRequest != requestId ||
        _districtSearch != search ||
        state.draft?.regionId != requestId) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(
          districtStatus: ReferenceStatus.failure,
          failure: failure,
        ),
      ),
      (response) {
        _districtPage = page;
        final items = event.loadNextPage && !isNewSearch
            ? [...state.districts, ...response.items]
            : response.items;
        emit(
          state.copyWith(
            districts: items,
            districtStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onDistrictSaved(
    DistrictSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.districtId.isEmpty) return;
    await _save(
      draft.copyWith(
        districtId: event.districtId,
        currentStep: OnboardingStep.location,
      ),
      emit,
    );
  }

  Future<void> _onHealthStatusesRequested(
    HealthStatusesRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final page = event.loadNextPage ? _healthStatusPage + 1 : 1;
    emit(
      state.copyWith(
        healthStatusStatus: ReferenceStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.getHealthStatuses(page);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          healthStatusStatus: ReferenceStatus.failure,
          failure: failure,
        ),
      ),
      (response) async {
        _healthStatusPage = page;
        final items = event.loadNextPage
            ? [...state.healthStatuses, ...response.items]
            : response.items;
        var nextDraft = state.draft;
        if (items.isNotEmpty && (nextDraft?.healthStatusId?.isEmpty ?? true)) {
          final defaultStatus = items.firstWhere(
            (item) => !item.name.toLowerCase().contains('nogiron'),
            orElse: () => items.first,
          );
          nextDraft = nextDraft?.copyWith(healthStatusId: defaultStatus.id);
        }
        if (nextDraft != state.draft) {
          await _save(nextDraft!, emit);
        }
        emit(
          state.copyWith(
            draft: nextDraft,
            healthStatuses: items,
            healthStatusStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onLocationContinuePressed(
    LocationContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if ((draft?.regionId?.isEmpty ?? true) ||
        (draft?.districtId?.isEmpty ?? true)) {
      return;
    }
    await _save(
      draft!.copyWith(currentStep: OnboardingStep.healthStatus),
      emit,
    );
  }

  Future<void> _onHealthStatusSaved(
    HealthStatusSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.healthStatusId.isEmpty) return;
    await _save(
      draft.copyWith(
        healthStatusId: event.healthStatusId,
        currentStep: OnboardingStep.healthStatus,
      ),
      emit,
    );
  }

  Future<void> _onHealthStatusContinuePressed(
    HealthStatusContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.healthStatusId?.isEmpty ?? true) return;
    await _save(
      draft!.copyWith(currentStep: OnboardingStep.maritalStatus),
      emit,
    );
  }

  Future<void> _onMaritalStatusesRequested(
    MaritalStatusesRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final page = event.loadNextPage ? _maritalStatusPage + 1 : 1;
    emit(
      state.copyWith(
        maritalStatusStatus: ReferenceStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.getMaritalStatuses(page);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          maritalStatusStatus: ReferenceStatus.failure,
          failure: failure,
        ),
      ),
      (response) async {
        _maritalStatusPage = page;
        final items = event.loadNextPage
            ? [...state.maritalStatuses, ...response.items]
            : response.items;
        var nextDraft = state.draft;
        if (items.isNotEmpty && (nextDraft?.maritalStatusId?.isEmpty ?? true)) {
          final defaultStatus = items.firstWhere(
            (item) => !_isDivorcedStatus(item.name),
            orElse: () => items.first,
          );
          nextDraft = nextDraft?.copyWith(maritalStatusId: defaultStatus.id);
        }
        if (nextDraft != state.draft) {
          await _save(nextDraft!, emit);
        }
        emit(
          state.copyWith(
            draft: nextDraft,
            maritalStatuses: items,
            maritalStatusStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onMaritalStatusSaved(
    MaritalStatusSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.maritalStatusId.isEmpty) return;
    await _save(
      draft.copyWith(
        maritalStatusId: event.maritalStatusId,
        currentStep: OnboardingStep.maritalStatus,
      ),
      emit,
    );
  }

  Future<void> _onMaritalStatusContinuePressed(
    MaritalStatusContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.maritalStatusId?.isEmpty ?? true) return;
    add(const ProfileBootstrapRequested());
  }

  Future<void> _onChildrenCountChanged(
    ChildrenCountChanged event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    if (draft.childrenNotLivingWithMe) {
      if (draft.childrenCount != 0) {
        await _save(draft.copyWith(childrenCount: 0), emit);
      }
      return;
    }
    final count = event.count.clamp(0, 99);
    await _save(draft.copyWith(childrenCount: count), emit);
  }

  Future<void> _onChildrenNotLivingWithMeChanged(
    ChildrenNotLivingWithMeChanged event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    await _save(
      draft.copyWith(
        childrenNotLivingWithMe: event.value,
        childrenCount: event.value ? 0 : draft.childrenCount,
      ),
      emit,
    );
  }

  Future<void> _onProfileBootstrapRequested(
    ProfileBootstrapRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null ||
        !draft.hasQuestionnaire ||
        draft.candidateType == null) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    if (draft.profileServerId != null) {
      await _save(draft.copyWith(currentStep: OnboardingStep.photos), emit);
      return;
    }
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.submitting,
        clearFailure: true,
      ),
    );
    final request = ProfileBootstrapRequest(
      firstName: draft.firstName!,
      lastName: draft.lastName!,
      fatherName: draft.patronymic,
      candidateType: draft.candidateType!,
      birthYear: draft.birthDate!.year,
      heightCm: draft.heightCm!,
      weightKg: draft.weightKg,
      regionId: draft.regionId!,
      districtId: draft.districtId!,
      educationLevelId: draft.educationLevelId!,
      maritalStatusId: draft.maritalStatusId!,
      hasChildren: draft.childrenCount > 0 || draft.childrenNotLivingWithMe,
      childrenCount: draft.childrenNotLivingWithMe ? 0 : draft.childrenCount,
      healthStatusId: draft.healthStatusId,
    );
    final result = await _onboardingRepository.createProfile(request);
    await result.fold<Future<void>>(
      (failure) async {
        if (failure.type == FailureType.networkTimeout) {
          final reconcile = await _onboardingRepository.getMyProfile();
          await reconcile.fold<Future<void>>(
            (reconcileFailure) async => emit(
              state.copyWith(
                status: ProfileOnboardingStatus.editing,
                failure: reconcileFailure,
              ),
            ),
            (profile) => _save(
              draft.copyWith(
                profileServerId: profile.id,
                currentStep: OnboardingStep.photos,
              ),
              emit,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: ProfileOnboardingStatus.editing,
            failure: failure,
          ),
        );
      },
      (profile) => _save(
        draft.copyWith(
          profileServerId: profile.id,
          currentStep: OnboardingStep.photos,
        ),
        emit,
      ),
    );
  }

  bool _isDivorcedStatus(String name) {
    return name.trim().toLowerCase() == 'ajrashgan';
  }

  Future<void> _onProfilePhotoPickRequested(
    ProfilePhotoPickRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || draft.profileServerId == null) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    if (draft.photos.length >= _maxProfilePhotos) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    try {
      final filePath = await _mediaService.pickAndPrepareProfilePhoto();
      if (filePath == null) return;
      final usedOrders = draft.photos.map((photo) => photo.order).toSet();
      final order = Iterable<int>.generate(
        _maxProfilePhotos,
        (index) => index + 1,
      ).firstWhere((value) => !usedOrders.contains(value));
      final photo = OnboardingPhotoDraft(
        localFilePath: filePath,
        order: order,
        isMain: draft.photos.isEmpty,
        uploadStatus: PhotoUploadStatus.pending,
      );
      final withPhoto = draft.copyWith(photos: [...draft.photos, photo]);
      await _save(withPhoto, emit);
    } on OnboardingMediaValidationException {
      emit(state.copyWith(failure: const Failure.validation()));
    }
  }

  Future<void> _onProfilePhotoUploadRetryRequested(
    ProfilePhotoUploadRetryRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) => _uploadPhoto(event.localFilePath, emit);

  Future<void> _uploadPhoto(
    String localFilePath,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    final profileId = draft?.profileServerId;
    if (draft == null || profileId == null || profileId.isEmpty) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    final index = draft.photos.indexWhere(
      (photo) => photo.localFilePath == localFilePath,
    );
    if (index < 0) return;
    final uploading = List<OnboardingPhotoDraft>.from(draft.photos);
    uploading[index] = uploading[index].copyWith(
      uploadStatus: PhotoUploadStatus.uploading,
      clearUploadFailure: true,
    );
    await _save(draft.copyWith(photos: uploading), emit);
    if (state.status != ProfileOnboardingStatus.submitting) {
      emit(state.copyWith(status: ProfileOnboardingStatus.submitting));
    }
    final photo = uploading[index];
    final result = await _onboardingRepository.uploadPhoto(
      profileId: profileId,
      localFilePath: photo.localFilePath,
      order: photo.order,
      isMain: photo.isMain,
    );
    await result.fold<Future<void>>(
      (failure) async {
        final failed = List<OnboardingPhotoDraft>.from(state.draft!.photos);
        final failedIndex = failed.indexWhere(
          (item) => item.localFilePath == localFilePath,
        );
        if (failedIndex >= 0) {
          failed[failedIndex] = failed[failedIndex].copyWith(
            uploadStatus: PhotoUploadStatus.failed,
            uploadFailure: failure.type.name,
          );
          await _save(state.draft!.copyWith(photos: failed), emit);
        }
      },
      (uploaded) async {
        final updated = List<OnboardingPhotoDraft>.from(state.draft!.photos);
        final uploadedIndex = updated.indexWhere(
          (item) => item.localFilePath == localFilePath,
        );
        if (uploadedIndex < 0) return;
        updated[uploadedIndex] = updated[uploadedIndex].copyWith(
          serverId: uploaded.id,
          imageUrl: uploaded.imageUrl,
          isMain: uploaded.isMain,
          uploadStatus: PhotoUploadStatus.uploaded,
          clearUploadFailure: true,
        );
        await _save(
          state.draft!.copyWith(
            photos: updated,
            mainPhotoServerId: uploaded.isMain
                ? uploaded.id
                : state.draft!.mainPhotoServerId,
          ),
          emit,
        );
        await _reconcilePhotos(emit);
      },
    );
  }

  Future<void> _reconcilePhotos(Emitter<ProfileOnboardingState> emit) async {
    final result = await _onboardingRepository.getPhotos();
    await result.fold<Future<void>>((_) async {}, (photos) async {
      final draft = state.draft;
      if (draft == null) return;
      final updated = draft.photos
          .map((local) {
            final remote = local.serverId == null
                ? null
                : photos
                      .where((photo) => photo.id == local.serverId)
                      .firstOrNull;
            return remote == null
                ? local
                : local.copyWith(
                    imageUrl: remote.imageUrl,
                    isMain: remote.isMain,
                    uploadStatus: PhotoUploadStatus.uploaded,
                  );
          })
          .toList(growable: false);
      final main = photos.where((photo) => photo.isMain).firstOrNull;
      await _save(
        draft.copyWith(photos: updated, mainPhotoServerId: main?.id),
        emit,
      );
    });
  }

  Future<void> _onProfilePhotoMainSelected(
    ProfilePhotoMainSelected event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    if (event.serverId == draft.mainPhotoServerId) return;
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.submitting,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.setMainPhoto(event.serverId);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure,
        ),
      ),
      (photo) async {
        final updated = draft.photos
            .map((item) => item.copyWith(isMain: item.serverId == photo.id))
            .toList(growable: false);
        await _save(
          draft.copyWith(photos: updated, mainPhotoServerId: photo.id),
          emit,
        );
      },
    );
  }

  Future<void> _onProfilePhotoRemoveRequested(
    ProfilePhotoRemoveRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    final photo = draft.photos
        .where((item) => item.localFilePath == event.localFilePath)
        .firstOrNull;
    if (photo == null) return;
    if (photo.serverId != null) {
      final result = await _onboardingRepository.deletePhoto(photo.serverId!);
      final failure = result.fold<Failure?>((value) => value, (_) => null);
      if (failure != null) {
        emit(state.copyWith(failure: failure));
        return;
      }
    }
    await _mediaService.deletePrivateFile(photo.localFilePath);
    final remaining = draft.photos
        .where((item) => item.localFilePath != event.localFilePath)
        .toList(growable: true);
    if (remaining.isNotEmpty && remaining.every((item) => !item.isMain)) {
      remaining[0] = remaining[0].copyWith(isMain: true);
    }
    final main = remaining.where((item) => item.isMain).firstOrNull;
    await _save(
      draft.copyWith(
        photos: remaining.toList(growable: false),
        mainPhotoServerId: main?.serverId,
        clearMainPhoto: main?.serverId == null,
      ),
      emit,
    );
  }

  Future<void> _onVoiceRecordingStarted(
    VoiceRecordingStarted event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    try {
      await _mediaService.startVoiceRecording();
      emit(state.copyWith(isVoiceRecording: true, clearFailure: true));
    } on OnboardingMediaValidationException {
      emit(state.copyWith(failure: const Failure.validation()));
    }
  }

  Future<void> _onVoiceIntroStepRequested(
    VoiceIntroStepRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) => _continueAfterPhotos(emit);

  Future<void> _onProfilePhotosContinuePressed(
    ProfilePhotosContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) => _continueAfterPhotos(emit);

  Future<void> _continueAfterPhotos(
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || draft.photos.isEmpty) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    if (!draft.hasUploadedPhotos || !draft.hasMainPhoto) {
      emit(
        state.copyWith(
          status: ProfileOnboardingStatus.submitting,
          clearFailure: true,
        ),
      );
      for (final photo in draft.photos) {
        final currentDraft = state.draft;
        if (currentDraft == null) return;
        final currentPhoto = currentDraft.photos
            .where((item) => item.localFilePath == photo.localFilePath)
            .firstOrNull;
        if (currentPhoto == null ||
            currentPhoto.uploadStatus == PhotoUploadStatus.uploaded) {
          continue;
        }
        await _uploadPhoto(photo.localFilePath, emit);
        if (state.status != ProfileOnboardingStatus.submitting) {
          emit(state.copyWith(status: ProfileOnboardingStatus.submitting));
        }
        final uploadedPhoto = state.draft?.photos
            .where((item) => item.localFilePath == photo.localFilePath)
            .firstOrNull;
        if (uploadedPhoto?.uploadStatus == PhotoUploadStatus.failed) {
          emit(state.copyWith(status: ProfileOnboardingStatus.editing));
          return;
        }
      }
    }
    final updatedDraft = state.draft;
    if (updatedDraft == null ||
        !updatedDraft.hasUploadedPhotos ||
        !updatedDraft.hasMainPhoto) {
      emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: const Failure.validation(),
        ),
      );
      return;
    }
    await _save(
      updatedDraft.copyWith(currentStep: OnboardingStep.mainPhoto),
      emit,
    );
  }

  Future<void> _onMainPhotoContinuePressed(
    MainPhotoContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || !draft.hasUploadedPhotos || !draft.hasMainPhoto) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    await _save(
      draft.copyWith(currentStep: OnboardingStep.faceVerification),
      emit,
    );
  }

  Future<void> _onVoiceRecordingStopped(
    VoiceRecordingStopped event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    try {
      final voice = await _mediaService.stopVoiceRecording();
      emit(state.copyWith(isVoiceRecording: false));
      if (voice == null) return;
      if (draft.voiceIntroMetadata != null) {
        await _mediaService.deletePrivateFile(
          draft.voiceIntroMetadata!.localFilePath,
        );
      }
      await _save(draft.copyWith(voiceIntroMetadata: voice), emit);
    } on OnboardingMediaValidationException {
      emit(
        state.copyWith(
          isVoiceRecording: false,
          status: ProfileOnboardingStatus.editing,
          failure: const Failure.validation(),
        ),
      );
    }
  }

  Future<void> _onVoicePlaybackRequested(
    VoicePlaybackRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final voice = state.draft?.voiceIntroMetadata;
    if (voice == null) return;
    if (state.isVoicePlaying) {
      await _mediaService.stopVoicePlayback();
      emit(state.copyWith(isVoicePlaying: false));
      return;
    }
    emit(state.copyWith(isVoicePlaying: true));
    try {
      await _mediaService.playVoice(voice.localFilePath);
    } finally {
      if (!isClosed) emit(state.copyWith(isVoicePlaying: false));
    }
  }

  Future<void> _onVoiceIntroContinuePressed(
    VoiceIntroContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || state.isVoiceRecording) return;
    await _continueFromVoice(draft, emit);
  }

  Future<void> _onVoiceIntroSkipped(
    VoiceIntroSkipped event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || state.isVoiceRecording) return;
    await _mediaService.stopVoicePlayback();
    if (draft.voiceIntroMetadata != null) {
      await _mediaService.deletePrivateFile(
        draft.voiceIntroMetadata!.localFilePath,
      );
    }
    await _save(
      draft.copyWith(
        currentStep: OnboardingStep.locationPermission,
        clearVoiceIntro: true,
      ),
      emit,
    );
  }

  Future<void> _onVoiceIntroDeleted(
    VoiceIntroDeleted event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    final voice = draft?.voiceIntroMetadata;
    if (draft == null || voice == null || state.isVoiceRecording) return;
    await _mediaService.stopVoicePlayback();
    await _mediaService.deletePrivateFile(voice.localFilePath);
    await _save(draft.copyWith(clearVoiceIntro: true), emit);
  }

  Future<void> _continueFromVoice(
    ProfileOnboardingDraft draft,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final voice = draft.voiceIntroMetadata;
    if (voice == null || voice.uploaded) {
      await _save(
        draft.copyWith(currentStep: OnboardingStep.locationPermission),
        emit,
      );
      return;
    }
    emit(state.copyWith(status: ProfileOnboardingStatus.submitting));
    final result = await _onboardingRepository.updateVoiceIntro(
      voice.localFilePath,
    );
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure,
        ),
      ),
      (_) => _save(
        state.draft!.copyWith(
          voiceIntroMetadata: voice.copyWith(uploaded: true),
          currentStep: OnboardingStep.locationPermission,
        ),
        emit,
      ),
    );
  }

  Future<void> _onLocationPermissionRequested(
    LocationPermissionRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || state.isLocationLoading) return;
    emit(state.copyWith(isLocationLoading: true, clearFailure: true));
    try {
      final coordinates = await _locationService.requestCurrentLocation();
      await _save(
        draft.copyWith(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
          currentStep: OnboardingStep.success,
        ),
        emit,
      );
      emit(state.copyWith(isLocationLoading: false));
    } on OnboardingLocationPermissionException {
      emit(
        state.copyWith(
          isLocationLoading: false,
          failure: const Failure.forbidden(),
        ),
      );
    } on OnboardingLocationUnavailableException {
      emit(
        state.copyWith(
          isLocationLoading: false,
          failure: const Failure.unsupported(),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLocationLoading: false,
          failure: const Failure.unknown(),
        ),
      );
    }
  }

  Future<void> _onFaceVerificationRequested(
    FaceVerificationRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || !draft.hasMainPhoto || _faceVerificationInFlight) {
      return;
    }
    await _save(
      draft.copyWith(faceVerificationStatus: FaceVerificationStatus.notStarted),
      emit,
    );
  }

  Future<void> _onFaceVerificationPageOpened(
    FaceVerificationPageOpened event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    if (_faceVerificationInFlight) return;
    await _reconcilePhotos(emit);
  }

  Future<void> _onFaceSelfieCaptured(
    FaceSelfieCaptured event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    if (_faceVerificationInFlight) return;
    final draft = state.draft;
    if (draft == null || !draft.hasMainPhoto) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    _faceVerificationInFlight = true;
    String? selfiePath;
    try {
      selfiePath = await _mediaService.prepareSelfie(event.sourcePath);
      final quality = await _mediaService.checkSelfieQuality(selfiePath);
      if (!quality.isValid) {
        await _save(
          draft.copyWith(
            faceVerificationStatus: FaceVerificationStatus.retryableFailure,
          ),
          emit,
        );
        return;
      }
      await _save(
        draft.copyWith(
          faceVerificationStatus: FaceVerificationStatus.verifying,
        ),
        emit,
      );
      final result = await _onboardingRepository.verifyFace(selfiePath);
      await result.fold<Future<void>>(
        (failure) => _save(
          state.draft!.copyWith(
            faceVerificationStatus: failure.type == FailureType.forbidden
                ? FaceVerificationStatus.blocked
                : FaceVerificationStatus.retryableFailure,
          ),
          emit,
        ),
        (response) => _save(
          state.draft!.copyWith(
            currentStep: response.verified
                ? OnboardingStep.aboutMe
                : OnboardingStep.faceVerification,
            faceVerificationStatus: response.verified
                ? FaceVerificationStatus.matched
                : FaceVerificationStatus.retryableFailure,
          ),
          emit,
        ),
      );
    } on OnboardingMediaValidationException {
      await _save(
        state.draft!.copyWith(
          faceVerificationStatus: FaceVerificationStatus.retryableFailure,
        ),
        emit,
      );
    } finally {
      _faceVerificationInFlight = false;
      await _mediaService.deletePrivateFile(event.sourcePath);
      if (selfiePath != null) await _mediaService.deletePrivateFile(selfiePath);
    }
  }

  Future<void> _onAboutMeContinuePressed(
    AboutMeContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    final value = event.aboutMe.trim();
    await _save(
      draft.copyWith(
        aboutMe: value.isEmpty ? null : value,
        clearAboutMe: value.isEmpty,
        currentStep: OnboardingStep.voiceIntro,
      ),
      emit,
    );
  }

  Future<void> _onAboutMeSkipPressed(
    AboutMeSkipPressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    await _save(
      draft.copyWith(
        currentStep: OnboardingStep.voiceIntro,
        clearAboutMe: true,
      ),
      emit,
    );
  }

  Future<void> _onFinalizationRequested(
    ProfileOnboardingFinalizationRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    if (state.status == ProfileOnboardingStatus.submitting) return;
    final draft = state.draft;
    if (draft == null ||
        draft.profileServerId == null ||
        !draft.hasUploadedPhotos ||
        !draft.hasMainPhoto ||
        draft.faceVerificationStatus != FaceVerificationStatus.matched ||
        !draft.pledgeAcceptedTerms) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.submitting,
        clearFailure: true,
      ),
    );
    if (draft.aboutMe != null ||
        draft.latitude != null ||
        draft.longitude != null) {
      final details = await _onboardingRepository.updateProfileDetails(
        aboutMe: draft.aboutMe,
        latitude: draft.latitude,
        longitude: draft.longitude,
      );
      final detailsFailure = details.fold<Failure?>(
        (failure) => failure,
        (_) => null,
      );
      if (detailsFailure != null) {
        emit(
          state.copyWith(
            status: ProfileOnboardingStatus.editing,
            failure: detailsFailure,
          ),
        );
        return;
      }
    }
    final pledge = await _onboardingRepository.submitPledge(
      userId: draft.ownerUserId,
      acceptedTerms: true,
      hasSeriousBadge: true,
    );
    final pledgeFailure = pledge.fold<Failure?>(
      (failure) => failure,
      (_) => null,
    );
    if (pledgeFailure != null) {
      emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: pledgeFailure,
        ),
      );
      return;
    }
    final commit = await _commitPendingAuthSession();
    final commitFailure = commit.fold<Failure?>(
      (failure) => failure,
      (_) => null,
    );
    if (commitFailure != null) {
      emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: commitFailure,
        ),
      );
      return;
    }
    await _cleanupDraftMedia(draft);
    final profileReadyDraft = draft.copyWith(
      currentStep: OnboardingStep.profileReady,
    );
    final draftSave = await _draftRepository.save(profileReadyDraft);
    draftSave.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          draft: profileReadyDraft,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          draft: profileReadyDraft,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> _onProfileReadyHomeRequested(
    ProfileReadyHomeRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    if (state.status == ProfileOnboardingStatus.submitting) return;
    await _draftRepository.clear();
    emit(state.copyWith(status: ProfileOnboardingStatus.completed));
  }

  Future<void> _onCancelled(
    ProfileOnboardingCancelled event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft != null) {
      await _cleanupDraftMedia(draft);
      await _draftRepository.clear();
    }
    await _mediaService.cancelVoiceRecording();
    await _mediaService.stopVoicePlayback();
    emit(
      const ProfileOnboardingState(status: ProfileOnboardingStatus.cancelled),
    );
  }

  Future<void> _save(
    ProfileOnboardingDraft draft,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final result = await _draftRepository.save(draft);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          draft: draft,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> _cleanupDraftMedia(ProfileOnboardingDraft draft) async {
    for (final photo in draft.photos) {
      await _mediaService.deletePrivateFile(photo.localFilePath);
    }
    final voice = draft.voiceIntroMetadata;
    if (voice != null) {
      await _mediaService.deletePrivateFile(voice.localFilePath);
    }
  }

  @override
  Future<void> close() async {
    await _mediaService.dispose();
    return super.close();
  }
}
