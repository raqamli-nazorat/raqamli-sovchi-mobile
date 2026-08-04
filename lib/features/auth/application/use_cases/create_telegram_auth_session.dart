import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/telegram_auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

final class CreateTelegramAuthSessionUseCase {
  const CreateTelegramAuthSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, TelegramAuthSession>> call() {
    return _repository.createTelegramAuthSession();
  }
}
