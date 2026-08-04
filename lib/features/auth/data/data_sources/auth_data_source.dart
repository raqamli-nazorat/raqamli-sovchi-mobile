import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/security/token_store.dart';
import '../models/auth_session_model.dart';
import '../models/current_user_model.dart';

abstract interface class AuthDataSource {
  Future<AuthSessionModel?> restoreSession();

  Future<void> requestPhoneOtp(String phoneNumber);

  Future<AuthSessionModel> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<AuthSessionModel> obtainToken({
    required String phoneNumber,
    required String password,
  });

  Future<AuthSessionModel> signInWithGoogle();

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

    return const AuthSessionModel(
      userId: _temporaryUserId,
      displayName: 'Raqamli Sovchi',
      accessToken: _temporaryAccessToken,
      isVerified: true,
    );
  }

  @override
  Future<void> requestPhoneOtp(String phoneNumber) async {
    _pendingPhoneNumber = phoneNumber;
  }

  @override
  Future<AuthSessionModel> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    if (_pendingPhoneNumber != phoneNumber || otp != '1234') {
      throw const AuthValidationException('Temporary OTP is 1234.');
    }

    await _tokenStore.saveTokens(accessToken: _temporaryAccessToken);
    return AuthSessionModel(
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
  Future<AuthSessionModel> signInWithGoogle() {
    throw const AuthContractException(
      'Google auth contract is not available yet.',
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
  Future<void> deleteAccount() => _tokenStore.clear();

  @override
  Future<void> signOut() => _tokenStore.clear();
}

final class RemoteAuthDataSource implements AuthDataSource {
  const RemoteAuthDataSource({
    required ApiClient client,
    required TokenStore tokenStore,
  }) : _client = client,
       _tokenStore = tokenStore;

  static const _phonePath = '/api/v1/accounts/auth/phone/';
  static const _googlePath = '/api/v1/accounts/auth/google/';
  static const _tokenPath = '/api/v1/accounts/auth/token/';
  static const _tokenRefreshPath = '/api/v1/accounts/auth/token/refresh/';
  static const _mePath = '/api/v1/accounts/users/me/';
  static const _changePasswordPath = '/api/v1/accounts/auth/change-password/';

  final ApiClient _client;
  final TokenStore _tokenStore;

  @override
  Future<AuthSessionModel?> restoreSession() async {
    final accessToken = await _tokenStore.readAccessToken();
    if (accessToken == null || accessToken.isEmpty) return null;

    CurrentUserModel user;
    try {
      user = await getCurrentUser();
    } on DioException catch (error) {
      if (error.response?.statusCode != 401) rethrow;
      await refreshSession();
      user = await getCurrentUser();
    }
    return AuthSessionModel(
      userId: user.id,
      displayName: user.displayName,
      accessToken: accessToken,
      phoneNumber: user.phoneNumber,
      isVerified: user.isVerified,
    );
  }

  @override
  Future<void> requestPhoneOtp(String phoneNumber) async {
    await _client.post<void>(
      _phonePath,
      data: {'phone_number': phoneNumber},
      options: Options(extra: {'skipAuth': true}),
    );
  }

  @override
  Future<AuthSessionModel> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) {
    throw const AuthContractException(
      'OTP verification endpoint is not documented by backend.',
    );
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
    await _tokenStore.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    return AuthSessionModel(
      userId: session.userId,
      displayName: session.displayName,
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      phoneNumber: phoneNumber,
      isVerified: session.isVerified,
    );
  }

  @override
  Future<AuthSessionModel> signInWithGoogle() {
    throw const AuthContractException(
      'Google auth request/response contract is not documented by backend.',
    );
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
    await _tokenStore.clear();
  }

  @override
  Future<void> signOut() => _tokenStore.clear();

  // Kept as a named reference so the documented endpoint remains visible next
  // to the contract adapter until backend provides its request schema.
  String get googleEndpoint => _googlePath;
}
