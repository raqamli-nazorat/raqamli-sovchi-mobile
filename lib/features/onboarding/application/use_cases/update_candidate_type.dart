import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/onboarding_repository.dart';

final class UpdateCandidateTypeUseCase {
  const UpdateCandidateTypeUseCase(this._repository);

  final OnboardingRepository _repository;

  Future<Either<Failure, void>> call(String candidateType) {
    return _repository.updateCandidateType(candidateType);
  }
}
