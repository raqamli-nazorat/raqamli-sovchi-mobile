import 'package:equatable/equatable.dart';

import '../../../onboarding/domain/entities/candidate_type.dart';

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

final class AuthTelegramStatusCheckRequested extends AuthEvent {
  const AuthTelegramStatusCheckRequested(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

final class AuthBiometricAvailabilityRequested extends AuthEvent {
  const AuthBiometricAvailabilityRequested();
}

final class AuthBiometricUnlockRequested extends AuthEvent {
  const AuthBiometricUnlockRequested();
}

final class AuthApplicationResumed extends AuthEvent {
  const AuthApplicationResumed();
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

final class AuthCandidateTypeSelected extends AuthEvent {
  const AuthCandidateTypeSelected(this.candidateType);

  final CandidateType candidateType;

  @override
  List<Object?> get props => [candidateType];
}

final class AuthPledgeSubmitted extends AuthEvent {
  const AuthPledgeSubmitted({
    required this.acceptedTerms,
    required this.hasSeriousBadge,
  });

  final bool acceptedTerms;
  final bool hasSeriousBadge;

  @override
  List<Object?> get props => [acceptedTerms, hasSeriousBadge];
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

final class AuthDeleteAccountRequested extends AuthEvent {
  const AuthDeleteAccountRequested();
}

final class AuthFlowCancelled extends AuthEvent {
  const AuthFlowCancelled();
}
