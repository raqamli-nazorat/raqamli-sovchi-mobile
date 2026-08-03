import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';

final class ObtainTokenUseCase {
  const ObtainTokenUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Session>> call({
    required String phoneNumber,
    required String password,
  }) {
    return _repository.obtainToken(
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}
