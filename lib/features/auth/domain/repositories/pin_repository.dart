import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';

abstract interface class PinRepository {
  Future<Either<Failure, bool>> hasPin();

  Future<Either<Failure, void>> savePin(String pin);

  Future<Either<Failure, bool>> verifyPin(String pin);

  Future<Either<Failure, void>> clearPin();
}
