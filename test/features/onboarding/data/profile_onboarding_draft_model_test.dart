import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/onboarding/data/models/profile_onboarding_draft_model.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/candidate_type.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/profile_onboarding_draft.dart';

void main() {
  test('draft JSON round trip keeps owner, progress, and photo invariants', () {
    final draft = ProfileOnboardingDraft(
      ownerUserId: 'user-1',
      candidateType: CandidateType.bride,
      pledgeAcceptedTerms: true,
      currentStep: OnboardingStep.photos,
      birthDate: DateTime.utc(2000, 2, 29),
      firstName: 'Madina',
      lastName: 'Karimova',
      patronymic: 'Baxtiyor qizi',
      heightCm: 179,
      weightKg: 68,
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
      updatedAt: DateTime.utc(2026, 8, 9),
    );

    final restored = ProfileOnboardingDraftModel.fromJson(
      ProfileOnboardingDraftModel(draft).toJson(),
    ).draft;

    expect(restored, draft);
    expect(restored.weightKg, 68);
    expect(restored.patronymic, 'Baxtiyor qizi');
  });
}
