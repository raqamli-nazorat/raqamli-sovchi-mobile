import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/google_authorization_result.dart';

abstract interface class GoogleOAuthProvider {
  Future<Either<Failure, GoogleAuthorizationResult>> authorize();
}
