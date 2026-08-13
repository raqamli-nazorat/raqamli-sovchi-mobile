import '../../domain/entities/candidate_type.dart';
import '../../domain/entities/profile_onboarding_draft.dart';

final class ProfileOnboardingDraftModel {
  const ProfileOnboardingDraftModel(this.draft);

  factory ProfileOnboardingDraftModel.fromJson(Map<String, dynamic> json) {
    final photos = (json['photos'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((value) => _photoFromJson(_map(value)))
        .toList(growable: false);
    final voiceJson = json['voiceIntroMetadata'];
    final candidateValue = json['candidateType']?.toString();
    return ProfileOnboardingDraftModel(
      ProfileOnboardingDraft(
        ownerUserId: (json['ownerUserId'] ?? '').toString(),
        currentStep: OnboardingStep.values.firstWhere(
          (step) => step.name == json['currentStep'],
          orElse: () => OnboardingStep.candidateType,
        ),
        candidateType: CandidateType.values
            .where((type) => type.apiValue == candidateValue)
            .firstOrNull,
        representativeFirstName: json['representativeFirstName']?.toString(),
        representativeLastName: json['representativeLastName']?.toString(),
        kinshipId: json['kinshipId']?.toString(),
        representedCandidateType: CandidateType.values
            .where(
              (type) =>
                  type.apiValue == json['representedCandidateType']?.toString(),
            )
            .firstOrNull,
        representativeInfoId: json['representativeInfoId']?.toString(),
        candidateContact: json['candidateContact']?.toString(),
        candidateUsesApp: json['candidateUsesApp'] == true,
        consentRequestSent: json['consentRequestSent'] == true,
        representativeAccuracyAccepted:
            json['representativeAccuracyAccepted'] == true,
        representativePrivacyAccepted:
            json['representativePrivacyAccepted'] == true,
        representativeInterestAccepted:
            json['representativeInterestAccepted'] == true,
        pledgeAcceptedTerms: json['pledgeAcceptedTerms'] == true,
        birthDate: DateTime.tryParse((json['birthDate'] ?? '').toString()),
        firstName: json['firstName']?.toString(),
        lastName: json['lastName']?.toString(),
        patronymic: json['patronymic']?.toString(),
        educationLevelId: json['educationLevelId']?.toString(),
        heightCm: int.tryParse((json['heightCm'] ?? '').toString()),
        weightKg: int.tryParse((json['weightKg'] ?? '').toString()),
        regionId: json['regionId']?.toString(),
        districtId: json['districtId']?.toString(),
        healthStatusId: json['healthStatusId']?.toString(),
        maritalStatusId: json['maritalStatusId']?.toString(),
        childrenCount:
            int.tryParse((json['childrenCount'] ?? 0).toString()) ?? 0,
        childrenNotLivingWithMe: json['childrenNotLivingWithMe'] == true,
        profileServerId: json['profileServerId']?.toString(),
        photos: photos,
        mainPhotoServerId: json['mainPhotoServerId']?.toString(),
        voiceIntroMetadata: voiceJson is Map
            ? _voiceFromJson(_map(voiceJson))
            : null,
        faceVerificationStatus: FaceVerificationStatus.values.firstWhere(
          (status) => status.name == json['faceVerificationStatus'],
          orElse: () => FaceVerificationStatus.notStarted,
        ),
        aboutMe: json['aboutMe']?.toString(),
        latitude: double.tryParse((json['latitude'] ?? '').toString()),
        longitude: double.tryParse((json['longitude'] ?? '').toString()),
        updatedAt:
            DateTime.tryParse((json['updatedAt'] ?? '').toString())?.toUtc() ??
            DateTime.now().toUtc(),
        schemaVersion:
            int.tryParse((json['schemaVersion'] ?? 1).toString()) ?? 1,
      ),
    );
  }

  final ProfileOnboardingDraft draft;

  Map<String, dynamic> toJson() {
    return {
      'ownerUserId': draft.ownerUserId,
      'currentStep': draft.currentStep.name,
      'candidateType': draft.candidateType?.apiValue,
      'representativeFirstName': draft.representativeFirstName,
      'representativeLastName': draft.representativeLastName,
      'kinshipId': draft.kinshipId,
      'representedCandidateType': draft.representedCandidateType?.apiValue,
      'representativeInfoId': draft.representativeInfoId,
      'candidateContact': draft.candidateContact,
      'candidateUsesApp': draft.candidateUsesApp,
      'consentRequestSent': draft.consentRequestSent,
      'representativeAccuracyAccepted': draft.representativeAccuracyAccepted,
      'representativePrivacyAccepted': draft.representativePrivacyAccepted,
      'representativeInterestAccepted': draft.representativeInterestAccepted,
      'pledgeAcceptedTerms': draft.pledgeAcceptedTerms,
      'birthDate': draft.birthDate?.toUtc().toIso8601String(),
      'firstName': draft.firstName,
      'lastName': draft.lastName,
      'patronymic': draft.patronymic,
      'educationLevelId': draft.educationLevelId,
      'heightCm': draft.heightCm,
      'weightKg': draft.weightKg,
      'regionId': draft.regionId,
      'districtId': draft.districtId,
      'healthStatusId': draft.healthStatusId,
      'maritalStatusId': draft.maritalStatusId,
      'childrenCount': draft.childrenCount,
      'childrenNotLivingWithMe': draft.childrenNotLivingWithMe,
      'profileServerId': draft.profileServerId,
      'photos': draft.photos.map(_photoToJson).toList(growable: false),
      'mainPhotoServerId': draft.mainPhotoServerId,
      'voiceIntroMetadata': draft.voiceIntroMetadata == null
          ? null
          : _voiceToJson(draft.voiceIntroMetadata!),
      'faceVerificationStatus': draft.faceVerificationStatus.name,
      'aboutMe': draft.aboutMe,
      'latitude': draft.latitude,
      'longitude': draft.longitude,
      'updatedAt': draft.updatedAt.toUtc().toIso8601String(),
      'schemaVersion': draft.schemaVersion,
    };
  }
}

Map<String, dynamic> _photoToJson(OnboardingPhotoDraft photo) => {
  'localFilePath': photo.localFilePath,
  'serverId': photo.serverId,
  'imageUrl': photo.imageUrl,
  'order': photo.order,
  'isMain': photo.isMain,
  'uploadStatus': photo.uploadStatus.name,
  'uploadFailure': photo.uploadFailure,
};

OnboardingPhotoDraft _photoFromJson(Map<String, dynamic> json) {
  return OnboardingPhotoDraft(
    localFilePath: (json['localFilePath'] ?? '').toString(),
    serverId: json['serverId']?.toString(),
    imageUrl: json['imageUrl']?.toString(),
    order: int.tryParse((json['order'] ?? 1).toString()) ?? 1,
    isMain: json['isMain'] == true,
    uploadStatus: PhotoUploadStatus.values.firstWhere(
      (status) => status.name == json['uploadStatus'],
      orElse: () => PhotoUploadStatus.pending,
    ),
    uploadFailure: json['uploadFailure']?.toString(),
  );
}

Map<String, dynamic> _voiceToJson(VoiceIntroMetadata voice) => {
  'localFilePath': voice.localFilePath,
  'durationMilliseconds': voice.duration.inMilliseconds,
  'sizeBytes': voice.sizeBytes,
  'uploaded': voice.uploaded,
};

VoiceIntroMetadata _voiceFromJson(Map<String, dynamic> json) {
  return VoiceIntroMetadata(
    localFilePath: (json['localFilePath'] ?? '').toString(),
    duration: Duration(
      milliseconds:
          int.tryParse((json['durationMilliseconds'] ?? 0).toString()) ?? 0,
    ),
    sizeBytes: int.tryParse((json['sizeBytes'] ?? 0).toString()) ?? 0,
    uploaded: json['uploaded'] == true,
  );
}

Map<String, dynamic> _map(Map value) {
  return value.map((key, item) => MapEntry(key.toString(), item));
}
