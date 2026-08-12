import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/security/auth_session_manager.dart';

final class ClearAuthSessionUseCase {
  const ClearAuthSessionUseCase(this._sessionManager);

  final AuthSessionManager _sessionManager;

  Future<Either<Failure, void>> call() async {
    try {
      await _sessionManager.clearAll();
      return const Right<Failure, void>(null);
    } catch (_) {
      return const Left<Failure, void>(Failure.unknown());
    }
  }
}
