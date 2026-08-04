import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/security/biometric_auth_service.dart';
import 'package:raqamli_sovchi/core/security/secure_storage.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/authenticate_biometric.dart';

void main() {
  test('biometric success unlocks only when access token exists', () async {
    final result = await AuthenticateBiometricUseCase(
      _FakeBiometricAuthService(BiometricAuthResult.success),
      SecureTokenStore(_MemorySecureStorage('access')),
    )();

    expect(
      result.fold((_) => null, (outcome) => outcome),
      BiometricUnlockOutcome.authenticated,
    );
  });

  test('biometric success without token returns no-session outcome', () async {
    final result = await AuthenticateBiometricUseCase(
      _FakeBiometricAuthService(BiometricAuthResult.success),
      SecureTokenStore(_MemorySecureStorage(null)),
    )();

    expect(
      result.fold((_) => null, (outcome) => outcome),
      BiometricUnlockOutcome.noSession,
    );
  });

  test('biometric cancellation keeps PIN fallback available', () async {
    final result = await AuthenticateBiometricUseCase(
      _FakeBiometricAuthService(BiometricAuthResult.userCanceled),
      SecureTokenStore(_MemorySecureStorage('access')),
    )();

    expect(
      result.fold((_) => null, (outcome) => outcome),
      BiometricUnlockOutcome.userCanceled,
    );
  });
}

final class _FakeBiometricAuthService implements BiometricAuthService {
  _FakeBiometricAuthService(this.result);

  final BiometricAuthResult result;

  @override
  Future<BiometricAvailability> checkAvailability() async =>
      BiometricAvailability.available;

  @override
  Future<BiometricAuthResult> authenticate() async => result;
}

final class _MemorySecureStorage implements SecureStorage {
  _MemorySecureStorage(this.accessToken);

  final String? accessToken;

  @override
  Future<String?> read({required String key}) async =>
      key == 'auth.access_token' ? accessToken : null;

  @override
  Future<void> write({required String key, required String value}) async {}

  @override
  Future<void> delete({required String key}) async {}
}
