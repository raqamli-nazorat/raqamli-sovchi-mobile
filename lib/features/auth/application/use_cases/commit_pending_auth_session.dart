import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/security/auth_session_manager.dart';

final class CommitPendingAuthSessionUseCase {
  const CommitPendingAuthSessionUseCase(this._sessionManager);

  final AuthSessionManager _sessionManager;

  Future<Either<Failure, void>> call({
    bool profileOnboardingCompleted = true,
  }) async {
    try {
      await _sessionManager.commitPendingTokens(
        profileOnboardingCompleted: profileOnboardingCompleted,
      );
      return const Right<Failure, void>(null);
    } catch (_) {
      return const Left<Failure, void>(Failure.unknown());
    }
  }
}
