import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/current_user.dart';
import '../../domain/entities/google_authorization_result.dart';
import '../../domain/entities/session.dart';
import '../../domain/entities/telegram_auth_session.dart';
import '../../domain/entities/telegram_auth_status.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_data_source.dart';
import '../data_sources/google_auth_data_source.dart';
import '../data_sources/telegram_auth_data_source.dart';
import '../models/auth_session_model.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._dataSource, {
    TelegramAuthDataSource? telegram,
    GoogleAuthDataSource? google,
  }) : _telegram = telegram,
       _google = google;

  final AuthDataSource _dataSource;
  final TelegramAuthDataSource? _telegram;
  final GoogleAuthDataSource? _google;

  @override
  Future<Either<Failure, Session?>> restoreSession() async {
    try {
      final model = await _dataSource.restoreSession();
      return Right<Failure, Session?>(model?.toEntity());
    } on DioException catch (error) {
      return Left<Failure, Session?>(mapDioException(error));
    } on AuthContractException {
      return const Left<Failure, Session?>(Failure.unsupported());
    } on AuthValidationException {
      return const Left<Failure, Session?>(Failure.validation());
    } on Object catch (error) {
      return Left<Failure, Session?>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> requestPhoneOtp(String phoneNumber) async {
    try {
      await _dataSource.requestPhoneOtp(phoneNumber);
      return const Right<Failure, void>(null);
    } on DioException catch (error) {
      return Left<Failure, void>(mapDioException(error));
    } on AuthContractException {
      return const Left<Failure, void>(Failure.unsupported());
    } on AuthValidationException {
      return const Left<Failure, void>(Failure.validation());
    } on Object catch (error) {
      return Left<Failure, void>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Session>> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final model = await _dataSource.verifyPhoneOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      return Right<Failure, Session>(model.toEntity());
    } on DioException catch (error) {
      return Left<Failure, Session>(mapDioException(error));
    } on AuthContractException {
      return const Left<Failure, Session>(Failure.unsupported());
    } on AuthValidationException {
      return const Left<Failure, Session>(Failure.validation());
    } on Object catch (error) {
      return Left<Failure, Session>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Session>> signInWithGoogle({
    required GoogleAuthorizationResult credential,
  }) async {
    _debugGoogleAuthLog(
      'repository.signInWithGoogle.start googleDataSourceConfigured=${_google != null} codeLength=${credential.authorizationCode.length}',
    );
    final google = _google;
    if (google == null) {
      _debugGoogleAuthLog(
        'repository.signInWithGoogle.unsupportedNoDataSource',
      );
      return const Left<Failure, Session>(Failure.unsupported());
    }
    return _sessionCall(() => google.signInWithGoogle(credential: credential));
  }

  @override
  Future<Either<Failure, Session>> obtainToken({
    required String phoneNumber,
    required String password,
  }) => _sessionCall(
    () => _dataSource.obtainToken(phoneNumber: phoneNumber, password: password),
  );

  @override
  Future<Either<Failure, TelegramAuthSession>>
  createTelegramAuthSession() async {
    try {
      final telegram = _telegram;
      if (telegram == null) {
        throw const AuthContractException(
          'Telegram auth data source is not configured.',
        );
      }
      return Right<Failure, TelegramAuthSession>(
        (await telegram.createSession()).toEntity(),
      );
    } on DioException catch (error) {
      return Left<Failure, TelegramAuthSession>(mapDioException(error));
    } on AuthContractException {
      return const Left<Failure, TelegramAuthSession>(Failure.unsupported());
    } on Object catch (error) {
      return Left<Failure, TelegramAuthSession>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, TelegramAuthStatus>> getTelegramAuthSessionStatus(
    String sessionId,
  ) async {
    try {
      final telegram = _telegram;
      if (telegram == null) {
        throw const AuthContractException(
          'Telegram auth data source is not configured.',
        );
      }
      return Right<Failure, TelegramAuthStatus>(
        (await telegram.getSessionStatus(sessionId)).toEntity(),
      );
    } on DioException catch (error) {
      return Left<Failure, TelegramAuthStatus>(mapDioException(error));
    } on AuthContractException {
      return const Left<Failure, TelegramAuthStatus>(Failure.unsupported());
    } on Object catch (error) {
      return Left<Failure, TelegramAuthStatus>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  Future<Either<Failure, Session>> _sessionCall(
    Future<AuthSessionModel> Function() call,
  ) async {
    try {
      final model = await call();
      _debugGoogleAuthLog('repository.sessionCall.success');
      return Right<Failure, Session>(model.toEntity());
    } on DioException catch (error) {
      _debugGoogleAuthLog(
        'repository.sessionCall.dioException status=${error.response?.statusCode} type=${error.type}',
      );
      return Left<Failure, Session>(mapDioException(error));
    } on AuthContractException {
      _debugGoogleAuthLog('repository.sessionCall.authContractException');
      return const Left<Failure, Session>(Failure.unsupported());
    } on AuthValidationException {
      _debugGoogleAuthLog('repository.sessionCall.authValidationException');
      return const Left<Failure, Session>(Failure.validation());
    } on Object catch (error) {
      _debugGoogleAuthLog(
        'repository.sessionCall.unknownException type=${error.runtimeType}',
      );
      return Left<Failure, Session>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, CurrentUser>> getCurrentUser() async {
    try {
      return Right<Failure, CurrentUser>(
        (await _dataSource.getCurrentUser()).toEntity(),
      );
    } on DioException catch (error) {
      return Left<Failure, CurrentUser>(mapDioException(error));
    } on Object catch (error) {
      return Left<Failure, CurrentUser>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> refreshSession() =>
      _voidCall(_dataSource.refreshSession);

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) => _voidCall(
    () => _dataSource.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    ),
  );

  @override
  Future<Either<Failure, void>> deleteAccount() =>
      _voidCall(_dataSource.deleteAccount);

  @override
  Future<Either<Failure, void>> signOut() => _voidCall(_dataSource.signOut);

  Future<Either<Failure, void>> _voidCall(Future<void> Function() call) async {
    try {
      await call();
      return const Right<Failure, void>(null);
    } on DioException catch (error) {
      return Left<Failure, void>(mapDioException(error));
    } on AuthContractException {
      return const Left<Failure, void>(Failure.unsupported());
    } on AuthValidationException {
      return const Left<Failure, void>(Failure.validation());
    } on Object catch (error) {
      return Left<Failure, void>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }
}

void _debugGoogleAuthLog(String message) {
  if (!kDebugMode) return;
  debugPrint('[GoogleAuth] $message');
}
