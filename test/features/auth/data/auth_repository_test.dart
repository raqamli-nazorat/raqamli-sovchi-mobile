import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';
import 'package:raqamli_sovchi/features/auth/data/data_sources/auth_data_source.dart';
import 'package:raqamli_sovchi/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  test('temporary repository maps OTP session to domain session', () async {
    final repository = AuthRepositoryImpl(
      TemporaryAuthDataSource(_MemoryTokenStore()),
    );

    await repository.requestPhoneOtp('+998901234567');
    final result = await repository.verifyPhoneOtp(
      phoneNumber: '+998901234567',
      otp: '1234',
    );

    expect(
      result.fold((_) => null, (session) => session.displayName),
      'Raqamli Sovchi',
    );
  });
}

final class _MemoryTokenStore implements TokenStore {
  String? _accessToken;

  @override
  Future<String?> readAccessToken() async => _accessToken;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
  }

  @override
  Future<void> clear() async {
    _accessToken = null;
  }
}
