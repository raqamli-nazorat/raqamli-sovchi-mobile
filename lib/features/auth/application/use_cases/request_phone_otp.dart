import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/auth_repository.dart';

final class RequestPhoneOtpUseCase {
  const RequestPhoneOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call(String phoneNumber) {
    return _repository.requestPhoneOtp(phoneNumber);
  }
}
