import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_client.dart';
import '../../core/security/screenshot_guard.dart';
import '../../core/security/secure_storage.dart';
import '../../core/security/token_store.dart';
import '../../features/auth/application/use_cases/clear_pin.dart';
import '../../features/auth/application/use_cases/create_pin.dart';
import '../../features/auth/application/use_cases/has_pin.dart';
import '../../features/auth/application/use_cases/obtain_token.dart';
import '../../features/auth/application/use_cases/request_phone_otp.dart';
import '../../features/auth/application/use_cases/restore_session.dart';
import '../../features/auth/application/use_cases/sign_in_with_google.dart';
import '../../features/auth/application/use_cases/sign_in_with_telegram.dart';
import '../../features/auth/application/use_cases/sign_out.dart';
import '../../features/auth/application/use_cases/verify_phone_otp.dart';
import '../../features/auth/application/use_cases/verify_pin.dart';
import '../../features/auth/data/data_sources/auth_data_source.dart';
import '../../features/auth/data/data_sources/secure_pin_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/pin_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/pin_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies() async {
  if (serviceLocator.isRegistered<AuthBloc>()) return;

  serviceLocator
    ..registerLazySingleton<SecureStorage>(
      () => const FlutterSecureStorageAdapter(FlutterSecureStorage()),
    )
    ..registerLazySingleton<TokenStore>(
      () => SecureTokenStore(serviceLocator()),
    )
    ..registerLazySingleton<ScreenshotGuard>(SecureScreenshotGuard.new)
    ..registerLazySingleton<ApiClient>(
      () => DioApiClient(
        tokenStore: serviceLocator(),
        client: Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 30),
          ),
        ),
      ),
    )
    ..registerLazySingleton<AuthDataSource>(
      () => AppConfig.useTemporaryAuthAdapter
          ? TemporaryAuthDataSource(serviceLocator())
          : RemoteAuthDataSource(
              client: serviceLocator(),
              tokenStore: serviceLocator(),
            ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<PinDataSource>(
      () => SecurePinDataSource(serviceLocator()),
    )
    ..registerLazySingleton<PinRepository>(
      () => PinRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<RestoreSessionUseCase>(
      () => RestoreSessionUseCase(serviceLocator()),
    )
    ..registerFactory<RequestPhoneOtpUseCase>(
      () => RequestPhoneOtpUseCase(serviceLocator()),
    )
    ..registerFactory<ObtainTokenUseCase>(
      () => ObtainTokenUseCase(serviceLocator()),
    )
    ..registerFactory<VerifyPhoneOtpUseCase>(
      () => VerifyPhoneOtpUseCase(serviceLocator()),
    )
    ..registerFactory<SignInWithGoogleUseCase>(
      () => SignInWithGoogleUseCase(serviceLocator()),
    )
    ..registerFactory<SignInWithTelegramUseCase>(
      () => SignInWithTelegramUseCase(serviceLocator()),
    )
    ..registerFactory<HasPinUseCase>(() => HasPinUseCase(serviceLocator()))
    ..registerFactory<CreatePinUseCase>(
      () => CreatePinUseCase(serviceLocator()),
    )
    ..registerFactory<VerifyPinUseCase>(
      () => VerifyPinUseCase(serviceLocator()),
    )
    ..registerFactory<ClearPinUseCase>(() => ClearPinUseCase(serviceLocator()))
    ..registerFactory<SignOutUseCase>(() => SignOutUseCase(serviceLocator()))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        restoreSession: serviceLocator(),
        requestPhoneOtp: serviceLocator(),
        verifyPhoneOtp: serviceLocator(),
        signInWithGoogle: serviceLocator(),
        signInWithTelegram: serviceLocator(),
        hasPin: serviceLocator(),
        createPin: serviceLocator(),
        verifyPin: serviceLocator(),
        clearPin: serviceLocator(),
        signOut: serviceLocator(),
      ),
    );
}

Future<void> resetDependencies() => serviceLocator.reset();
