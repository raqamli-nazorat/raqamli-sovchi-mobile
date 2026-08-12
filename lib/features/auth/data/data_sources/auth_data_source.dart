import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/security/token_store.dart';
import '../models/auth_session_model.dart';
import '../models/current_user_model.dart';

abstract interface class AuthDataSource {
  Future<AuthSessionModel?> restoreSession();

  Future<AuthSessionModel?> requestPhoneOtp(String phoneNumber);

  Future<AuthSessionModel> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<AuthSessionModel> obtainToken({
    required String phoneNumber,
    required String password,
  });

  Future<CurrentUserModel> getCurrentUser();

  Future<void> refreshSession();

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<void> deleteAccount();

  Future<void> signOut();
}

final class AuthContractException implements Exception {
  const AuthContractException(this.message);

  final String message;
}

final class AuthValidationException implements Exception {
  const AuthValidationException(this.message);

  final String message;
}

final class TemporaryAuthDataSource implements AuthDataSource {
  TemporaryAuthDataSource(this._tokenStore);

  static const _temporaryAccessToken = 'temporary-auth-access-token';
  static const _temporaryUserId = 'temporary-auth-user';

  final TokenStore _tokenStore;
  String? _pendingPhoneNumber;

  @override
  Future<AuthSessionModel?> restoreSession() async {
    final token = await _tokenStore.readAccessToken();
    if (token == null || token.isEmpty) return null;

    return AuthSessionModel.local(
      userId: _temporaryUserId,
      displayName: 'Raqamli Sovchi',
      accessToken: _temporaryAccessToken,
      isVerified: true,
    );
  }

  @override
  Future<AuthSessionModel?> requestPhoneOtp(String phoneNumber) async {
    _pendingPhoneNumber = phoneNumber;
    return null;
  }

  @override
  Future<AuthSessionModel> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    if (_pendingPhoneNumber != phoneNumber || otp != '1234') {
      throw const AuthValidationException('Temporary OTP is 1234.');
    }

    return AuthSessionModel.local(
      userId: _temporaryUserId,
      displayName: 'Raqamli Sovchi',
      accessToken: _temporaryAccessToken,
      phoneNumber: phoneNumber,
      isVerified: true,
    );
  }

  @override
  Future<AuthSessionModel> obtainToken({
    required String phoneNumber,
    required String password,
  }) {
    throw const AuthContractException(
      'Temporary auth does not implement password token obtain.',
    );
  }

  @override
  Future<CurrentUserModel> getCurrentUser() async {
    return const CurrentUserModel(
      id: _temporaryUserId,
      displayName: 'Raqamli Sovchi',
      isVerified: true,
    );
  }

  @override
  Future<void> refreshSession() async {
    return;
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    throw const AuthContractException('Temporary auth has no password API.');
  }

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<void> signOut() async {}
}

final class RemoteAuthDataSource implements AuthDataSource {
  RemoteAuthDataSource({
    required ApiClient client,
    required TokenStore tokenStore,
  }) : _client = client,
       _tokenStore = tokenStore;

  static const _phonePath = '/api/v1/accounts/auth/phone/';
  static const _tokenPath = '/api/v1/accounts/auth/token/';
  static const _tokenRefreshPath = '/api/v1/accounts/auth/token/refresh/';
  static const _mePath = '/api/v1/accounts/users/me/';
  static const _changePasswordPath = '/api/v1/accounts/auth/change-password/';

  final ApiClient _client;
  final TokenStore _tokenStore;
  String? _pendingPhoneNumber;
  AuthSessionModel? _pendingPhoneSession;

  @override
  Future<AuthSessionModel?> restoreSession() async {
    final accessToken = await _tokenStore.readAccessToken();
    if (accessToken == null || accessToken.isEmpty) return null;

    return AuthSessionModel.local(
      userId: 'local-session',
      displayName: 'Raqamli Sovchi',
      accessToken: accessToken,
      isVerified: true,
    );
  }

  @override
  Future<AuthSessionModel?> requestPhoneOtp(String phoneNumber) async {
    final response = await _client.post<Map<String, dynamic>>(
      _phonePath,
      data: {'phone_number': phoneNumber},
      options: Options(extra: {'skipAuth': true}),
    );
    _pendingPhoneNumber = phoneNumber;
    _pendingPhoneSession = null;

    final data = response.data;
    if (data == null || data.isEmpty) return null;

    final session = AuthSessionModel.fromAuthResponse(data);
    if (session.accessToken.isEmpty) return null;

    _pendingPhoneSession = session.withPhoneNumberFallback(phoneNumber);
    return null;
  }

  @override
  Future<AuthSessionModel> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    if (_pendingPhoneNumber != phoneNumber || otp != '1234') {
      throw const AuthValidationException('Temporary OTP is 1234.');
    }

    final session = _pendingPhoneSession;
    if (session == null || session.accessToken.isEmpty) {
      throw const AuthContractException(
        'Phone auth response has no pending token session.',
      );
    }

    _pendingPhoneNumber = null;
    _pendingPhoneSession = null;
    return session;
  }

  @override
  Future<AuthSessionModel> obtainToken({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      _tokenPath,
      data: {'phone_number': phoneNumber, 'password': password},
      options: Options(extra: {'skipAuth': true}),
    );
    final session = AuthSessionModel.fromJson(response.data ?? const {});
    if (session.accessToken.isEmpty) {
      throw const AuthContractException('Token response has no access token.');
    }
    return session.withPhoneNumberFallback(phoneNumber);
  }

  @override
  Future<CurrentUserModel> getCurrentUser() async {
    final response = await _client.get<Map<String, dynamic>>(_mePath);
    return CurrentUserModel.fromJson(response.data!);
  }

  @override
  Future<void> refreshSession() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const AuthContractException('Refresh token is missing.');
    }

    final response = await _client.post<Map<String, dynamic>>(
      _tokenRefreshPath,
      data: {'refresh': refreshToken},
      options: Options(extra: {'skipAuth': true}),
    );
    final accessToken =
        (response.data?['access'] ?? response.data?['access_token'])
            ?.toString();
    if (accessToken == null || accessToken.isEmpty) {
      throw const AuthContractException(
        'Refresh response has no access token.',
      );
    }
    await _tokenStore.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    await _client.put<void>(
      _changePasswordPath,
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword,
      },
    );
  }

  @override
  Future<void> deleteAccount() async {
    await _client.delete<void>(_mePath);
  }

  @override
  Future<void> signOut() async {}
}
