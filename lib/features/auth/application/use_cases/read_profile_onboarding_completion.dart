import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/security/auth_session_manager.dart';

final class ReadProfileOnboardingCompletionUseCase {
  const ReadProfileOnboardingCompletionUseCase(this._sessionManager);

  final AuthSessionManager _sessionManager;

  Future<Either<Failure, bool?>> call() async {
    try {
      return Right<Failure, bool?>(
        await _sessionManager.readProfileOnboardingCompleted(),
      );
    } catch (_) {
      return const Left<Failure, bool?>(Failure.unknown());
    }
  }
}
