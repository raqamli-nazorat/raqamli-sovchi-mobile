import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';

import '../../application/use_cases/clear_pin.dart';
import '../../application/use_cases/create_pin.dart';
import '../../application/use_cases/has_pin.dart';
import '../../application/use_cases/request_phone_otp.dart';
import '../../application/use_cases/restore_session.dart';
import '../../application/use_cases/sign_in_with_google.dart';
import '../../application/use_cases/sign_in_with_telegram.dart';
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
    required SignInWithTelegramUseCase signInWithTelegram,
    required HasPinUseCase hasPin,
    required CreatePinUseCase createPin,
    required VerifyPinUseCase verifyPin,
    required ClearPinUseCase clearPin,
    required SignOutUseCase signOut,
  }) : _restoreSession = restoreSession,
       _requestPhoneOtp = requestPhoneOtp,
       _verifyPhoneOtp = verifyPhoneOtp,
       _signInWithGoogle = signInWithGoogle,
       _signInWithTelegram = signInWithTelegram,
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
    on<AuthPinCreated>(_onPinCreated);
    on<AuthPinUnlockRequested>(_onPinUnlockRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthFlowCancelled>(_onFlowCancelled);
  }

  final RestoreSessionUseCase _restoreSession;
  final RequestPhoneOtpUseCase _requestPhoneOtp;
  final VerifyPhoneOtpUseCase _verifyPhoneOtp;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignInWithTelegramUseCase _signInWithTelegram;
  final HasPinUseCase _hasPin;
  final CreatePinUseCase _createPin;
  final VerifyPinUseCase _verifyPin;
  final ClearPinUseCase _clearPin;
  final SignOutUseCase _signOut;

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
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _signInWithTelegram();
    result.fold(
      (failure) =>
          emit(AuthState(status: AuthStatus.unauthenticated, failure: failure)),
      (session) => _emitPinGate(session, emit),
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
    emit(const AuthState(status: AuthStatus.unauthenticated));
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
