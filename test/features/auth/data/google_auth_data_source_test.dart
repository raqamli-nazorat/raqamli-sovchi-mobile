import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';
import 'package:raqamli_sovchi/features/auth/data/data_sources/google_auth_data_source.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/google_authorization_result.dart';

void main() {
  test('sends id token without backend auth header', () async {
    final client = _FakeApiClient();
    final tokenStore = _FakeTokenStore();
    final dataSource = RemoteGoogleAuthDataSource(
      client: client,
      tokenStore: tokenStore,
    );

    final session = await dataSource.signInWithGoogle(
      credential: const GoogleAuthorizationResult(idToken: 'google-id-token'),
    );

    expect(client.lastPath, '/api/v1/accounts/auth/google/');
    expect(client.lastData, {'id_token': 'google-id-token'});
    expect(client.lastOptions, isNotNull);
    expect(client.lastOptions!.extra?['skipAuth'], isTrue);
    expect(session.userId, 'user-1');
    expect(tokenStore.accessToken, 'backend-access');
    expect(tokenStore.refreshToken, 'backend-refresh');
  });
}

final class _FakeApiClient implements ApiClient {
  String? lastPath;
  Object? lastData;
  Options? lastOptions;

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    lastPath = path;
    lastData = data;
    lastOptions = options;
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data:
          <String, dynamic>{
                'user': {
                  'id': 'user-1',
                  'full_name': 'Google User',
                  'is_verified': true,
                },
                'tokens': {
                  'access': 'backend-access',
                  'refresh': 'backend-refresh',
                },
                'created': true,
              }
              as T,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();
}

final class _FakeTokenStore implements TokenStore {
  String? accessToken;
  String? refreshToken;

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {}
}
