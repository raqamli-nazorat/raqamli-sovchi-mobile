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
  healthStatus,
  maritalStatus,
  photos,
  mainPhoto,
  faceVerification,
  aboutMe,
  voiceIntro,
  locationPermission,
  success,
  profileReady,
  representativeIntro,
  representativeIdentity,
  representativeRelation,
  representativeCandidateType,
  representativeContact,
  representativeConsentSent,
  representativePledge,
  representativeReady,
}

const standardOnboardingSteps = <OnboardingStep>[
  OnboardingStep.candidateType,
  OnboardingStep.pledge,
  OnboardingStep.identity,
  OnboardingStep.birthDate,
  OnboardingStep.education,
  OnboardingStep.height,
  OnboardingStep.location,
  OnboardingStep.healthStatus,
  OnboardingStep.maritalStatus,
  OnboardingStep.photos,
  OnboardingStep.mainPhoto,
  OnboardingStep.faceVerification,
  OnboardingStep.aboutMe,
  OnboardingStep.voiceIntro,
  OnboardingStep.locationPermission,
  OnboardingStep.success,
  OnboardingStep.profileReady,
];

const representativeOnboardingSteps = <OnboardingStep>[
  OnboardingStep.candidateType,
  OnboardingStep.representativeIntro,
  OnboardingStep.representativeIdentity,
  OnboardingStep.representativeRelation,
  OnboardingStep.representativeCandidateType,
  OnboardingStep.identity,
  OnboardingStep.birthDate,
  OnboardingStep.education,
  OnboardingStep.height,
  OnboardingStep.location,
  OnboardingStep.healthStatus,
  OnboardingStep.maritalStatus,
  OnboardingStep.photos,
  OnboardingStep.mainPhoto,
  OnboardingStep.aboutMe,
  OnboardingStep.voiceIntro,
  OnboardingStep.locationPermission,
  OnboardingStep.representativeContact,
  OnboardingStep.representativeConsentSent,
  OnboardingStep.representativePledge,
  OnboardingStep.representativeReady,
];

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
    this.representativeFirstName,
    this.representativeLastName,
    this.kinshipId,
    this.representedCandidateType,
    this.representativeInfoId,
    this.candidateContact,
    this.candidateUsesApp = false,
    this.consentRequestSent = false,
    this.representativeAccuracyAccepted = false,
    this.representativePrivacyAccepted = false,
    this.representativeInterestAccepted = false,
    this.pledgeAcceptedTerms = false,
    this.birthDate,
    this.firstName,
    this.lastName,
    this.patronymic,
    this.educationLevelId,
    this.heightCm,
    this.weightKg,
    this.regionId,
    this.districtId,
    this.healthStatusId,
    this.maritalStatusId,
    this.childrenCount = 0,
    this.childrenNotLivingWithMe = false,
    this.profileServerId,
    this.photos = const [],
    this.mainPhotoServerId,
    this.voiceIntroMetadata,
    this.faceVerificationStatus = FaceVerificationStatus.notStarted,
    this.aboutMe,
    this.latitude,
    this.longitude,
    this.schemaVersion = 1,
  });

  final String ownerUserId;
  final OnboardingStep currentStep;
  final CandidateType? candidateType;
  final String? representativeFirstName;
  final String? representativeLastName;
  final String? kinshipId;
  final CandidateType? representedCandidateType;
  final String? representativeInfoId;
  final String? candidateContact;
  final bool candidateUsesApp;
  final bool consentRequestSent;
  final bool representativeAccuracyAccepted;
  final bool representativePrivacyAccepted;
  final bool representativeInterestAccepted;
  final bool pledgeAcceptedTerms;
  final DateTime? birthDate;
  final String? firstName;
  final String? lastName;
  final String? patronymic;
  final String? educationLevelId;
  final int? heightCm;
  final int? weightKg;
  final String? regionId;
  final String? districtId;
  final String? healthStatusId;
  final String? maritalStatusId;
  final int childrenCount;
  final bool childrenNotLivingWithMe;
  final String? profileServerId;
  final List<OnboardingPhotoDraft> photos;
  final String? mainPhotoServerId;
  final VoiceIntroMetadata? voiceIntroMetadata;
  final FaceVerificationStatus faceVerificationStatus;
  final String? aboutMe;
  final double? latitude;
  final double? longitude;
  final DateTime updatedAt;
  final int schemaVersion;

  bool get hasQuestionnaire =>
      candidateType != null &&
      (candidateType != CandidateType.representative ||
          ((representativeFirstName?.trim().isNotEmpty ?? false) &&
              (representativeLastName?.trim().isNotEmpty ?? false) &&
              (kinshipId?.isNotEmpty ?? false) &&
              (representedCandidateType == CandidateType.groom ||
                  representedCandidateType == CandidateType.bride))) &&
      (candidateType == CandidateType.representative || pledgeAcceptedTerms) &&
      birthDate != null &&
      (firstName?.trim().isNotEmpty ?? false) &&
      (lastName?.trim().isNotEmpty ?? false) &&
      (patronymic?.trim().isNotEmpty ?? false) &&
      (educationLevelId?.isNotEmpty ?? false) &&
      heightCm != null &&
      (regionId?.isNotEmpty ?? false) &&
      (districtId?.isNotEmpty ?? false) &&
      (healthStatusId?.isNotEmpty ?? false) &&
      (maritalStatusId?.isNotEmpty ?? false);

  bool get hasUploadedPhotos =>
      photos.isNotEmpty &&
      photos.every((photo) => photo.uploadStatus == PhotoUploadStatus.uploaded);

  bool get hasMainPhoto => mainPhotoServerId?.isNotEmpty ?? false;

  bool get hasAcceptedRepresentativeResponsibility =>
      representativeAccuracyAccepted &&
      representativePrivacyAccepted &&
      representativeInterestAccepted;

  ProfileOnboardingDraft copyWith({
    OnboardingStep? currentStep,
    CandidateType? candidateType,
    String? representativeFirstName,
    String? representativeLastName,
    String? kinshipId,
    CandidateType? representedCandidateType,
    String? representativeInfoId,
    String? candidateContact,
    bool? candidateUsesApp,
    bool? consentRequestSent,
    bool? representativeAccuracyAccepted,
    bool? representativePrivacyAccepted,
    bool? representativeInterestAccepted,
    bool? pledgeAcceptedTerms,
    DateTime? birthDate,
    String? firstName,
    String? lastName,
    String? patronymic,
    String? educationLevelId,
    int? heightCm,
    int? weightKg,
    String? regionId,
    String? districtId,
    String? healthStatusId,
    String? maritalStatusId,
    int? childrenCount,
    bool? childrenNotLivingWithMe,
    String? profileServerId,
    List<OnboardingPhotoDraft>? photos,
    String? mainPhotoServerId,
    VoiceIntroMetadata? voiceIntroMetadata,
    FaceVerificationStatus? faceVerificationStatus,
    String? aboutMe,
    double? latitude,
    double? longitude,
    DateTime? updatedAt,
    bool clearDistrict = false,
    bool clearMainPhoto = false,
    bool clearVoiceIntro = false,
    bool clearAboutMe = false,
    bool clearLocation = false,
    bool clearCandidateContact = false,
  }) {
    return ProfileOnboardingDraft(
      ownerUserId: ownerUserId,
      currentStep: currentStep ?? this.currentStep,
      candidateType: candidateType ?? this.candidateType,
      representativeFirstName:
          representativeFirstName ?? this.representativeFirstName,
      representativeLastName:
          representativeLastName ?? this.representativeLastName,
      kinshipId: kinshipId ?? this.kinshipId,
      representedCandidateType:
          representedCandidateType ?? this.representedCandidateType,
      representativeInfoId: representativeInfoId ?? this.representativeInfoId,
      candidateContact: clearCandidateContact
          ? null
          : candidateContact ?? this.candidateContact,
      candidateUsesApp: candidateUsesApp ?? this.candidateUsesApp,
      consentRequestSent: consentRequestSent ?? this.consentRequestSent,
      representativeAccuracyAccepted:
          representativeAccuracyAccepted ?? this.representativeAccuracyAccepted,
      representativePrivacyAccepted:
          representativePrivacyAccepted ?? this.representativePrivacyAccepted,
      representativeInterestAccepted:
          representativeInterestAccepted ?? this.representativeInterestAccepted,
      pledgeAcceptedTerms: pledgeAcceptedTerms ?? this.pledgeAcceptedTerms,
      birthDate: birthDate ?? this.birthDate,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      patronymic: patronymic ?? this.patronymic,
      educationLevelId: educationLevelId ?? this.educationLevelId,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      regionId: regionId ?? this.regionId,
      districtId: clearDistrict ? null : districtId ?? this.districtId,
      healthStatusId: healthStatusId ?? this.healthStatusId,
      maritalStatusId: maritalStatusId ?? this.maritalStatusId,
      childrenCount: childrenCount ?? this.childrenCount,
      childrenNotLivingWithMe:
          childrenNotLivingWithMe ?? this.childrenNotLivingWithMe,
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
      aboutMe: clearAboutMe ? null : aboutMe ?? this.aboutMe,
      latitude: clearLocation ? null : latitude ?? this.latitude,
      longitude: clearLocation ? null : longitude ?? this.longitude,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
      schemaVersion: schemaVersion,
    );
  }

  @override
  List<Object?> get props => [
    ownerUserId,
    currentStep,
    candidateType,
    representativeFirstName,
    representativeLastName,
    kinshipId,
    representedCandidateType,
    representativeInfoId,
    candidateContact,
    candidateUsesApp,
    consentRequestSent,
    representativeAccuracyAccepted,
    representativePrivacyAccepted,
    representativeInterestAccepted,
    pledgeAcceptedTerms,
    birthDate,
    firstName,
    lastName,
    patronymic,
    educationLevelId,
    heightCm,
    weightKg,
    regionId,
    districtId,
    healthStatusId,
    maritalStatusId,
    childrenCount,
    childrenNotLivingWithMe,
    profileServerId,
    photos,
    mainPhotoServerId,
    voiceIntroMetadata,
    faceVerificationStatus,
    aboutMe,
    latitude,
    longitude,
    updatedAt,
    schemaVersion,
  ];
}
