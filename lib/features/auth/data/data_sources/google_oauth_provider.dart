import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/google_authorization_result.dart';
import '../../domain/repositories/google_oauth_provider.dart';

abstract interface class GoogleSignInFacade {
  Future<String?> requestServerAuthCode({
    required String serverClientId,
    required List<String> scopes,
  });
}

final class PluginGoogleSignInFacade implements GoogleSignInFacade {
  PluginGoogleSignInFacade({GoogleSignIn? signIn})
    : _signIn = signIn ?? GoogleSignIn.instance;

  final GoogleSignIn _signIn;
  String? _initializedServerClientId;

  @override
  Future<String?> requestServerAuthCode({
    required String serverClientId,
    required List<String> scopes,
  }) async {
    _debugGoogleAuthLog(
      'facade.requestServerAuthCode.start serverClientIdPresent=${serverClientId.isNotEmpty} scopes=${scopes.length}',
    );
    await _initialize(serverClientId);

    if (!_signIn.supportsAuthenticate()) {
      _debugGoogleAuthLog('facade.supportsAuthenticate=false');
      throw UnsupportedError('Google Sign-In authenticate is unsupported.');
    }

    _debugGoogleAuthLog('facade.authenticate.start');
    final account = await _signIn.authenticate(scopeHint: scopes);
    _debugGoogleAuthLog('facade.authenticate.success');
    _debugGoogleAuthLog('facade.authorizeServer.start');
    final authorization = await account.authorizationClient.authorizeServer(
      scopes,
    );
    _debugGoogleAuthLog(
      'facade.authorizeServer.done codePresent=${authorization?.serverAuthCode.isNotEmpty ?? false} codeLength=${authorization?.serverAuthCode.length ?? 0}',
    );
    return authorization?.serverAuthCode;
  }

  Future<void> _initialize(String serverClientId) async {
    if (_initializedServerClientId != null) {
      _debugGoogleAuthLog('facade.initialize.skipAlreadyInitialized');
      return;
    }

    _debugGoogleAuthLog('facade.initialize.start');
    await _signIn.initialize(serverClientId: serverClientId);
    _initializedServerClientId = serverClientId;
    _debugGoogleAuthLog('facade.initialize.done');
  }
}

final class GoogleSignInOAuthProvider implements GoogleOAuthProvider {
  GoogleSignInOAuthProvider({
    String? serverClientId,
    GoogleSignInFacade? signIn,
  }) : _serverClientId =
           serverClientId ?? AppConfig.resolvedGoogleServerClientId,
       _signIn = signIn ?? PluginGoogleSignInFacade();

  static const _scopes = ['openid', 'email', 'profile'];

  final String _serverClientId;
  final GoogleSignInFacade _signIn;

  @override
  Future<Either<Failure, GoogleAuthorizationResult>> authorize() async {
    final serverClientId = _serverClientId.trim();
    _debugGoogleAuthLog(
      'provider.authorize.start serverClientIdPresent=${serverClientId.isNotEmpty}',
    );
    if (serverClientId.isEmpty) {
      _debugGoogleAuthLog('provider.authorize.configurationMissing');
      return const Left<Failure, GoogleAuthorizationResult>(
        Failure.configuration(),
      );
    }

    try {
      final code = await _signIn.requestServerAuthCode(
        serverClientId: serverClientId,
        scopes: _scopes,
      );

      if (code == null || code.isEmpty) {
        _debugGoogleAuthLog('provider.authorize.missingServerAuthCode');
        return const Left<Failure, GoogleAuthorizationResult>(
          Failure.configuration(),
        );
      }

      _debugGoogleAuthLog(
        'provider.authorize.success codeLength=${code.length}',
      );
      return Right<Failure, GoogleAuthorizationResult>(
        GoogleAuthorizationResult(authorizationCode: code),
      );
    } on GoogleSignInException catch (error) {
      _debugGoogleAuthLog(
        'provider.authorize.googleException code=${error.code} description=${_redactGoogleAuthDebugValue(error.description)} details=${_redactGoogleAuthDebugValue(error.details?.toString())}',
      );
      return Left<Failure, GoogleAuthorizationResult>(
        _mapGoogleSignInException(error),
      );
    } on UnsupportedError {
      _debugGoogleAuthLog('provider.authorize.unsupported');
      return const Left<Failure, GoogleAuthorizationResult>(
        Failure.unsupported(),
      );
    } on Exception catch (error) {
      _debugGoogleAuthLog(
        'provider.authorize.exception type=${error.runtimeType}',
      );
      return Left<Failure, GoogleAuthorizationResult>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  Failure _mapGoogleSignInException(GoogleSignInException error) {
    switch (error.code) {
      case GoogleSignInExceptionCode.canceled:
      case GoogleSignInExceptionCode.interrupted:
        return const Failure.cancelled();
      case GoogleSignInExceptionCode.uiUnavailable:
        return const Failure.unsupported();
      case GoogleSignInExceptionCode.clientConfigurationError:
      case GoogleSignInExceptionCode.providerConfigurationError:
        return const Failure.configuration();
      case GoogleSignInExceptionCode.userMismatch:
        return const Failure.validation();
      case GoogleSignInExceptionCode.unknownError:
        return Failure.unknown(technicalReason: error.description);
    }
  }
}

void _debugGoogleAuthLog(String message) {
  if (!kDebugMode) return;
  debugPrint('[GoogleAuth] $message');
}

String _redactGoogleAuthDebugValue(String? value) {
  if (value == null || value.isEmpty) return 'null';
  return value
      .replaceAll(RegExp(r'[\w.+-]+@[\w.-]+\.\w+'), '<email>')
      .replaceAll(
        RegExp(r'\b[\w-]+\.apps\.googleusercontent\.com\b'),
        '<client-id>',
      );
}
