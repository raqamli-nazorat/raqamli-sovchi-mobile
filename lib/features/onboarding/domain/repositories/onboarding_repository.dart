import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/onboarding_reference.dart';
import '../entities/profile_onboarding_models.dart';

abstract interface class OnboardingRepository {
  Future<Either<Failure, ProfileBootstrap>> createProfile(
    ProfileBootstrapRequest request,
  );

  Future<Either<Failure, ProfileBootstrap>> getMyProfile();

  Future<Either<Failure, ProfilePhoto>> uploadPhoto({
    required String profileId,
    required String localFilePath,
    required int order,
    required bool isMain,
  });

  Future<Either<Failure, List<ProfilePhoto>>> getPhotos();

  Future<Either<Failure, ProfilePhoto>> setMainPhoto(String photoId);

  Future<Either<Failure, void>> deletePhoto(String photoId);

  Future<Either<Failure, FaceVerificationResult>> verifyFace(
    String localFilePath,
  );

  Future<Either<Failure, void>> updateVoiceIntro(String localFilePath);

  Future<Either<Failure, void>> submitPledge({
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  });

  Future<Either<Failure, ReferencePage<EducationLevel>>> getEducationLevels(
    int page,
  );

  Future<Either<Failure, ReferencePage<Region>>> getRegions(int page);

  Future<Either<Failure, ReferencePage<District>>> getDistricts({
    required String regionId,
    required int page,
    String? search,
  });

  Future<Either<Failure, ReferencePage<HealthStatus>>> getHealthStatuses(
    int page,
  );

  Future<Either<Failure, ReferencePage<MaritalStatus>>> getMaritalStatuses(
    int page,
  );
}
