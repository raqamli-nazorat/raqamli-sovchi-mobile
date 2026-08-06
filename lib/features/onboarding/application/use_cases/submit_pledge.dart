import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/user_pledge.dart';
import '../../domain/repositories/onboarding_repository.dart';

final class SubmitPledgeUseCase {
  const SubmitPledgeUseCase(this._repository);

  final OnboardingRepository _repository;

  Future<Either<Failure, UserPledge>> call({
    required String userId,
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  }) {
    return _repository.submitPledge(
      userId: userId,
      acceptedTerms: acceptedTerms,
      hasSeriousBadge: hasSeriousBadge,
    );
  }
}
