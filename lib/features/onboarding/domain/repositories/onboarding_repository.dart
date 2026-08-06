import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user_pledge.dart';

abstract interface class OnboardingRepository {
  Future<Either<Failure, void>> updateCandidateType(String candidateType);

  Future<Either<Failure, UserPledge>> submitPledge({
    required String userId,
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  });
}
