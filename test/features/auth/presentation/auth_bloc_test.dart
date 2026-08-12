import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/core/security/auth_session_manager.dart';
import 'package:raqamli_sovchi/core/security/biometric_auth_service.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/authenticate_biometric.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/check_biometric_availability.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/clear_auth_session.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/clear_pending_auth_session.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/clear_pin.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/create_pin.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/create_telegram_auth_session.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/delete_account.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/get_telegram_auth_session_status.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/has_pin.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/request_phone_otp.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/restore_session.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/sign_in_with_google.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/sign_out.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/verify_phone_otp.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/verify_pin.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/current_user.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/google_authorization_result.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/session.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/telegram_auth_session.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/telegram_auth_status.dart';
import 'package:raqamli_sovchi/features/auth/domain/repositories/auth_repository.dart';
import 'package:raqamli_sovchi/features/auth/domain/repositories/google_oauth_provider.dart';
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
      pinRepository: const _FakePinRepository(),
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
      pinRepository: const _FakePinRepository(),
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

  blocTest<AuthBloc, AuthState>(
    'polls Telegram session and enters PIN setup after authentication',
    build: () => _createBloc(
      repository: _FakeAuthRepository(session: session),
      pinRepository: const _FakePinRepository(),
      telegramPollingInterval: const Duration(milliseconds: 1),
    ),
    act: (bloc) => bloc.add(const AuthTelegramSignInRequested()),
    expect: () => [
      const AuthState(status: AuthStatus.loading),
      const AuthState(status: AuthStatus.telegramPending),
      const AuthState(
        status: AuthStatus.pinSetupRequired,
        session: session,
        phoneNumber: '+998901234567',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'signs in with Google and enters PIN setup',
    build: () => _createBloc(
      repository: _FakeAuthRepository(session: session),
      pinRepository: const _FakePinRepository(),
    ),
    act: (bloc) => bloc.add(const AuthGoogleSignInRequested()),
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
    'routes a newly created PIN to onboarding for an incomplete profile',
    build: () => _createBloc(
      repository: _FakeAuthRepository(
        session: const Session(
          userId: 'user-1',
          displayName: 'Test User',
          status: 'Anketa to‘liq emas',
        ),
      ),
      pinRepository: const _FakePinRepository(),
    ),
    seed: () => const AuthState(
      status: AuthStatus.pinSetupRequired,
      session: Session(
        userId: 'user-1',
        displayName: 'Test User',
        status: 'Anketa to‘liq emas',
      ),
    ),
    act: (bloc) => bloc.add(const AuthPinCreated('1234')),
    expect: () => [
      const AuthState(
        status: AuthStatus.loading,
        session: Session(
          userId: 'user-1',
          displayName: 'Test User',
          status: 'Anketa to‘liq emas',
        ),
      ),
      const AuthState(
        status: AuthStatus.onboardingRequired,
        session: Session(
          userId: 'user-1',
          displayName: 'Test User',
          status: 'Anketa to‘liq emas',
        ),
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'locks authenticated session on app resume when local PIN exists',
    build: () => _createBloc(
      repository: _FakeAuthRepository(session: session),
      pinRepository: const _FakePinRepository(hasPin: true),
    ),
    seed: () => const AuthState(
      status: AuthStatus.authenticated,
      session: session,
      phoneNumber: '+998901234567',
    ),
    act: (bloc) => bloc.add(const AuthApplicationResumed()),
    expect: () => [
      const AuthState(
        status: AuthStatus.pinLocked,
        session: session,
        phoneNumber: '+998901234567',
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'deletes account and clears local session state',
    build: () => _createBloc(
      repository: _FakeAuthRepository(session: session),
      pinRepository: const _FakePinRepository(hasPin: true),
    ),
    seed: () => const AuthState(
      status: AuthStatus.authenticated,
      session: session,
      phoneNumber: '+998901234567',
    ),
    act: (bloc) => bloc.add(const AuthDeleteAccountRequested()),
    expect: () => [
      const AuthState(
        status: AuthStatus.loading,
        session: session,
        phoneNumber: '+998901234567',
      ),
      const AuthState(status: AuthStatus.unauthenticated),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'routes an incomplete account to onboarding after PIN unlock',
    build: () => _createBloc(
      repository: _FakeAuthRepository(
        session: const Session(
          userId: 'user-1',
          displayName: 'Test User',
          status: "Anketa to'liq emas",
        ),
      ),
      pinRepository: const _FakePinRepository(hasPin: true),
    ),
    seed: () => const AuthState(
      status: AuthStatus.pinLocked,
      session: Session(
        userId: 'user-1',
        displayName: 'Test User',
        status: "Anketa to'liq emas",
      ),
    ),
    act: (bloc) => bloc.add(const AuthPinUnlockRequested('1234')),
    expect: () => [
      const AuthState(
        status: AuthStatus.loading,
        session: Session(
          userId: 'user-1',
          displayName: 'Test User',
          status: "Anketa to'liq emas",
        ),
      ),
      const AuthState(
        status: AuthStatus.onboardingRequired,
        session: Session(
          userId: 'user-1',
          displayName: 'Test User',
          status: "Anketa to'liq emas",
        ),
      ),
    ],
  );
}

AuthBloc _createBloc({
  required _FakeAuthRepository repository,
  required _FakePinRepository pinRepository,
  Duration telegramPollingInterval = const Duration(seconds: 2),
}) {
  return AuthBloc(
    restoreSession: RestoreSessionUseCase(repository),
    requestPhoneOtp: RequestPhoneOtpUseCase(repository),
    verifyPhoneOtp: VerifyPhoneOtpUseCase(repository),
    signInWithGoogle: SignInWithGoogleUseCase(
      repository,
      const _FakeGoogleOAuthProvider(),
    ),
    createTelegramAuthSession: CreateTelegramAuthSessionUseCase(repository),
    getTelegramAuthSessionStatus: GetTelegramAuthSessionStatusUseCase(
      repository,
    ),
    checkBiometricAvailability: CheckBiometricAvailabilityUseCase(
      _FakeBiometricAuthService(),
    ),
    authenticateBiometric: AuthenticateBiometricUseCase(
      _FakeBiometricAuthService(),
      _FakeTokenStore(hasToken: true),
    ),
    hasPin: HasPinUseCase(pinRepository),
    createPin: CreatePinUseCase(pinRepository),
    verifyPin: VerifyPinUseCase(pinRepository),
    clearPin: ClearPinUseCase(pinRepository),
    signOut: SignOutUseCase(repository),
    deleteAccount: DeleteAccountUseCase(repository),
    clearAuthSession: ClearAuthSessionUseCase(
      DefaultAuthSessionManager(_FakeTokenStore(hasToken: true)),
    ),
    clearPendingAuthSession: ClearPendingAuthSessionUseCase(
      DefaultAuthSessionManager(_FakeTokenStore(hasToken: true)),
    ),
    telegramPollingInterval: telegramPollingInterval,
  );
}

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.session});

  final Session? session;

  @override
  Future<Either<Failure, Session?>> restoreSession() async =>
      Right<Failure, Session?>(session);

  @override
  Future<Either<Failure, Session?>> requestPhoneOtp(String phoneNumber) async =>
      const Right<Failure, Session?>(null);

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
  Future<Either<Failure, Session>> signInWithGoogle({
    required GoogleAuthorizationResult credential,
  }) async => Right<Failure, Session>(session!);

  @override
  Future<Either<Failure, TelegramAuthSession>>
  createTelegramAuthSession() async =>
      const Right<Failure, TelegramAuthSession>(
        TelegramAuthSession(
          sessionId: 'telegram-session',
          status: 'pending',
          botUrl: 'https://t.me/example?start=telegram-session',
        ),
      );

  @override
  Future<Either<Failure, TelegramAuthStatus>> getTelegramAuthSessionStatus(
    String sessionId,
  ) async => Right<Failure, TelegramAuthStatus>(
    TelegramAuthStatus(status: 'authenticated', session: session),
  );

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

final class _FakeGoogleOAuthProvider implements GoogleOAuthProvider {
  const _FakeGoogleOAuthProvider();

  @override
  Future<Either<Failure, GoogleAuthorizationResult>> authorize() async =>
      const Right<Failure, GoogleAuthorizationResult>(
        GoogleAuthorizationResult(idToken: 'id-token'),
      );
}

final class _FakePinRepository implements PinRepository {
  const _FakePinRepository({bool hasPin = false}) : _hasPin = hasPin;

  final bool _hasPin;

  @override
  Future<Either<Failure, bool>> hasPin() async => Right<Failure, bool>(_hasPin);

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

final class _FakeBiometricAuthService implements BiometricAuthService {
  @override
  Future<BiometricAvailability> checkAvailability() async =>
      BiometricAvailability.available;

  @override
  Future<BiometricAuthResult> authenticate() async =>
      BiometricAuthResult.success;
}

final class _FakeTokenStore implements TokenStore {
  _FakeTokenStore({required this.hasToken});

  final bool hasToken;

  @override
  Future<String?> readAccessToken() async => hasToken ? 'access' : null;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {}

  @override
  Future<void> clear() async {}
}
