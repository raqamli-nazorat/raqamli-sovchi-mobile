import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/security/biometric_auth_service.dart';
import '../../application/use_cases/authenticate_biometric.dart';
import '../../application/use_cases/check_biometric_availability.dart';
import '../../application/use_cases/clear_pin.dart';
import '../../application/use_cases/create_pin.dart';
import '../../application/use_cases/create_telegram_auth_session.dart';
import '../../application/use_cases/get_telegram_auth_session_status.dart';
import '../../application/use_cases/has_pin.dart';
import '../../application/use_cases/request_phone_otp.dart';
import '../../application/use_cases/restore_session.dart';
import '../../application/use_cases/sign_in_with_google.dart';
import '../../application/use_cases/sign_out.dart';
import '../../application/use_cases/verify_phone_otp.dart';
import '../../application/use_cases/verify_pin.dart';
import '../../domain/entities/session.dart';
import 'auth_event.dart';
import 'auth_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RestoreSessionUseCase restoreSession,
    required RequestPhoneOtpUseCase requestPhoneOtp,
    required VerifyPhoneOtpUseCase verifyPhoneOtp,
    required SignInWithGoogleUseCase signInWithGoogle,
    required CreateTelegramAuthSessionUseCase createTelegramAuthSession,
    required GetTelegramAuthSessionStatusUseCase getTelegramAuthSessionStatus,
    required CheckBiometricAvailabilityUseCase checkBiometricAvailability,
    required AuthenticateBiometricUseCase authenticateBiometric,
    required HasPinUseCase hasPin,
    required CreatePinUseCase createPin,
    required VerifyPinUseCase verifyPin,
    required ClearPinUseCase clearPin,
    required SignOutUseCase signOut,
    this.telegramPollingInterval = const Duration(seconds: 2),
  }) : _restoreSession = restoreSession,
       _requestPhoneOtp = requestPhoneOtp,
       _verifyPhoneOtp = verifyPhoneOtp,
       _signInWithGoogle = signInWithGoogle,
       _createTelegramAuthSession = createTelegramAuthSession,
       _getTelegramAuthSessionStatus = getTelegramAuthSessionStatus,
       _checkBiometricAvailability = checkBiometricAvailability,
       _authenticateBiometric = authenticateBiometric,
       _hasPin = hasPin,
       _createPin = createPin,
       _verifyPin = verifyPin,
       _clearPin = clearPin,
       _signOut = signOut,
       super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthPhoneSubmitted>(_onPhoneSubmitted);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthTelegramSignInRequested>(_onTelegramSignInRequested);
    on<AuthTelegramStatusCheckRequested>(_onTelegramStatusCheckRequested);
    on<AuthBiometricAvailabilityRequested>(_onBiometricAvailabilityRequested);
    on<AuthBiometricUnlockRequested>(_onBiometricUnlockRequested);
    on<AuthApplicationResumed>(_onApplicationResumed);
    on<AuthPinCreated>(_onPinCreated);
    on<AuthPinUnlockRequested>(_onPinUnlockRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthFlowCancelled>(_onFlowCancelled);
  }

  final RestoreSessionUseCase _restoreSession;
  final RequestPhoneOtpUseCase _requestPhoneOtp;
  final VerifyPhoneOtpUseCase _verifyPhoneOtp;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final CreateTelegramAuthSessionUseCase _createTelegramAuthSession;
  final GetTelegramAuthSessionStatusUseCase _getTelegramAuthSessionStatus;
  final CheckBiometricAvailabilityUseCase _checkBiometricAvailability;
  final AuthenticateBiometricUseCase _authenticateBiometric;
  final HasPinUseCase _hasPin;
  final CreatePinUseCase _createPin;
  final VerifyPinUseCase _verifyPin;
  final ClearPinUseCase _clearPin;
  final SignOutUseCase _signOut;
  final Duration telegramPollingInterval;
  Timer? _telegramPollingTimer;
  String? _telegramSessionId;
  DateTime? _telegramDeadline;
  bool _telegramStatusRequestInFlight = false;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _restoreSession();
    await result.fold(
      (failure) async {
        emit(AuthState(status: AuthStatus.unauthenticated, failure: failure));
      },
      (session) async {
        if (session == null) {
          emit(const AuthState(status: AuthStatus.unauthenticated));
          return;
        }
        await _emitPinGate(session, emit);
      },
    );
  }

  Future<void> _onPhoneSubmitted(
    AuthPhoneSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    _stopTelegramPolling();
    if (!RegExp(r'^\+998\d{9}$').hasMatch(event.phoneNumber)) {
      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          failure: _validationFailure,
        ),
      );
      return;
    }

    emit(AuthState(status: AuthStatus.loading, phoneNumber: event.phoneNumber));
    final result = await _requestPhoneOtp(event.phoneNumber);
    result.fold(
      (failure) => emit(
        AuthState(
          status: AuthStatus.unauthenticated,
          phoneNumber: event.phoneNumber,
          failure: failure,
        ),
      ),
      (_) => emit(
        AuthState(
          status: AuthStatus.otpPending,
          phoneNumber: event.phoneNumber,
        ),
      ),
    );
  }

  Future<void> _onOtpSubmitted(
    AuthOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final phoneNumber = state.phoneNumber;
    if (phoneNumber == null || event.otp.length != 4) return;

    emit(state.copyWith(status: AuthStatus.loading, clearFailure: true));
    final result = await _verifyPhoneOtp(
      phoneNumber: phoneNumber,
      otp: event.otp,
    );
    await result.fold(
      (failure) async =>
          emit(state.copyWith(status: AuthStatus.otpPending, failure: failure)),
      (session) async => _emitPinGate(session, emit),
    );
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    _stopTelegramPolling();
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _signInWithGoogle();
    await result.fold(
      (failure) async =>
          emit(AuthState(status: AuthStatus.unauthenticated, failure: failure)),
      (session) async => _emitPinGate(session, emit),
    );
  }

  Future<void> _onTelegramSignInRequested(
    AuthTelegramSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    _stopTelegramPolling();
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _createTelegramAuthSession();
    result.fold(
      (failure) =>
          emit(AuthState(status: AuthStatus.unauthenticated, failure: failure)),
      (session) {
        _telegramSessionId = session.sessionId;
        _telegramDeadline =
            session.expiresAt ?? DateTime.now().add(const Duration(minutes: 5));
        emit(const AuthState(status: AuthStatus.telegramPending));
        add(AuthTelegramStatusCheckRequested(session.sessionId));
        _telegramPollingTimer = Timer.periodic(
          telegramPollingInterval,
          (_) => add(AuthTelegramStatusCheckRequested(session.sessionId)),
        );
      },
    );
  }

  Future<void> _onTelegramStatusCheckRequested(
    AuthTelegramStatusCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (event.sessionId != _telegramSessionId) return;
    if (_telegramDeadline != null &&
        DateTime.now().isAfter(_telegramDeadline!)) {
      _stopTelegramPolling();
      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          failure: Failure.unauthorized(),
        ),
      );
      return;
    }
    if (_telegramStatusRequestInFlight) return;
    _telegramStatusRequestInFlight = true;
    try {
      final result = await _getTelegramAuthSessionStatus(event.sessionId);
      await result.fold(
        (failure) async {
          _stopTelegramPolling();
          emit(AuthState(status: AuthStatus.unauthenticated, failure: failure));
        },
        (status) async {
          if (status.isPending) return;
          _stopTelegramPolling();
          if (status.isAuthenticated && status.session != null) {
            await _emitPinGate(status.session!, emit);
            return;
          }
          emit(
            AuthState(
              status: AuthStatus.unauthenticated,
              failure: status.isExpired
                  ? const Failure.unauthorized()
                  : _validationFailure,
            ),
          );
        },
      );
    } finally {
      _telegramStatusRequestInFlight = false;
    }
  }

  Future<void> _onBiometricAvailabilityRequested(
    AuthBiometricAvailabilityRequested event,
    Emitter<AuthState> emit,
  ) async {
    final availability = await _checkBiometricAvailability();
    emit(
      state.copyWith(
        biometricAvailable: availability == BiometricAvailability.available,
      ),
    );
  }

  Future<void> _onBiometricUnlockRequested(
    AuthBiometricUnlockRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearFailure: true));
    final result = await _authenticateBiometric();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: AuthStatus.pinLocked, failure: failure)),
      (outcome) => emit(switch (outcome) {
        BiometricUnlockOutcome.authenticated => state.copyWith(
          status: AuthStatus.authenticated,
        ),
        BiometricUnlockOutcome.noSession => state.copyWith(
          status: AuthStatus.unauthenticated,
          clearSession: true,
        ),
        BiometricUnlockOutcome.userCanceled || BiometricUnlockOutcome.failed =>
          state.copyWith(status: AuthStatus.pinLocked),
      }),
    );
  }

  Future<void> _onApplicationResumed(
    AuthApplicationResumed event,
    Emitter<AuthState> emit,
  ) async {
    final sessionId = _telegramSessionId;
    if (sessionId != null) {
      add(AuthTelegramStatusCheckRequested(sessionId));
    }
    if (state.status != AuthStatus.authenticated || state.session == null) {
      return;
    }
    final result = await _hasPin();
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.pinSetupRequired, failure: failure),
      ),
      (hasPin) => emit(
        state.copyWith(
          status: hasPin ? AuthStatus.pinLocked : AuthStatus.pinSetupRequired,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> _onPinCreated(
    AuthPinCreated event,
    Emitter<AuthState> emit,
  ) async {
    if (event.pin.length != 4 || state.session == null) return;
    emit(state.copyWith(status: AuthStatus.loading, clearFailure: true));
    final result = await _createPin(event.pin);
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.pinSetupRequired, failure: failure),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.authenticated)),
    );
  }

  Future<void> _onPinUnlockRequested(
    AuthPinUnlockRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (event.pin.length != 4 || state.session == null) return;
    emit(state.copyWith(status: AuthStatus.loading, clearFailure: true));
    final result = await _verifyPin(event.pin);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: AuthStatus.pinLocked, failure: failure)),
      (isValid) => emit(
        isValid
            ? state.copyWith(status: AuthStatus.authenticated)
            : state.copyWith(
                status: AuthStatus.pinLocked,
                failure: _validationFailure,
              ),
      ),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    _stopTelegramPolling();
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _signOut();
    final clearPinResult = await _clearPin();
    result.fold(
      (failure) =>
          emit(AuthState(status: AuthStatus.unauthenticated, failure: failure)),
      (_) => clearPinResult.fold(
        (failure) => emit(
          AuthState(status: AuthStatus.unauthenticated, failure: failure),
        ),
        (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
      ),
    );
  }

  void _onFlowCancelled(AuthFlowCancelled event, Emitter<AuthState> emit) {
    _stopTelegramPolling();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void _stopTelegramPolling() {
    _telegramPollingTimer?.cancel();
    _telegramPollingTimer = null;
    _telegramSessionId = null;
    _telegramDeadline = null;
  }

  @override
  Future<void> close() {
    _stopTelegramPolling();
    return super.close();
  }

  Future<void> _emitPinGate(Session session, Emitter<AuthState> emit) async {
    final pinResult = await _hasPin();
    pinResult.fold(
      (failure) => emit(
        AuthState(
          status: AuthStatus.pinSetupRequired,
          session: session,
          failure: failure,
        ),
      ),
      (hasPin) => emit(
        AuthState(
          status: hasPin ? AuthStatus.pinLocked : AuthStatus.pinSetupRequired,
          session: session,
          phoneNumber: session.phoneNumber ?? state.phoneNumber,
        ),
      ),
    );
  }

  static const _validationFailure = Failure.validation();
}
