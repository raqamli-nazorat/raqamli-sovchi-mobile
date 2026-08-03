import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/pin_repository.dart';

final class CreatePinUseCase {
  const CreatePinUseCase(this._repository);

  final PinRepository _repository;

  Future<Either<Failure, void>> call(String pin) => _repository.savePin(pin);
}
