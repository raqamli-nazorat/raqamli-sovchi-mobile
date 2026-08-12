import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/profile_onboarding_models.dart';
import '../models/onboarding_reference_models.dart';
import '../models/profile_onboarding_models.dart';

abstract interface class OnboardingDataSource {
  Future<ProfileBootstrapModel> createProfile(ProfileBootstrapRequest request);

  Future<ProfileBootstrapModel> getMyProfile();

  Future<ProfilePhotoModel> uploadPhoto({
    required String profileId,
    required String localFilePath,
    required int order,
    required bool isMain,
  });

  Future<List<ProfilePhotoModel>> getPhotos();

  Future<ProfilePhotoModel> setMainPhoto(String photoId);

  Future<void> deletePhoto(String photoId);

  Future<FaceVerificationResultModel> verifyFace(String localFilePath);

  Future<void> updateVoiceIntro(String localFilePath);

  Future<void> submitPledge({
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  });

  Future<ReferencePageModel<EducationLevelModel>> getEducationLevels(int page);

  Future<ReferencePageModel<RegionModel>> getRegions(int page);

  Future<ReferencePageModel<DistrictModel>> getDistricts({
    required String regionId,
    required int page,
  });
}

final class RemoteOnboardingDataSource implements OnboardingDataSource {
  const RemoteOnboardingDataSource(this._client);

  static const _profilesPath = '/api/v1/accounts/profiles/';
  static const _profileMePath = '/api/v1/accounts/profiles/me/';
  static const _photosPath = '/api/v1/accounts/photos/';
  static const _faceVerificationPath = '/api/v1/accounts/face-verify/';
  static const _pledgesPath = '/api/v1/accounts/pledges/';
  static const _educationLevelsPath = '/api/v1/references/education-levels/';
  static const _regionsPath = '/api/v1/locations/region/';
  static const _districtsPath = '/api/v1/locations/district/';

  final ApiClient _client;

  @override
  Future<ProfileBootstrapModel> createProfile(
    ProfileBootstrapRequest request,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      _profilesPath,
      data: {
        'first_name': request.firstName,
        'last_name': request.lastName,
        if (request.fatherName?.trim().isNotEmpty ?? false)
          'father_name': request.fatherName!.trim(),
        'gender': request.gender,
        'candidate_type': request.candidateType.apiValue,
        'birth_year': request.birthYear,
        'height': request.heightCm,
        'region': request.regionId,
        'district': request.districtId,
        'education_level': request.educationLevelId,
      },
    );
    return ProfileBootstrapModel.fromJson(_payload(response.data));
  }

  @override
  Future<ProfileBootstrapModel> getMyProfile() async {
    final response = await _client.get<Map<String, dynamic>>(_profileMePath);
    return ProfileBootstrapModel.fromJson(_payload(response.data));
  }

  @override
  Future<ProfilePhotoModel> uploadPhoto({
    required String profileId,
    required String localFilePath,
    required int order,
    required bool isMain,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      _photosPath,
      data: FormData.fromMap({
        'profile': profileId,
        'image': await MultipartFile.fromFile(localFilePath),
        'order': order,
        'is_main': isMain,
      }),
    );
    return ProfilePhotoModel.fromJson(_payload(response.data));
  }

  @override
  Future<List<ProfilePhotoModel>> getPhotos() async {
    final response = await _client.get<Map<String, dynamic>>(_photosPath);
    final payload = _payload(response.data);
    final values = payload['results'] ?? payload['data'] ?? payload;
    if (values is! List) return const [];
    return values
        .whereType<Map>()
        .map((item) => ProfilePhotoModel.fromJson(_map(item)))
        .toList(growable: false);
  }

  @override
  Future<ProfilePhotoModel> setMainPhoto(String photoId) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '$_photosPath$photoId/',
      data: const {'is_main': true},
    );
    return ProfilePhotoModel.fromJson(_payload(response.data));
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    await _client.delete<void>('$_photosPath$photoId/');
  }

  @override
  Future<FaceVerificationResultModel> verifyFace(String localFilePath) async {
    final response = await _client.post<Map<String, dynamic>>(
      _faceVerificationPath,
      data: FormData.fromMap({
        'image': await MultipartFile.fromFile(localFilePath),
      }),
    );
    return FaceVerificationResultModel.fromJson(_payload(response.data));
  }

  @override
  Future<void> updateVoiceIntro(String localFilePath) async {
    await _client.patch<Map<String, dynamic>>(
      _profileMePath,
      data: FormData.fromMap({
        'voice_intro': await MultipartFile.fromFile(localFilePath),
      }),
    );
  }

  @override
  Future<void> submitPledge({
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  }) async {
    await _client.post<Map<String, dynamic>>(
      _pledgesPath,
      data: {
        'accepted_terms': acceptedTerms,
        'has_serious_badge': hasSeriousBadge,
      },
    );
  }

  @override
  Future<ReferencePageModel<EducationLevelModel>> getEducationLevels(
    int page,
  ) async {
    final response = await _client.get<Map<String, dynamic>>(
      _educationLevelsPath,
      queryParameters: {'page': page},
    );
    final responsePage = _referencePage(response.data, page);
    return ReferencePageModel(
      items: responsePage.items
          .map(EducationLevelModel.fromJson)
          .toList(growable: false),
      page: page,
      hasNextPage: responsePage.hasNextPage,
    );
  }

  @override
  Future<ReferencePageModel<RegionModel>> getRegions(int page) async {
    final response = await _client.get<Map<String, dynamic>>(
      _regionsPath,
      queryParameters: {'page': page},
    );
    final responsePage = _referencePage(response.data, page);
    return ReferencePageModel(
      items: responsePage.items
          .map(RegionModel.fromJson)
          .toList(growable: false),
      page: page,
      hasNextPage: responsePage.hasNextPage,
    );
  }

  @override
  Future<ReferencePageModel<DistrictModel>> getDistricts({
    required String regionId,
    required int page,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      _districtsPath,
      queryParameters: {'region': regionId, 'page': page},
    );
    final responsePage = _referencePage(response.data, page);
    return ReferencePageModel(
      items: responsePage.items
          .map(DistrictModel.fromJson)
          .toList(growable: false),
      page: page,
      hasNextPage: responsePage.hasNextPage,
    );
  }
}

final class _RawReferencePage {
  const _RawReferencePage({required this.items, required this.hasNextPage});

  final List<Map<String, dynamic>> items;
  final bool hasNextPage;
}

_RawReferencePage _referencePage(Map<String, dynamic>? response, int page) {
  final payload = _payload(response);
  final results = payload['results'] ?? payload['data'] ?? payload;
  final items = results is List
      ? results.whereType<Map>().map(_map).toList(growable: false)
      : const <Map<String, dynamic>>[];
  return _RawReferencePage(
    items: items,
    hasNextPage:
        payload['next'] != null ||
        (payload['count'] is num &&
            (page * items.length) < (payload['count'] as num)),
  );
}

Map<String, dynamic> _payload(Map<String, dynamic>? value) {
  final map = value ?? const <String, dynamic>{};
  final data = map['data'];
  return data is Map ? _map(data) : map;
}

Map<String, dynamic> _map(Map value) {
  return value.map((key, item) => MapEntry(key.toString(), item));
}
