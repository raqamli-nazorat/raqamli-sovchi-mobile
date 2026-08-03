import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';

final class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Session>> call() => _repository.signInWithGoogle();
}
