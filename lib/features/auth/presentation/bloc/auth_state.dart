import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/session.dart';

enum AuthStatus {
  initial,
  loading,
  unauthenticated,
  otpPending,
  telegramPending,
  pinSetupRequired,
  pinLocked,
  onboardingRequired,
  authenticated,
}

final class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.phoneNumber,
    this.failure,
    this.biometricAvailable = false,
  });

  final AuthStatus status;
  final Session? session;
  final String? phoneNumber;
  final Failure? failure;
  final bool biometricAvailable;

  AuthState copyWith({
    AuthStatus? status,
    Session? session,
    String? phoneNumber,
    Failure? failure,
    bool clearSession = false,
    bool clearPhoneNumber = false,
    bool clearFailure = false,
    bool? biometricAvailable,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      phoneNumber: clearPhoneNumber ? null : phoneNumber ?? this.phoneNumber,
      failure: clearFailure ? null : failure ?? this.failure,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
    );
  }

  @override
  List<Object?> get props => [
    status,
    session,
    phoneNumber,
    failure,
    biometricAvailable,
  ];
}
