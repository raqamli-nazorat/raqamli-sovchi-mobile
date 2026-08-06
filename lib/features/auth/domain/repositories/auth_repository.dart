import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/current_user.dart';
import '../entities/google_authorization_result.dart';
import '../entities/session.dart';
import '../entities/telegram_auth_session.dart';
import '../entities/telegram_auth_status.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Session?>> restoreSession();

  Future<Either<Failure, Session?>> requestPhoneOtp(String phoneNumber);

  Future<Either<Failure, Session>> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<Either<Failure, Session>> obtainToken({
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, Session>> signInWithGoogle({
    required GoogleAuthorizationResult credential,
  });

  Future<Either<Failure, TelegramAuthSession>> createTelegramAuthSession();

  Future<Either<Failure, TelegramAuthStatus>> getTelegramAuthSessionStatus(
    String sessionId,
  );

  Future<Either<Failure, CurrentUser>> getCurrentUser();

  Future<Either<Failure, void>> refreshSession();

  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, void>> signOut();
}
