import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/auth/data/data_sources/google_oauth_provider.dart';

void main() {
  test(
    'returns configuration failure when Google client ID is missing',
    () async {
      final result = await GoogleSignInOAuthProvider(
        serverClientId: '',
        signIn: _FakeGoogleSignInFacade(idToken: 'unused'),
      ).authorize();

      result.fold(
        (failure) => expect(failure.type, FailureType.configuration),
        (_) => fail('Expected a configuration failure.'),
      );
    },
  );

  test('returns id token from Google Sign-In authentication', () async {
    final facade = _FakeGoogleSignInFacade(idToken: 'google-id-token');
    final result = await GoogleSignInOAuthProvider(
      serverClientId: 'web-client-id.apps.googleusercontent.com',
      signIn: facade,
    ).authorize();

    result.fold((_) => fail('Expected Google authorization result.'), (
      authorization,
    ) {
      expect(authorization.idToken, 'google-id-token');
      expect(
        facade.lastServerClientId,
        'web-client-id.apps.googleusercontent.com',
      );
      expect(facade.lastScopes, ['openid', 'email', 'profile']);
    });
  });

  test('maps missing id token to configuration failure', () async {
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
  _FakeGoogleSignInFacade({this.idToken});

  final String? idToken;
  String? lastServerClientId;
  List<String>? lastScopes;

  @override
  Future<String?> requestIdToken({
    required String serverClientId,
    required List<String> scopes,
  }) async {
    lastServerClientId = serverClientId;
    lastScopes = scopes;
    return idToken;
  }
}
