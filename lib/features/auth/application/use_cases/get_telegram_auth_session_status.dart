import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/telegram_auth_status.dart';
import '../../domain/repositories/auth_repository.dart';

final class GetTelegramAuthSessionStatusUseCase {
  const GetTelegramAuthSessionStatusUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, TelegramAuthStatus>> call(String sessionId) {
    return _repository.getTelegramAuthSessionStatus(sessionId);
  }
}
