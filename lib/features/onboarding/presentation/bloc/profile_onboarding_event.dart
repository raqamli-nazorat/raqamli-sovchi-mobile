import 'package:equatable/equatable.dart';

import '../../domain/entities/candidate_type.dart';

sealed class ProfileOnboardingEvent extends Equatable {
  const ProfileOnboardingEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileOnboardingStarted extends ProfileOnboardingEvent {
  const ProfileOnboardingStarted(this.ownerUserId);

  final String ownerUserId;

  @override
  List<Object?> get props => [ownerUserId];
}

final class CandidateTypeSaved extends ProfileOnboardingEvent {
  const CandidateTypeSaved(this.candidateType);

  final CandidateType candidateType;

  @override
  List<Object?> get props => [candidateType];
}

final class CandidateTypeContinuePressed extends ProfileOnboardingEvent {
  const CandidateTypeContinuePressed();
}

final class PledgeAcceptanceChanged extends ProfileOnboardingEvent {
  const PledgeAcceptanceChanged(this.accepted);

  final bool accepted;

  @override
  List<Object?> get props => [accepted];
}

final class PledgeContinuePressed extends ProfileOnboardingEvent {
  const PledgeContinuePressed();
}

final class BirthDateSaved extends ProfileOnboardingEvent {
  const BirthDateSaved(this.birthDate);

  final DateTime birthDate;

  @override
  List<Object?> get props => [birthDate];
}

final class OnboardingStepBackRequested extends ProfileOnboardingEvent {
  const OnboardingStepBackRequested();
}

final class IdentitySaved extends ProfileOnboardingEvent {
  const IdentitySaved({
    required this.firstName,
    required this.lastName,
    required this.patronymic,
  });

  final String firstName;
  final String lastName;
  final String patronymic;

  @override
  List<Object?> get props => [firstName, lastName, patronymic];
}

final class EducationLevelsRequested extends ProfileOnboardingEvent {
  const EducationLevelsRequested({this.loadNextPage = false});

  final bool loadNextPage;

  @override
  List<Object?> get props => [loadNextPage];
}

final class EducationLevelSaved extends ProfileOnboardingEvent {
  const EducationLevelSaved(this.educationLevelId);

  final String educationLevelId;

  @override
  List<Object?> get props => [educationLevelId];
}

final class EducationContinuePressed extends ProfileOnboardingEvent {
  const EducationContinuePressed();
}

final class HeightSaved extends ProfileOnboardingEvent {
  const HeightSaved(this.heightCm, {this.weightKg});

  final int heightCm;
  final int? weightKg;

  @override
  List<Object?> get props => [heightCm, weightKg];
}

final class RegionsRequested extends ProfileOnboardingEvent {
  const RegionsRequested({this.loadNextPage = false});

  final bool loadNextPage;

  @override
  List<Object?> get props => [loadNextPage];
}

final class RegionSaved extends ProfileOnboardingEvent {
  const RegionSaved(this.regionId);

  final String regionId;

  @override
  List<Object?> get props => [regionId];
}

final class DistrictsRequested extends ProfileOnboardingEvent {
  const DistrictsRequested({this.loadNextPage = false});

  final bool loadNextPage;

  @override
  List<Object?> get props => [loadNextPage];
}

final class DistrictSaved extends ProfileOnboardingEvent {
  const DistrictSaved(this.districtId);

  final String districtId;

  @override
  List<Object?> get props => [districtId];
}

final class ProfileBootstrapRequested extends ProfileOnboardingEvent {
  const ProfileBootstrapRequested();
}

final class ProfilePhotoPickRequested extends ProfileOnboardingEvent {
  const ProfilePhotoPickRequested();
}

final class ProfilePhotoUploadRetryRequested extends ProfileOnboardingEvent {
  const ProfilePhotoUploadRetryRequested(this.localFilePath);

  final String localFilePath;

  @override
  List<Object?> get props => [localFilePath];
}

final class ProfilePhotoMainSelected extends ProfileOnboardingEvent {
  const ProfilePhotoMainSelected(this.serverId);

  final String serverId;

  @override
  List<Object?> get props => [serverId];
}

final class ProfilePhotoRemoveRequested extends ProfileOnboardingEvent {
  const ProfilePhotoRemoveRequested(this.localFilePath);

  final String localFilePath;

  @override
  List<Object?> get props => [localFilePath];
}

final class VoiceRecordingStarted extends ProfileOnboardingEvent {
  const VoiceRecordingStarted();
}

final class VoiceIntroStepRequested extends ProfileOnboardingEvent {
  const VoiceIntroStepRequested();
}

final class VoiceRecordingStopped extends ProfileOnboardingEvent {
  const VoiceRecordingStopped();
}

final class VoiceIntroContinuePressed extends ProfileOnboardingEvent {
  const VoiceIntroContinuePressed();
}

final class VoicePlaybackRequested extends ProfileOnboardingEvent {
  const VoicePlaybackRequested();
}

final class FaceVerificationRequested extends ProfileOnboardingEvent {
  const FaceVerificationRequested();
}

final class FaceSelfieCaptured extends ProfileOnboardingEvent {
  const FaceSelfieCaptured(this.sourcePath);

  final String sourcePath;

  @override
  List<Object?> get props => [sourcePath];
}

final class FaceVerificationPageOpened extends ProfileOnboardingEvent {
  const FaceVerificationPageOpened();
}

final class ProfileOnboardingFinalizationRequested
    extends ProfileOnboardingEvent {
  const ProfileOnboardingFinalizationRequested();
}

final class ProfileOnboardingCancelled extends ProfileOnboardingEvent {
  const ProfileOnboardingCancelled();
}
