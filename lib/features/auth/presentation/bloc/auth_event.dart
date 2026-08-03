import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthPhoneSubmitted extends AuthEvent {
  const AuthPhoneSubmitted(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}

final class AuthOtpSubmitted extends AuthEvent {
  const AuthOtpSubmitted(this.otp);

  final String otp;

  @override
  List<Object?> get props => [otp];
}

final class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

final class AuthTelegramSignInRequested extends AuthEvent {
  const AuthTelegramSignInRequested();
}

final class AuthPinCreated extends AuthEvent {
  const AuthPinCreated(this.pin);

  final String pin;

  @override
  List<Object?> get props => [pin];
}

final class AuthPinUnlockRequested extends AuthEvent {
  const AuthPinUnlockRequested(this.pin);

  final String pin;

  @override
  List<Object?> get props => [pin];
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

final class AuthFlowCancelled extends AuthEvent {
  const AuthFlowCancelled();
}
