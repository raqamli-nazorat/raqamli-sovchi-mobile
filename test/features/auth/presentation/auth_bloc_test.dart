import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/clear_pin.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/create_pin.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/has_pin.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/request_phone_otp.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/restore_session.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/sign_in_with_google.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/sign_in_with_telegram.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/sign_out.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/verify_phone_otp.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/verify_pin.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/current_user.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/session.dart';
import 'package:raqamli_sovchi/features/auth/domain/repositories/auth_repository.dart';
import 'package:raqamli_sovchi/features/auth/domain/repositories/pin_repository.dart';
import 'package:raqamli_sovchi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:raqamli_sovchi/features/auth/presentation/bloc/auth_event.dart';
import 'package:raqamli_sovchi/features/auth/presentation/bloc/auth_state.dart';

void main() {
  const session = Session(
    userId: 'user-1',
    displayName: 'Test User',
    phoneNumber: '+998901234567',
  );

  blocTest<AuthBloc, AuthState>(
    'restores session and requires PIN setup when no local PIN exists',
    build: () => _createBloc(
      repository: _FakeAuthRepository(session: session),
      pinRepository: _FakePinRepository(),
    ),
    act: (bloc) => bloc.add(const AuthStarted()),
    expect: () => [
      const AuthState(status: AuthStatus.loading),
      const AuthState(
        status: AuthStatus.pinSetupRequired,
        session: session,
        phoneNumber: '+998901234567',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'moves from phone to OTP and then PIN setup',
    build: () => _createBloc(
      repository: _FakeAuthRepository(session: session),
      pinRepository: _FakePinRepository(),
    ),
    act: (bloc) async {
      bloc.add(const AuthPhoneSubmitted('+998901234567'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const AuthOtpSubmitted('1234'));
    },
    expect: () => [
      const AuthState(status: AuthStatus.loading, phoneNumber: '+998901234567'),
      const AuthState(
        status: AuthStatus.otpPending,
        phoneNumber: '+998901234567',
      ),
      const AuthState(status: AuthStatus.loading, phoneNumber: '+998901234567'),
      const AuthState(
        status: AuthStatus.pinSetupRequired,
        session: session,
        phoneNumber: '+998901234567',
      ),
    ],
  );
}

AuthBloc _createBloc({
  required _FakeAuthRepository repository,
  required _FakePinRepository pinRepository,
}) {
  return AuthBloc(
    restoreSession: RestoreSessionUseCase(repository),
    requestPhoneOtp: RequestPhoneOtpUseCase(repository),
    verifyPhoneOtp: VerifyPhoneOtpUseCase(repository),
    signInWithGoogle: SignInWithGoogleUseCase(repository),
    signInWithTelegram: SignInWithTelegramUseCase(repository),
    hasPin: HasPinUseCase(pinRepository),
    createPin: CreatePinUseCase(pinRepository),
    verifyPin: VerifyPinUseCase(pinRepository),
    clearPin: ClearPinUseCase(pinRepository),
    signOut: SignOutUseCase(repository),
  );
}

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.session});

  final Session? session;

  @override
  Future<Either<Failure, Session?>> restoreSession() async =>
      Right<Failure, Session?>(session);

  @override
  Future<Either<Failure, void>> requestPhoneOtp(String phoneNumber) async =>
      const Right<Failure, void>(null);

  @override
  Future<Either<Failure, Session>> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async => Right<Failure, Session>(session!);

  @override
  Future<Either<Failure, Session>> obtainToken({
    required String phoneNumber,
    required String password,
  }) async => Right<Failure, Session>(session!);

  @override
  Future<Either<Failure, Session>> signInWithGoogle() async =>
      Right<Failure, Session>(session!);

  @override
  Future<Either<Failure, Session>> signInWithTelegram() async =>
      Right<Failure, Session>(session!);

  @override
  Future<Either<Failure, CurrentUser>> getCurrentUser() async =>
      const Left<Failure, CurrentUser>(Failure.unknown());

  @override
  Future<Either<Failure, void>> refreshSession() async =>
      const Right<Failure, void>(null);

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async => const Right<Failure, void>(null);

  @override
  Future<Either<Failure, void>> deleteAccount() async =>
      const Right<Failure, void>(null);

  @override
  Future<Either<Failure, void>> signOut() async =>
      const Right<Failure, void>(null);
}

final class _FakePinRepository implements PinRepository {
  @override
  Future<Either<Failure, bool>> hasPin() async =>
      const Right<Failure, bool>(false);

  @override
  Future<Either<Failure, void>> savePin(String pin) async =>
      const Right<Failure, void>(null);

  @override
  Future<Either<Failure, bool>> verifyPin(String pin) async =>
      const Right<Failure, bool>(true);

  @override
  Future<Either<Failure, void>> clearPin() async =>
      const Right<Failure, void>(null);
}
