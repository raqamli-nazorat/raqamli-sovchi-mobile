import 'package:equatable/equatable.dart';

import 'candidate_type.dart';

enum OnboardingStep {
  candidateType,
  pledge,
  identity,
  birthDate,
  education,
  height,
  location,
  photos,
  voiceIntro,
  faceVerification,
  success,
}

enum PhotoUploadStatus { pending, uploading, uploaded, failed }

enum FaceVerificationStatus {
  notStarted,
  verifying,
  matched,
  retryableFailure,
  blocked,
}

final class OnboardingPhotoDraft extends Equatable {
  const OnboardingPhotoDraft({
    required this.localFilePath,
    required this.order,
    required this.uploadStatus,
    this.serverId,
    this.imageUrl,
    this.isMain = false,
    this.uploadFailure,
  });

  final String localFilePath;
  final String? serverId;
  final String? imageUrl;
  final int order;
  final bool isMain;
  final PhotoUploadStatus uploadStatus;
  final String? uploadFailure;

  OnboardingPhotoDraft copyWith({
    String? serverId,
    String? imageUrl,
    int? order,
    bool? isMain,
    PhotoUploadStatus? uploadStatus,
    String? uploadFailure,
    bool clearUploadFailure = false,
  }) {
    return OnboardingPhotoDraft(
      localFilePath: localFilePath,
      serverId: serverId ?? this.serverId,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      isMain: isMain ?? this.isMain,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      uploadFailure: clearUploadFailure
          ? null
          : uploadFailure ?? this.uploadFailure,
    );
  }

  @override
  List<Object?> get props => [
    localFilePath,
    serverId,
    imageUrl,
    order,
    isMain,
    uploadStatus,
    uploadFailure,
  ];
}

final class VoiceIntroMetadata extends Equatable {
  const VoiceIntroMetadata({
    required this.localFilePath,
    required this.duration,
    required this.sizeBytes,
    required this.uploaded,
  });

  final String localFilePath;
  final Duration duration;
  final int sizeBytes;
  final bool uploaded;

  VoiceIntroMetadata copyWith({bool? uploaded}) {
    return VoiceIntroMetadata(
      localFilePath: localFilePath,
      duration: duration,
      sizeBytes: sizeBytes,
      uploaded: uploaded ?? this.uploaded,
    );
  }

  @override
  List<Object?> get props => [localFilePath, duration, sizeBytes, uploaded];
}

final class ProfileOnboardingDraft extends Equatable {
  const ProfileOnboardingDraft({
    required this.ownerUserId,
    required this.updatedAt,
    this.currentStep = OnboardingStep.candidateType,
    this.candidateType,
    this.pledgeAcceptedTerms = false,
    this.birthDate,
    this.firstName,
    this.lastName,
    this.educationLevelId,
    this.heightCm,
    this.weightKg,
    this.regionId,
    this.districtId,
    this.profileServerId,
    this.photos = const [],
    this.mainPhotoServerId,
    this.voiceIntroMetadata,
    this.faceVerificationStatus = FaceVerificationStatus.notStarted,
    this.schemaVersion = 1,
  });

  final String ownerUserId;
  final OnboardingStep currentStep;
  final CandidateType? candidateType;
  final bool pledgeAcceptedTerms;
  final DateTime? birthDate;
  final String? firstName;
  final String? lastName;
  final String? educationLevelId;
  final int? heightCm;
  final int? weightKg;
  final String? regionId;
  final String? districtId;
  final String? profileServerId;
  final List<OnboardingPhotoDraft> photos;
  final String? mainPhotoServerId;
  final VoiceIntroMetadata? voiceIntroMetadata;
  final FaceVerificationStatus faceVerificationStatus;
  final DateTime updatedAt;
  final int schemaVersion;

  bool get hasQuestionnaire =>
      candidateType != null &&
      pledgeAcceptedTerms &&
      birthDate != null &&
      (firstName?.trim().isNotEmpty ?? false) &&
      (lastName?.trim().isNotEmpty ?? false) &&
      (educationLevelId?.isNotEmpty ?? false) &&
      heightCm != null &&
      (regionId?.isNotEmpty ?? false) &&
      (districtId?.isNotEmpty ?? false);

  bool get hasUploadedPhotos =>
      photos.isNotEmpty &&
      photos.every((photo) => photo.uploadStatus == PhotoUploadStatus.uploaded);

  bool get hasMainPhoto => mainPhotoServerId?.isNotEmpty ?? false;

  ProfileOnboardingDraft copyWith({
    OnboardingStep? currentStep,
    CandidateType? candidateType,
    bool? pledgeAcceptedTerms,
    DateTime? birthDate,
    String? firstName,
    String? lastName,
    String? educationLevelId,
    int? heightCm,
    int? weightKg,
    String? regionId,
    String? districtId,
    String? profileServerId,
    List<OnboardingPhotoDraft>? photos,
    String? mainPhotoServerId,
    VoiceIntroMetadata? voiceIntroMetadata,
    FaceVerificationStatus? faceVerificationStatus,
    DateTime? updatedAt,
    bool clearDistrict = false,
    bool clearMainPhoto = false,
    bool clearVoiceIntro = false,
  }) {
    return ProfileOnboardingDraft(
      ownerUserId: ownerUserId,
      currentStep: currentStep ?? this.currentStep,
      candidateType: candidateType ?? this.candidateType,
      pledgeAcceptedTerms: pledgeAcceptedTerms ?? this.pledgeAcceptedTerms,
      birthDate: birthDate ?? this.birthDate,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      educationLevelId: educationLevelId ?? this.educationLevelId,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      regionId: regionId ?? this.regionId,
      districtId: clearDistrict ? null : districtId ?? this.districtId,
      profileServerId: profileServerId ?? this.profileServerId,
      photos: photos ?? this.photos,
      mainPhotoServerId: clearMainPhoto
          ? null
          : mainPhotoServerId ?? this.mainPhotoServerId,
      voiceIntroMetadata: clearVoiceIntro
          ? null
          : voiceIntroMetadata ?? this.voiceIntroMetadata,
      faceVerificationStatus:
          faceVerificationStatus ?? this.faceVerificationStatus,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
      schemaVersion: schemaVersion,
    );
  }

  @override
  List<Object?> get props => [
    ownerUserId,
    currentStep,
    candidateType,
    pledgeAcceptedTerms,
    birthDate,
    firstName,
    lastName,
    educationLevelId,
    heightCm,
    weightKg,
    regionId,
    districtId,
    profileServerId,
    photos,
    mainPhotoServerId,
    voiceIntroMetadata,
    faceVerificationStatus,
    updatedAt,
    schemaVersion,
  ];
}
