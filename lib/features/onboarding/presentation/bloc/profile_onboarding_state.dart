import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/onboarding_reference.dart';
import '../../domain/entities/profile_onboarding_draft.dart';

enum ProfileOnboardingStatus {
  initial,
  loading,
  editing,
  submitting,
  completed,
  cancelled,
  representativeFlow,
}

enum ReferenceStatus { idle, loading, loaded, empty, failure }

final class ProfileOnboardingState extends Equatable {
  const ProfileOnboardingState({
    this.status = ProfileOnboardingStatus.initial,
    this.draft,
    this.educationLevels = const [],
    this.regions = const [],
    this.districts = const [],
    this.educationStatus = ReferenceStatus.idle,
    this.regionStatus = ReferenceStatus.idle,
    this.districtStatus = ReferenceStatus.idle,
    this.isVoiceRecording = false,
    this.failure,
  });

  final ProfileOnboardingStatus status;
  final ProfileOnboardingDraft? draft;
  final List<EducationLevel> educationLevels;
  final List<Region> regions;
  final List<District> districts;
  final ReferenceStatus educationStatus;
  final ReferenceStatus regionStatus;
  final ReferenceStatus districtStatus;
  final bool isVoiceRecording;
  final Failure? failure;

  bool get isBusy =>
      status == ProfileOnboardingStatus.loading ||
      status == ProfileOnboardingStatus.submitting;

  ProfileOnboardingState copyWith({
    ProfileOnboardingStatus? status,
    ProfileOnboardingDraft? draft,
    List<EducationLevel>? educationLevels,
    List<Region>? regions,
    List<District>? districts,
    ReferenceStatus? educationStatus,
    ReferenceStatus? regionStatus,
    ReferenceStatus? districtStatus,
    bool? isVoiceRecording,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProfileOnboardingState(
      status: status ?? this.status,
      draft: draft ?? this.draft,
      educationLevels: educationLevels ?? this.educationLevels,
      regions: regions ?? this.regions,
      districts: districts ?? this.districts,
      educationStatus: educationStatus ?? this.educationStatus,
      regionStatus: regionStatus ?? this.regionStatus,
      districtStatus: districtStatus ?? this.districtStatus,
      isVoiceRecording: isVoiceRecording ?? this.isVoiceRecording,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    draft,
    educationLevels,
    regions,
    districts,
    educationStatus,
    regionStatus,
    districtStatus,
    isVoiceRecording,
    failure,
  ];
}
