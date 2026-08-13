import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/google_authorization_result.dart';
import '../models/auth_session_model.dart';
import 'auth_data_source.dart';

abstract interface class GoogleAuthDataSource {
  Future<AuthSessionModel> signInWithGoogle({
    required GoogleAuthorizationResult credential,
  });
}

final class RemoteGoogleAuthDataSource implements GoogleAuthDataSource {
  const RemoteGoogleAuthDataSource({required ApiClient client})
    : _client = client;

  static const _googlePath = '/api/v1/accounts/auth/google/';

  final ApiClient _client;

  @override
  Future<AuthSessionModel> signInWithGoogle({
    required GoogleAuthorizationResult credential,
  }) async {
    _debugGoogleAuthLog(
      'dataSource.post.start path=$_googlePath tokenLength=${credential.idToken.length}',
    );
    final response = await _client.post<Map<String, dynamic>>(
      _googlePath,
      data: {'id_token': credential.idToken},
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

    return session;
  }
}

void _debugGoogleAuthLog(String message) {
  if (!kDebugMode) return;
  debugPrint('[GoogleAuth] $message');
}
