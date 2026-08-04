import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/platform/external_url_launcher.dart';
import '../../../../core/security/token_store.dart';
import '../models/telegram_auth_session_model.dart';
import '../models/telegram_auth_status_model.dart';
import 'auth_data_source.dart';

abstract interface class TelegramAuthDataSource {
  Future<TelegramAuthSessionModel> createSession();

  Future<TelegramAuthStatusModel> getSessionStatus(String sessionId);
}

final class RemoteTelegramAuthDataSource implements TelegramAuthDataSource {
  RemoteTelegramAuthDataSource({
    required ApiClient client,
    required TokenStore tokenStore,
    required ExternalUrlLauncher urlLauncher,
  }) : _client = client,
       _tokenStore = tokenStore,
       _urlLauncher = urlLauncher;

  static const _createPath =
      '/api/v1/accounts/telegram-bot/auth-session/create/';
  static const _statusPath =
      '/api/v1/accounts/telegram-bot/auth-session/{sessionId}/status/';

  final ApiClient _client;
  final TokenStore _tokenStore;
  final ExternalUrlLauncher _urlLauncher;

  @override
  Future<TelegramAuthSessionModel> createSession() async {
    final response = await _client.post<Map<String, dynamic>>(
      _createPath,
      options: Options(extra: {'skipAuth': true}),
    );
    final session = TelegramAuthSessionModel.fromJson(
      _unwrapResponseData(response.data ?? {}),
    );
    if (session.sessionId.isEmpty || session.botUrl.isEmpty) {
      throw const AuthContractException(
        'Telegram session response is missing session_id or bot_url.',
      );
    }
    final uri = Uri.tryParse(session.botUrl);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw const AuthContractException('Telegram bot URL is invalid.');
    }
    if (!await _urlLauncher.open(uri)) {
      throw const AuthContractException('Telegram could not be opened.');
    }
    return session;
  }

  @override
  Future<TelegramAuthStatusModel> getSessionStatus(String sessionId) async {
    final response = await _client.get<Map<String, dynamic>>(
      _statusPath.replaceFirst('{sessionId}', Uri.encodeComponent(sessionId)),
      options: Options(extra: {'skipAuth': true}),
    );
    final status = TelegramAuthStatusModel.fromJson(
      _unwrapResponseData(response.data ?? {}),
    );
    if (status.status == 'authenticated') {
      final session = status.session;
      if (session == null ||
          session.accessToken.isEmpty ||
          session.refreshToken == null ||
          session.refreshToken!.isEmpty) {
        throw const AuthContractException(
          'Telegram authenticated response has no complete token pair.',
        );
      }
      await _tokenStore.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
    }
    return status;
  }

  Map<String, dynamic> _unwrapResponseData(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return response;
  }
}
