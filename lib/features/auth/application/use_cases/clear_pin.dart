import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/pin_repository.dart';

final class ClearPinUseCase {
  const ClearPinUseCase(this._repository);

  final PinRepository _repository;

  Future<Either<Failure, void>> call() => _repository.clearPin();
}
