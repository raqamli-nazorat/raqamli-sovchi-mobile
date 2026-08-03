import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/pin_repository.dart';
import '../data_sources/secure_pin_data_source.dart';

final class PinRepositoryImpl implements PinRepository {
  const PinRepositoryImpl(this._dataSource);

  final PinDataSource _dataSource;

  @override
  Future<Either<Failure, bool>> hasPin() async {
    try {
      final pin = await _dataSource.readPin();
      return Right<Failure, bool>(pin != null && pin.isNotEmpty);
    } on Object catch (error) {
      return Left<Failure, bool>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> savePin(String pin) async {
    try {
      await _dataSource.savePin(pin);
      return const Right<Failure, void>(null);
    } on Object catch (error) {
      return Left<Failure, void>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPin(String pin) async {
    try {
      final savedPin = await _dataSource.readPin();
      return Right<Failure, bool>(savedPin == pin);
    } on Object catch (error) {
      return Left<Failure, bool>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearPin() async {
    try {
      await _dataSource.clearPin();
      return const Right<Failure, void>(null);
    } on Object catch (error) {
      return Left<Failure, void>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }
}
