import '../../domain/entities/profile_onboarding_draft.dart';

enum FaceQualityIssue { noFace, multipleFaces, eyesNotVisible, pose, tooSmall }

final class FaceQualityCheck {
  const FaceQualityCheck.valid() : issue = null;

  const FaceQualityCheck.invalid(this.issue);

  final FaceQualityIssue? issue;

  bool get isValid => issue == null;
}

abstract interface class OnboardingMediaService {
  Future<String?> pickAndPrepareProfilePhoto();

  Future<String?> captureAndPrepareSelfie();

  Future<String> prepareSelfie(String sourcePath);

  Future<FaceQualityCheck> checkSelfieQuality(String localFilePath);

  Future<void> startVoiceRecording();

  Future<VoiceIntroMetadata?> stopVoiceRecording();

  Future<void> cancelVoiceRecording();

  Future<void> playVoice(String localFilePath);

  Future<void> stopVoicePlayback();

  Future<void> deletePrivateFile(String localFilePath);

  Future<void> dispose();
}

final class OnboardingMediaValidationException implements Exception {
  const OnboardingMediaValidationException(this.reason);

  final String reason;
}
