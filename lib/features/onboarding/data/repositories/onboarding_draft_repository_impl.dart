import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import '../../domain/repositories/onboarding_draft_repository.dart';
import '../data_sources/onboarding_draft_data_source.dart';
import '../models/profile_onboarding_draft_model.dart';

final class OnboardingDraftRepositoryImpl implements OnboardingDraftRepository {
  const OnboardingDraftRepositoryImpl(this._dataSource);

  final OnboardingDraftDataSource _dataSource;

  @override
  Future<Either<Failure, ProfileOnboardingDraft?>> load(
    String ownerUserId,
  ) async {
    try {
      final draft = (await _dataSource.read())?.draft;
      if (draft == null || draft.ownerUserId != ownerUserId) {
        return const Right<Failure, ProfileOnboardingDraft?>(null);
      }
      return Right<Failure, ProfileOnboardingDraft?>(draft);
    } on Object catch (error) {
      return Left<Failure, ProfileOnboardingDraft?>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> save(ProfileOnboardingDraft draft) async {
    try {
      await _dataSource.write(ProfileOnboardingDraftModel(draft));
      return const Right<Failure, void>(null);
    } on Object catch (error) {
      return Left<Failure, void>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clear() async {
    try {
      await _dataSource.clear();
      return const Right<Failure, void>(null);
    } on Object catch (error) {
      return Left<Failure, void>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }
}
