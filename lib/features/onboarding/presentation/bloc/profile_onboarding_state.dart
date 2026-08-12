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
    this.healthStatuses = const [],
    this.maritalStatuses = const [],
    this.educationStatus = ReferenceStatus.idle,
    this.regionStatus = ReferenceStatus.idle,
    this.districtStatus = ReferenceStatus.idle,
    this.healthStatusStatus = ReferenceStatus.idle,
    this.maritalStatusStatus = ReferenceStatus.idle,
    this.isVoiceRecording = false,
    this.isVoicePlaying = false,
    this.isLocationLoading = false,
    this.failure,
  });

  final ProfileOnboardingStatus status;
  final ProfileOnboardingDraft? draft;
  final List<EducationLevel> educationLevels;
  final List<Region> regions;
  final List<District> districts;
  final List<HealthStatus> healthStatuses;
  final List<MaritalStatus> maritalStatuses;
  final ReferenceStatus educationStatus;
  final ReferenceStatus regionStatus;
  final ReferenceStatus districtStatus;
  final ReferenceStatus healthStatusStatus;
  final ReferenceStatus maritalStatusStatus;
  final bool isVoiceRecording;
  final bool isVoicePlaying;
  final bool isLocationLoading;
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
    List<HealthStatus>? healthStatuses,
    List<MaritalStatus>? maritalStatuses,
    ReferenceStatus? educationStatus,
    ReferenceStatus? regionStatus,
    ReferenceStatus? districtStatus,
    ReferenceStatus? healthStatusStatus,
    ReferenceStatus? maritalStatusStatus,
    bool? isVoiceRecording,
    bool? isVoicePlaying,
    bool? isLocationLoading,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProfileOnboardingState(
      status: status ?? this.status,
      draft: draft ?? this.draft,
      educationLevels: educationLevels ?? this.educationLevels,
      regions: regions ?? this.regions,
      districts: districts ?? this.districts,
      healthStatuses: healthStatuses ?? this.healthStatuses,
      maritalStatuses: maritalStatuses ?? this.maritalStatuses,
      educationStatus: educationStatus ?? this.educationStatus,
      regionStatus: regionStatus ?? this.regionStatus,
      districtStatus: districtStatus ?? this.districtStatus,
      healthStatusStatus: healthStatusStatus ?? this.healthStatusStatus,
      maritalStatusStatus: maritalStatusStatus ?? this.maritalStatusStatus,
      isVoiceRecording: isVoiceRecording ?? this.isVoiceRecording,
      isVoicePlaying: isVoicePlaying ?? this.isVoicePlaying,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
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
    healthStatuses,
    maritalStatuses,
    educationStatus,
    regionStatus,
    districtStatus,
    healthStatusStatus,
    maritalStatusStatus,
    isVoiceRecording,
    isVoicePlaying,
    isLocationLoading,
    failure,
  ];
}
