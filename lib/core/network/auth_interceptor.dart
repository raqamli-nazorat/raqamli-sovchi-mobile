import 'package:dio/dio.dart';

import '../security/auth_session_manager.dart';

final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._authSessionManager);

  final AuthSessionManager _authSessionManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true) {
      handler.next(options);
      return;
    }

    final token = await _authSessionManager.readEffectiveAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
