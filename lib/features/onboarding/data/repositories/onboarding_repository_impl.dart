import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/onboarding_reference.dart';
import '../../domain/entities/profile_onboarding_models.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../data_sources/onboarding_data_source.dart';

final class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._dataSource);

  final OnboardingDataSource _dataSource;

  @override
  Future<Either<Failure, ProfileBootstrap>> createProfile(
    ProfileBootstrapRequest request,
  ) => _call(() async => (await _dataSource.createProfile(request)).toEntity());

  @override
  Future<Either<Failure, ProfileBootstrap>> getMyProfile() {
    return _call(() async => (await _dataSource.getMyProfile()).toEntity());
  }

  @override
  Future<Either<Failure, RepresentativeInfo>> createRepresentativeInfo(
    RepresentativeInfoRequest request,
  ) {
    return _call(
      () async =>
          (await _dataSource.createRepresentativeInfo(request)).toEntity(),
    );
  }

  @override
  Future<Either<Failure, RepresentativeInfo>> sendRepresentativeConsent(
    RepresentativeInfoRequest request,
  ) {
    return _call(
      () async =>
          (await _dataSource.sendRepresentativeConsent(request)).toEntity(),
    );
  }

  @override
  Future<Either<Failure, ProfilePhoto>> uploadPhoto({
    required String profileId,
    required String localFilePath,
    required int order,
    required bool isMain,
  }) {
    return _call(
      () async => (await _dataSource.uploadPhoto(
        profileId: profileId,
        localFilePath: localFilePath,
        order: order,
        isMain: isMain,
      )).toEntity(),
    );
  }

  @override
  Future<Either<Failure, List<ProfilePhoto>>> getPhotos() {
    return _call(
      () async => (await _dataSource.getPhotos())
          .map((photo) => photo.toEntity())
          .toList(growable: false),
    );
  }

  @override
  Future<Either<Failure, ProfilePhoto>> setMainPhoto(String photoId) {
    return _call(
      () async => (await _dataSource.setMainPhoto(photoId)).toEntity(),
    );
  }

  @override
  Future<Either<Failure, void>> deletePhoto(String photoId) {
    return _voidCall(() => _dataSource.deletePhoto(photoId));
  }

  @override
  Future<Either<Failure, FaceVerificationResult>> verifyFace(
    String localFilePath,
  ) {
    return _call(
      () async => (await _dataSource.verifyFace(localFilePath)).toEntity(),
    );
  }

  @override
  Future<Either<Failure, void>> updateVoiceIntro(String localFilePath) {
    return _voidCall(() => _dataSource.updateVoiceIntro(localFilePath));
  }

  @override
  Future<Either<Failure, void>> updateProfileDetails({
    String? aboutMe,
    double? latitude,
    double? longitude,
  }) {
    return _voidCall(
      () => _dataSource.updateProfileDetails(
        aboutMe: aboutMe,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> submitPledge({
    required String userId,
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  }) {
    return _voidCall(
      () => _dataSource.submitPledge(
        userId: userId,
        acceptedTerms: acceptedTerms,
        hasSeriousBadge: hasSeriousBadge,
      ),
    );
  }

  @override
  Future<Either<Failure, ReferencePage<EducationLevel>>> getEducationLevels(
    int page,
  ) {
    return _call(() async {
      final result = await _dataSource.getEducationLevels(page);
      return ReferencePage(
        items: result.items
            .map((item) => item.toEntity())
            .toList(growable: false),
        page: result.page,
        hasNextPage: result.hasNextPage,
      );
    });
  }

  @override
  Future<Either<Failure, ReferencePage<Region>>> getRegions(int page) {
    return _call(() async {
      final result = await _dataSource.getRegions(page);
      return ReferencePage(
        items: result.items
            .map((item) => item.toEntity())
            .toList(growable: false),
        page: result.page,
        hasNextPage: result.hasNextPage,
      );
    });
  }

  @override
  Future<Either<Failure, ReferencePage<District>>> getDistricts({
    required String regionId,
    required int page,
    String? search,
  }) {
    return _call(() async {
      final result = await _dataSource.getDistricts(
        regionId: regionId,
        page: page,
        search: search,
      );
      return ReferencePage(
        items: result.items
            .map((item) => item.toEntity())
            .toList(growable: false),
        page: result.page,
        hasNextPage: result.hasNextPage,
      );
    });
  }

  @override
  Future<Either<Failure, ReferencePage<HealthStatus>>> getHealthStatuses(
    int page,
  ) {
    return _call(() async {
      final result = await _dataSource.getHealthStatuses(page);
      return ReferencePage(
        items: result.items
            .map((item) => item.toEntity())
            .toList(growable: false),
        page: result.page,
        hasNextPage: result.hasNextPage,
      );
    });
  }

  @override
  Future<Either<Failure, ReferencePage<MaritalStatus>>> getMaritalStatuses(
    int page,
  ) {
    return _call(() async {
      final result = await _dataSource.getMaritalStatuses(page);
      return ReferencePage(
        items: result.items
            .map((item) => item.toEntity())
            .toList(growable: false),
        page: result.page,
        hasNextPage: result.hasNextPage,
      );
    });
  }

  @override
  Future<Either<Failure, ReferencePage<Kinship>>> getKinships(int page) {
    return _call(() async {
      final result = await _dataSource.getKinships(page);
      return ReferencePage(
        items: result.items
            .map((item) => item.toEntity())
            .toList(growable: false),
        page: result.page,
        hasNextPage: result.hasNextPage,
      );
    });
  }

  Future<Either<Failure, T>> _call<T>(Future<T> Function() call) async {
    try {
      return Right<Failure, T>(await call());
    } on DioException catch (error) {
      return Left<Failure, T>(mapDioException(error));
    } on Object catch (error) {
      return Left<Failure, T>(
        Failure.unknown(technicalReason: error.toString()),
      );
    }
  }

  Future<Either<Failure, void>> _voidCall(Future<void> Function() call) async {
    return _call<void>(call);
  }
}
