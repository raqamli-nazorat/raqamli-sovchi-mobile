import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/user_pledge.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../data_sources/onboarding_data_source.dart';

final class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._dataSource);

  final OnboardingDataSource _dataSource;

  @override
  Future<Either<Failure, void>> updateCandidateType(
    String candidateType,
  ) async {
    try {
      await _dataSource.updateCandidateType(candidateType);
      return const Right<Failure, void>(null);
    } on DioException catch (error) {
      return Left<Failure, void>(mapDioException(error));
    } on Object catch (error) {
      return Left<Failure, void>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, UserPledge>> submitPledge({
    required String userId,
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  }) async {
    try {
      return Right<Failure, UserPledge>(
        (await _dataSource.submitPledge(
          userId: userId,
          acceptedTerms: acceptedTerms,
          hasSeriousBadge: hasSeriousBadge,
        )).toEntity(),
      );
    } on DioException catch (error) {
      return Left<Failure, UserPledge>(mapDioException(error));
    } on Object catch (error) {
      return Left<Failure, UserPledge>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }
}
