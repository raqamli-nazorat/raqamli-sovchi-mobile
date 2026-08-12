import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/security/auth_session_manager.dart';

final class CommitPendingAuthSessionUseCase {
  const CommitPendingAuthSessionUseCase(this._sessionManager);

  final AuthSessionManager _sessionManager;

  Future<Either<Failure, void>> call() async {
    try {
      await _sessionManager.commitPendingTokens();
      return const Right<Failure, void>(null);
    } on StateError {
      return const Left<Failure, void>(Failure.validation());
    } catch (_) {
      return const Left<Failure, void>(Failure.unknown());
    }
  }
}
