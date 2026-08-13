import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/profile_onboarding_draft.dart';

abstract interface class OnboardingDraftRepository {
  Future<Either<Failure, ProfileOnboardingDraft?>> load(String ownerUserId);

  Future<Either<Failure, void>> save(ProfileOnboardingDraft draft);

  Future<Either<Failure, void>> clear();
}
