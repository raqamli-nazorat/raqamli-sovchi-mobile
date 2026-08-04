import '../../../../core/security/biometric_auth_service.dart';

final class CheckBiometricAvailabilityUseCase {
  const CheckBiometricAvailabilityUseCase(this._service);

  final BiometricAuthService _service;

  Future<BiometricAvailability> call() => _service.checkAvailability();
}
