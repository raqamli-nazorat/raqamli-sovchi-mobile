import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/pin_repository.dart';

final class VerifyPinUseCase {
  const VerifyPinUseCase(this._repository);

  final PinRepository _repository;

  Future<Either<Failure, bool>> call(String pin) => _repository.verifyPin(pin);
}
