import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';

final class RequestPhoneOtpUseCase {
  const RequestPhoneOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Session?>> call(String phoneNumber) {
    return _repository.requestPhoneOtp(phoneNumber);
  }
}
