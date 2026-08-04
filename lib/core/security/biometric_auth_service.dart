import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricAvailability { available, notSupported, notEnrolled, unavailable }

enum BiometricAuthResult {
  success,
  userCanceled,
  failed,
  lockedOut,
  unavailable,
}

abstract interface class BiometricAuthService {
  Future<BiometricAvailability> checkAvailability();

  Future<BiometricAuthResult> authenticate();
}

final class LocalBiometricAuthService implements BiometricAuthService {
  LocalBiometricAuthService([LocalAuthentication? authentication])
    : _authentication = authentication ?? LocalAuthentication();

  final LocalAuthentication _authentication;

  @override
  Future<BiometricAvailability> checkAvailability() async {
    try {
      if (!await _authentication.isDeviceSupported()) {
        return BiometricAvailability.notSupported;
      }
      if (!await _authentication.canCheckBiometrics) {
        return BiometricAvailability.unavailable;
      }
      final available = await _authentication.getAvailableBiometrics();
      return available.isEmpty
          ? BiometricAvailability.notEnrolled
          : BiometricAvailability.available;
    } on PlatformException {
      return BiometricAvailability.unavailable;
    } on Object {
      return BiometricAvailability.unavailable;
    }
  }

  @override
  Future<BiometricAuthResult> authenticate() async {
    try {
      final authenticated = await _authentication.authenticate(
        localizedReason:
            'Hisobingizga tez va xavfsiz kirish uchun biometrikani tasdiqlang.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
          useErrorDialogs: true,
        ),
      );
      return authenticated
          ? BiometricAuthResult.success
          : BiometricAuthResult.userCanceled;
    } on PlatformException catch (error) {
      return switch (error.code) {
        'LockedOut' ||
        'lockOut' ||
        'BiometricLockout' => BiometricAuthResult.lockedOut,
        'NotAvailable' ||
        'NotEnrolled' ||
        'PasscodeNotSet' => BiometricAuthResult.unavailable,
        'UserCancel' || 'SystemCancel' => BiometricAuthResult.userCanceled,
        _ => BiometricAuthResult.failed,
      };
    } on Object {
      return BiometricAuthResult.failed;
    }
  }
}
