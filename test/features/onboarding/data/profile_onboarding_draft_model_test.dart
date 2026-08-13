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
      regionId: 'region-1',
      districtId: 'district-1',
      healthStatusId: 'health-1',
      maritalStatusId: 'marital-1',
      childrenCount: 2,
      childrenNotLivingWithMe: true,
      aboutMe: 'Oila qadriyatlari muhim.',
      latitude: 41.3111,
      longitude: 69.2797,
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
    expect(restored.healthStatusId, 'health-1');
    expect(restored.maritalStatusId, 'marital-1');
    expect(restored.childrenCount, 2);
    expect(restored.childrenNotLivingWithMe, isTrue);
    expect(restored.aboutMe, 'Oila qadriyatlari muhim.');
    expect(restored.latitude, 41.3111);
    expect(restored.longitude, 69.2797);
  });

  test('representative draft JSON preserves separate people and consent', () {
    final draft = ProfileOnboardingDraft(
      ownerUserId: 'user-1',
      candidateType: CandidateType.representative,
      representedCandidateType: CandidateType.groom,
      representativeFirstName: 'Zulfiya',
      representativeLastName: 'Muxtorova',
      kinshipId: 'kinship-1',
      representativeInfoId: 'representative-1',
      candidateContact: '+998901234567',
      candidateUsesApp: true,
      consentRequestSent: true,
      representativeAccuracyAccepted: true,
      representativePrivacyAccepted: true,
      representativeInterestAccepted: true,
      firstName: 'Safarali',
      lastName: 'Muxtorov',
      currentStep: OnboardingStep.representativePledge,
      updatedAt: DateTime.utc(2026, 8, 13),
    );

    final restored = ProfileOnboardingDraftModel.fromJson(
      ProfileOnboardingDraftModel(draft).toJson(),
    ).draft;

    expect(restored, draft);
    expect(restored.hasAcceptedRepresentativeResponsibility, isTrue);
  });
}
