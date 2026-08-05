import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/auth/data/data_sources/google_oauth_provider.dart';

void main() {
  test(
    'returns configuration failure when Google client ID is missing',
    () async {
      final result = await GoogleSignInOAuthProvider(
        serverClientId: '',
        signIn: _FakeGoogleSignInFacade(serverAuthCode: 'unused'),
      ).authorize();

      result.fold(
        (failure) => expect(failure.type, FailureType.configuration),
        (_) => fail('Expected a configuration failure.'),
      );
    },
  );

  test('returns authorization code from Google Sign-In server auth', () async {
    final facade = _FakeGoogleSignInFacade(serverAuthCode: 'server-code');
    final result = await GoogleSignInOAuthProvider(
      serverClientId: 'web-client-id.apps.googleusercontent.com',
      signIn: facade,
    ).authorize();

    result.fold((_) => fail('Expected Google authorization result.'), (
      authorization,
    ) {
      expect(authorization.authorizationCode, 'server-code');
      expect(
        facade.lastServerClientId,
        'web-client-id.apps.googleusercontent.com',
      );
      expect(facade.lastScopes, ['openid', 'email', 'profile']);
    });
  });

  test('maps missing server auth code to configuration failure', () async {
    final result = await GoogleSignInOAuthProvider(
      serverClientId: 'web-client-id.apps.googleusercontent.com',
      signIn: _FakeGoogleSignInFacade(),
    ).authorize();

    result.fold(
      (failure) => expect(failure.type, FailureType.configuration),
      (_) => fail('Expected a configuration failure.'),
    );
  });
}

final class _FakeGoogleSignInFacade implements GoogleSignInFacade {
  _FakeGoogleSignInFacade({this.serverAuthCode});

  final String? serverAuthCode;
  String? lastServerClientId;
  List<String>? lastScopes;

  @override
  Future<String?> requestServerAuthCode({
    required String serverClientId,
    required List<String> scopes,
  }) async {
    lastServerClientId = serverClientId;
    lastScopes = scopes;
    return serverAuthCode;
  }
}
