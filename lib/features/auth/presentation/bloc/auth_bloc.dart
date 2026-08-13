import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/security/biometric_auth_service.dart';
import '../../application/use_cases/authenticate_biometric.dart';
import '../../application/use_cases/check_biometric_availability.dart';
import '../../application/use_cases/clear_auth_session.dart';
import '../../application/use_cases/clear_pending_auth_session.dart';
import '../../application/use_cases/clear_pin.dart';
import '../../application/use_cases/commit_pending_auth_session.dart';
import '../../application/use_cases/create_pin.dart';
import '../../application/use_cases/create_telegram_auth_session.dart';
import '../../application/use_cases/delete_account.dart';
import '../../application/use_cases/get_telegram_auth_session_status.dart';
import '../../application/use_cases/has_pin.dart';
import '../../application/use_cases/read_profile_onboarding_completion.dart';
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
    required CommitPendingAuthSessionUseCase commitPendingAuthSession,
    required ReadProfileOnboardingCompletionUseCase
    readProfileOnboardingCompletion,
    required SignOutUseCase signOut,
    required DeleteAccountUseCase deleteAccount,
    required ClearAuthSessionUseCase clearAuthSession,
    required ClearPendingAuthSessionUseCase clearPendingAuthSession,
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
       _commitPendingAuthSession = commitPendingAuthSession,
       _readProfileOnboardingCompletion = readProfileOnboardingCompletion,
       _signOut = signOut,
       _deleteAccount = deleteAccount,
       _clearAuthSession = clearAuthSession,
       _clearPendingAuthSession = clearPendingAuthSession,
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
    on<AuthOnboardingCompleted>(_onOnboardingCompleted);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthDeleteAccountRequested>(_onDeleteAccountRequested);
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
  final CommitPendingAuthSessionUseCase _commitPendingAuthSession;
  final ReadProfileOnboardingCompletionUseCase _readProfileOnboardingCompletion;
  final SignOutUseCase _signOut;
  final DeleteAccountUseCase _deleteAccount;
  final ClearAuthSessionUseCase _clearAuthSession;
  final ClearPendingAuthSessionUseCase _clearPendingAuthSession;
  final Duration telegramPollingInterval;
  Timer? _telegramPollingTimer;
  String? _telegramSessionId;
  DateTime? _telegramDeadline;
  bool _telegramStatusRequestInFlight = false;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    _debugAuthEvent('restore.started');
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _restoreSession();
    await result.fold(
      (failure) async {
        _debugAuthEvent('restore.failure type=${failure.type.name}');
        emit(AuthState(status: AuthStatus.unauthenticated, failure: failure));
      },
      (session) async {
        if (session == null) {
          await _clearPin();
          _debugAuthEvent(
            'restore.emptySession -> clearPin -> unauthenticated',
          );
          emit(const AuthState(status: AuthStatus.unauthenticated));
          return;
        }
        await _emitPinGate(session, emit, source: 'restore');
      },
    );
  }

  Future<void> _onPhoneSubmitted(
    AuthPhoneSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    _stopTelegramPolling();
    _clearPendingAuthSession();
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
      (session) async => _emitPinGate(session, emit, source: 'phone'),
    );
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    _debugGoogleAuthLog('bloc.googleRequested');
    _stopTelegramPolling();
    _clearPendingAuthSession();
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _signInWithGoogle();
    await result.fold(
      (failure) async {
        _debugGoogleAuthLog('bloc.googleFailure type=${failure.type}');
        emit(AuthState(status: AuthStatus.unauthenticated, failure: failure));
      },
      (session) async {
        _debugGoogleAuthLog('bloc.googleSuccess.emitPinGate');
        await _emitPinGate(session, emit, source: 'google');
      },
    );
  }

  Future<void> _onTelegramSignInRequested(
    AuthTelegramSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    _stopTelegramPolling();
    _clearPendingAuthSession();
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
            await _emitPinGate(status.session!, emit, source: 'telegram');
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
    await result.fold(
      (failure) async =>
          emit(state.copyWith(status: AuthStatus.pinLocked, failure: failure)),
      (outcome) async {
        switch (outcome) {
          case BiometricUnlockOutcome.authenticated:
            await _emitPostPinGate(state.session!, emit, source: 'biometric');
          case BiometricUnlockOutcome.noSession:
            emit(
              state.copyWith(
                status: AuthStatus.unauthenticated,
                clearSession: true,
              ),
            );
          case BiometricUnlockOutcome.userCanceled:
          case BiometricUnlockOutcome.failed:
            emit(state.copyWith(status: AuthStatus.pinLocked));
        }
      },
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
    if ((state.status != AuthStatus.authenticated &&
            state.status != AuthStatus.onboardingRequired) ||
        state.session == null) {
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
    _debugAuthEvent(
      'pin-created.submitted pinLength=${event.pin.length} '
      'sessionPresent=${state.session != null}',
    );
    if (event.pin.length != 4 || state.session == null) return;
    emit(state.copyWith(status: AuthStatus.loading, clearFailure: true));
    final result = await _createPin(event.pin);
    await result.fold<Future<void>>(
      (failure) async {
        _debugAuthEvent('pin-created.failure type=${failure.type.name}');
        emit(
          state.copyWith(status: AuthStatus.pinSetupRequired, failure: failure),
        );
      },
      (_) async {
        _debugAuthEvent('pin-created.saved');
        final profileOnboardingCompleted =
            state.profileOnboardingCompleted ||
            !state.session!.needsProfileOnboarding;
        final commit = await _commitPendingAuthSession(
          profileOnboardingCompleted: profileOnboardingCompleted,
        );
        final commitFailure = commit.fold<Failure?>(
          (failure) => failure,
          (_) => null,
        );
        if (commitFailure != null) {
          emit(
            state.copyWith(
              status: AuthStatus.pinSetupRequired,
              failure: commitFailure,
            ),
          );
          return;
        }
        await _emitPostPinGate(state.session!, emit, source: 'pin-created');
      },
    );
  }

  Future<void> _onPinUnlockRequested(
    AuthPinUnlockRequested event,
    Emitter<AuthState> emit,
  ) async {
    _debugAuthEvent(
      'pin-unlock.submitted pinLength=${event.pin.length} '
      'sessionPresent=${state.session != null}',
    );
    if (event.pin.length != 4 || state.session == null) return;
    emit(state.copyWith(status: AuthStatus.loading, clearFailure: true));
    final result = await _verifyPin(event.pin);
    await result.fold<Future<void>>(
      (failure) async {
        _debugAuthEvent('pin-unlock.failure type=${failure.type.name}');
        emit(state.copyWith(status: AuthStatus.pinLocked, failure: failure));
      },
      (isValid) async {
        _debugAuthEvent('pin-unlock.verified isValid=$isValid');
        if (isValid) {
          await _emitPostPinGate(state.session!, emit, source: 'pin-unlock');
          return;
        }
        emit(
          state.copyWith(
            status: AuthStatus.pinLocked,
            failure: _validationFailure,
          ),
        );
      },
    );
  }

  void _onOnboardingCompleted(
    AuthOnboardingCompleted event,
    Emitter<AuthState> emit,
  ) {
    final session = state.session;
    if (session == null) return;
    emit(
      AuthState(
        status: AuthStatus.authenticated,
        session: session,
        phoneNumber: state.phoneNumber,
        profileOnboardingCompleted: true,
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
    final clearAuthResult = await _clearAuthSession();
    final clearPinResult = await _clearPin();
    result.fold(
      (failure) =>
          emit(AuthState(status: AuthStatus.unauthenticated, failure: failure)),
      (_) => clearAuthResult.fold(
        (failure) => emit(
          AuthState(status: AuthStatus.unauthenticated, failure: failure),
        ),
        (_) => clearPinResult.fold(
          (failure) => emit(
            AuthState(status: AuthStatus.unauthenticated, failure: failure),
          ),
          (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
        ),
      ),
    );
  }

  Future<void> _onDeleteAccountRequested(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    _stopTelegramPolling();
    emit(state.copyWith(status: AuthStatus.loading, clearFailure: true));
    final result = await _deleteAccount();
    final deleteFailure = result.fold<Failure?>(
      (failure) => failure,
      (_) => null,
    );
    if (deleteFailure != null) {
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          failure: deleteFailure,
        ),
      );
      return;
    }

    final clearAuthResult = await _clearAuthSession();
    final clearPinResult = await _clearPin();
    clearAuthResult.fold(
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
    _debugAuthEvent('flow-cancelled -> unauthenticated');
    _stopTelegramPolling();
    _clearPendingAuthSession();
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

  Future<void> _emitPinGate(
    Session session,
    Emitter<AuthState> emit, {
    required String source,
  }) async {
    final profileOnboardingCompleted = await _isProfileOnboardingCompleted(
      source,
      session,
    );
    final pinResult = await _hasPin();
    await pinResult.fold<Future<void>>(
      (failure) async {
        _debugAuthGate(source, session, hasPin: null);
        emit(
          AuthState(
            status: AuthStatus.pinSetupRequired,
            session: session,
            failure: failure,
            profileOnboardingCompleted: profileOnboardingCompleted,
          ),
        );
      },
      (hasPin) async {
        _debugAuthGate(source, session, hasPin: hasPin);
        emit(
          AuthState(
            status: hasPin ? AuthStatus.pinLocked : AuthStatus.pinSetupRequired,
            session: session,
            phoneNumber: session.phoneNumber ?? state.phoneNumber,
            profileOnboardingCompleted: profileOnboardingCompleted,
          ),
        );
      },
    );
  }

  Future<void> _emitPostPinGate(
    Session session,
    Emitter<AuthState> emit, {
    required String source,
  }) async {
    final profileOnboardingCompleted =
        await _isPostPinProfileOnboardingCompleted(session);
    final needsOnboarding = !profileOnboardingCompleted;
    _debugAuthGate(
      source,
      session,
      decision: needsOnboarding ? 'onboarding' : 'authenticated',
    );
    if (needsOnboarding) {
      emit(
        AuthState(
          status: AuthStatus.onboardingRequired,
          session: session,
          phoneNumber: session.phoneNumber ?? state.phoneNumber,
          profileOnboardingCompleted: profileOnboardingCompleted,
        ),
      );
      return;
    }
    emit(
      AuthState(
        status: AuthStatus.authenticated,
        session: session,
        phoneNumber: session.phoneNumber ?? state.phoneNumber,
        profileOnboardingCompleted: true,
      ),
    );
  }

  Future<bool> _isProfileOnboardingCompleted(
    String source,
    Session session,
  ) async {
    if (state.profileOnboardingCompleted || !session.needsProfileOnboarding) {
      return true;
    }

    final stored = await _readStoredProfileOnboardingCompletion();
    if (stored != null) return stored;

    return source == 'restore';
  }

  Future<bool> _isPostPinProfileOnboardingCompleted(Session session) async {
    if (state.profileOnboardingCompleted) return true;

    final stored = await _readStoredProfileOnboardingCompletion();
    if (stored != null) return stored;

    return !session.needsProfileOnboarding;
  }

  Future<bool?> _readStoredProfileOnboardingCompletion() async {
    final result = await _readProfileOnboardingCompletion();
    return result.fold((_) => null, (completed) => completed);
  }

  static const _validationFailure = Failure.validation();
}

void _debugGoogleAuthLog(String message) {
  if (!kDebugMode) return;
  debugPrint('[GoogleAuth] $message');
}

void _debugAuthEvent(String message) {
  if (!kDebugMode) return;
  debugPrint('[AuthFlow] $message');
}

void _debugAuthGate(
  String source,
  Session session, {
  bool? hasPin,
  String? decision,
}) {
  if (!kDebugMode) return;
  debugPrint(
    '[AuthGate] source=$source '
    'status="${session.status ?? 'null'}" '
    'profileInfoNull=${session.profileInfo == null} '
    'candidateTypePresent=${session.candidateType?.isNotEmpty == true} '
    'needsOnboarding=${session.needsProfileOnboarding} '
    'decision=${decision ?? 'pending'} '
    'hasPin=${hasPin?.toString() ?? 'unknown'}',
  );
}
