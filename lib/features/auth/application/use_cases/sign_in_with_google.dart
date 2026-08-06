import 'package:flutter/foundation.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/google_oauth_provider.dart';

final class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase(this._repository, this._provider);

  final AuthRepository _repository;
  final GoogleOAuthProvider _provider;

  Future<Either<Failure, Session>> call() async {
    _debugGoogleAuthLog('useCase.start');
    final authorization = await _provider.authorize();
    return authorization.fold(
      (failure) {
        _debugGoogleAuthLog('useCase.providerFailure type=${failure.type}');
        return Future.value(Left<Failure, Session>(failure));
      },
      (credential) {
        _debugGoogleAuthLog(
          'useCase.providerSuccess tokenLength=${credential.idToken.length}',
        );
        _debugGoogleAuthLog('useCase.repositoryCall.start');
        return _repository.signInWithGoogle(credential: credential);
      },
    );
  }
}

void _debugGoogleAuthLog(String message) {
  if (!kDebugMode) return;
  debugPrint('[GoogleAuth] $message');
}
