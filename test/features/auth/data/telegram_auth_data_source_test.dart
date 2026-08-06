import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/core/platform/external_url_launcher.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';
import 'package:raqamli_sovchi/features/auth/data/data_sources/auth_data_source.dart';
import 'package:raqamli_sovchi/features/auth/data/data_sources/telegram_auth_data_source.dart';

void main() {
  test(
    'maps wrapped create-session response and opens Telegram bot URL',
    () async {
      final urlLauncher = _FakeUrlLauncher();
      final dataSource = RemoteTelegramAuthDataSource(
        client: _FakeApiClient({
          'data': {
            'session_id': 'session-1',
            'status': 'pending',
            'bot_url': 'https://t.me/RaqamliSovchiBot?start=session-1',
            'expires_at': '2026-08-04T08:02:01.578570+05:00',
            'created_at': '2026-08-04T07:57:01.597249+05:00',
          },
          'error': null,
          'success': true,
        }),
        tokenStore: _FakeTokenStore(),
        urlLauncher: urlLauncher,
      );

      final session = await dataSource.createSession();

      expect(session.sessionId, 'session-1');
      expect(session.status, 'pending');
      expect(session.botUrl, contains('session-1'));
      expect(urlLauncher.openedUri?.toString(), contains('RaqamliSovchiBot'));
    },
  );

  test(
    'rejects authenticated Telegram response without complete token pair',
    () {
      final dataSource = RemoteTelegramAuthDataSource(
        client: _FakeApiClient({
          'status': 'authenticated',
          'user': {'id': 'user-1'},
          'tokens': {'access': 'access-only'},
        }),
        tokenStore: _FakeTokenStore(),
        urlLauncher: _FakeUrlLauncher(),
      );

      expect(
        () => dataSource.getSessionStatus('session-1'),
        throwsA(isA<AuthContractException>()),
      );
    },
  );

  test(
    'maps wrapped authenticated Telegram status and stores tokens',
    () async {
      final tokenStore = _FakeTokenStore();
      final dataSource = RemoteTelegramAuthDataSource(
        client: _FakeApiClient({
          'data': {
            'status': 'authenticated',
            'user': {
              'id': 'user-1',
              'phone_number': '+998901234567',
              'full_name': 'Test User',
            },
            'tokens': {'access': 'access-token', 'refresh': 'refresh-token'},
          },
          'error': null,
          'success': true,
        }),
        tokenStore: tokenStore,
        urlLauncher: _FakeUrlLauncher(),
      );

      final status = await dataSource.getSessionStatus('session-1');

      expect(status.status, 'authenticated');
      expect(status.session?.userId, 'user-1');
      expect(tokenStore.accessToken, 'access-token');
      expect(tokenStore.refreshToken, 'refresh-token');
    },
  );
}

final class _FakeApiClient implements ApiClient {
  _FakeApiClient(this.responseData);

  final Map<String, dynamic> responseData;

  Response<T> _response<T>() {
    return Response<T>(
      requestOptions: RequestOptions(path: '/test'),
      data: responseData as T,
    );
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async => _response<T>();

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async => _response<T>();

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async => _response<T>();

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async => _response<T>();

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async => _response<T>();
}

final class _FakeTokenStore implements TokenStore {
  String? accessToken;
  String? refreshToken;

  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => null;

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

final class _FakeUrlLauncher implements ExternalUrlLauncher {
  Uri? openedUri;

  @override
  Future<bool> open(Uri uri) async {
    openedUri = uri;
    return true;
  }
}
