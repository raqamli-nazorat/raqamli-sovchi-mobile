import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/current_user.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_data_source.dart';
import '../models/auth_session_model.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

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
  Future<Either<Failure, Session>> signInWithGoogle() =>
      _sessionCall(() => _dataSource.signInWithGoogle());

  @override
  Future<Either<Failure, Session>> obtainToken({
    required String phoneNumber,
    required String password,
  }) => _sessionCall(
    () => _dataSource.obtainToken(phoneNumber: phoneNumber, password: password),
  );

  @override
  Future<Either<Failure, Session>> signInWithTelegram() =>
      _sessionCall(() => _dataSource.signInWithTelegram());

  Future<Either<Failure, Session>> _sessionCall(
    Future<AuthSessionModel> Function() call,
  ) async {
    try {
      final model = await call();
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
