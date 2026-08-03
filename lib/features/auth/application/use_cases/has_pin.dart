import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/pin_repository.dart';

final class HasPinUseCase {
  const HasPinUseCase(this._repository);

  final PinRepository _repository;

  Future<Either<Failure, bool>> call() => _repository.hasPin();
}
