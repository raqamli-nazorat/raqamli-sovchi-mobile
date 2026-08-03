import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';

final class VerifyPhoneOtpUseCase {
  const VerifyPhoneOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Session>> call({
    required String phoneNumber,
    required String otp,
  }) {
    return _repository.verifyPhoneOtp(phoneNumber: phoneNumber, otp: otp);
  }
}
