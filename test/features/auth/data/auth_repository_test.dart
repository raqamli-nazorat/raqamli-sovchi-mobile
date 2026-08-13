import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/core/security/auth_session_manager.dart';
import 'package:raqamli_sovchi/core/security/secure_storage.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';
import 'package:raqamli_sovchi/features/auth/data/data_sources/auth_data_source.dart';
import 'package:raqamli_sovchi/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  test('temporary repository maps OTP session to domain session', () async {
    final repository = AuthRepositoryImpl(
      TemporaryAuthDataSource(_MemoryTokenStore()),
      DefaultAuthSessionManager(_MemoryTokenStore(), _MemorySecureStorage()),
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

  test(
    'remote phone auth leaves returned tokens out of persistent storage',
    () async {
      final tokenStore = _MemoryTokenStore();
      final apiClient = _RecordingApiClient({
        'data': {
          'user': {
            'id': 'user-1',
            'full_name': 'Test User',
            'phone_number': '+998901234567',
          },
          'tokens': {'access': 'access-token', 'refresh': 'refresh-token'},
        },
        'success': true,
        'error': null,
      });
      final dataSource = RemoteAuthDataSource(
        client: apiClient,
        tokenStore: tokenStore,
      );

      final pendingSession = await dataSource.requestPhoneOtp('+998901234567');

      expect(apiClient.postPath, '/api/v1/accounts/auth/phone/');
      expect(apiClient.postData, {'phone_number': '+998901234567'});
      expect(apiClient.postOptions?.extra?['skipAuth'], isTrue);
      expect(pendingSession, isNull);
      expect(tokenStore.accessToken, isNull);
      expect(tokenStore.refreshToken, isNull);

      expect(
        () => dataSource.verifyPhoneOtp(
          phoneNumber: '+998901234567',
          otp: '0000',
        ),
        throwsA(isA<AuthValidationException>()),
      );
      expect(tokenStore.accessToken, isNull);
      expect(tokenStore.refreshToken, isNull);

      final session = await dataSource.verifyPhoneOtp(
        phoneNumber: '+998901234567',
        otp: '1234',
      );

      expect(session.userId, 'user-1');
      expect(session.phoneNumber, '+998901234567');
      expect(tokenStore.accessToken, isNull);
      expect(tokenStore.refreshToken, isNull);
    },
  );

  test(
    'remote restore session does not fetch user or profile on app start',
    () async {
      final tokenStore = _MemoryTokenStore(accessToken: 'access-token');
      final apiClient = _RecordingApiClient(const {});
      final dataSource = RemoteAuthDataSource(
        client: apiClient,
        tokenStore: tokenStore,
      );

      final session = await dataSource.restoreSession();

      expect(session?.accessToken, 'access-token');
      expect(session?.displayName, 'Raqamli Sovchi');
      expect(apiClient.getPath, isNull);
    },
  );
}

final class _MemorySecureStorage implements SecureStorage {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async => _values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }
}

final class _MemoryTokenStore implements TokenStore {
  _MemoryTokenStore({this.accessToken});

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
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }
}

final class _RecordingApiClient implements ApiClient {
  _RecordingApiClient(this.responseData);

  final Map<String, dynamic> responseData;
  String? getPath;
  String? postPath;
  Object? postData;
  Options? postOptions;

  Response<T> _response<T>(String path) {
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: responseData as T,
    );
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    getPath = path;
    return _response<T>(path);
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    postPath = path;
    postData = data;
    postOptions = options;
    return _response<T>(path);
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async => _response<T>(path);

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async => _response<T>(path);

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async => _response<T>(path);
}
