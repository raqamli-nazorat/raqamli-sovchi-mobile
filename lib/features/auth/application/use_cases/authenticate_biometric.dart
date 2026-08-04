import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/security/biometric_auth_service.dart';
import '../../../../core/security/token_store.dart';

enum BiometricUnlockOutcome { authenticated, noSession, userCanceled, failed }

final class AuthenticateBiometricUseCase {
  const AuthenticateBiometricUseCase(this._service, this._tokenStore);

  final BiometricAuthService _service;
  final TokenStore _tokenStore;

  Future<Either<Failure, BiometricUnlockOutcome>> call() async {
    final result = await _service.authenticate();
    if (result != BiometricAuthResult.success) {
      return Right<Failure, BiometricUnlockOutcome>(switch (result) {
        BiometricAuthResult.userCanceled => BiometricUnlockOutcome.userCanceled,
        BiometricAuthResult.lockedOut ||
        BiometricAuthResult.failed ||
        BiometricAuthResult.unavailable => BiometricUnlockOutcome.failed,
        BiometricAuthResult.success => BiometricUnlockOutcome.authenticated,
      });
    }

    try {
      final token = await _tokenStore.readAccessToken();
      return Right<Failure, BiometricUnlockOutcome>(
        token == null || token.isEmpty
            ? BiometricUnlockOutcome.noSession
            : BiometricUnlockOutcome.authenticated,
      );
    } on Object catch (error) {
      return Left<Failure, BiometricUnlockOutcome>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }
}
