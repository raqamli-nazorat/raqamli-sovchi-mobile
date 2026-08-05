import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/security/token_store.dart';
import '../../domain/entities/google_authorization_result.dart';
import '../models/auth_session_model.dart';
import 'auth_data_source.dart';

abstract interface class GoogleAuthDataSource {
  Future<AuthSessionModel> signInWithGoogle({
    required GoogleAuthorizationResult credential,
  });
}

final class RemoteGoogleAuthDataSource implements GoogleAuthDataSource {
  const RemoteGoogleAuthDataSource({
    required ApiClient client,
    required TokenStore tokenStore,
  }) : _client = client,
       _tokenStore = tokenStore;

  static const _googlePath = '/api/v1/accounts/auth/google/';

  final ApiClient _client;
  final TokenStore _tokenStore;

  @override
  Future<AuthSessionModel> signInWithGoogle({
    required GoogleAuthorizationResult credential,
  }) async {
    _debugGoogleAuthLog(
      'dataSource.post.start path=$_googlePath codeLength=${credential.authorizationCode.length}',
    );
    final response = await _client.post<Map<String, dynamic>>(
      _googlePath,
      data: {'authorization_code': credential.authorizationCode},
      options: Options(extra: {'skipAuth': true}),
    );
    _debugGoogleAuthLog(
      'dataSource.post.done status=${response.statusCode} hasBody=${response.data != null}',
    );

    final session = AuthSessionModel.fromGoogleResponse(
      response.data ?? const {},
    );
    if (session.accessToken.isEmpty) {
      _debugGoogleAuthLog('dataSource.mapper.missingBackendAccessToken');
      throw const AuthContractException(
        'Google response has no backend access token.',
      );
    }

    await _tokenStore.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    _debugGoogleAuthLog(
      'dataSource.tokenStore.saved accessPresent=${session.accessToken.isNotEmpty} refreshPresent=${session.refreshToken?.isNotEmpty ?? false}',
    );
    return session;
  }
}

void _debugGoogleAuthLog(String message) {
  if (!kDebugMode) return;
  debugPrint('[GoogleAuth] $message');
}
