import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/profile_onboarding_models.dart';
import '../models/onboarding_reference_models.dart';
import '../models/profile_onboarding_models.dart';

abstract interface class OnboardingDataSource {
  Future<ProfileBootstrapModel> createProfile(ProfileBootstrapRequest request);

  Future<ProfileBootstrapModel> getMyProfile();

  Future<RepresentativeInfoModel> createRepresentativeInfo(
    RepresentativeInfoRequest request,
  );

  Future<RepresentativeInfoModel> sendRepresentativeConsent(
    RepresentativeInfoRequest request,
  );

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

  Future<void> updateProfileDetails({
    String? aboutMe,
    double? latitude,
    double? longitude,
  });

  Future<void> submitPledge({
    required String userId,
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  });

  Future<ReferencePageModel<EducationLevelModel>> getEducationLevels(int page);

  Future<ReferencePageModel<RegionModel>> getRegions(int page);

  Future<ReferencePageModel<DistrictModel>> getDistricts({
    required String regionId,
    required int page,
    String? search,
  });

  Future<ReferencePageModel<HealthStatusModel>> getHealthStatuses(int page);

  Future<ReferencePageModel<MaritalStatusModel>> getMaritalStatuses(int page);

  Future<ReferencePageModel<KinshipModel>> getKinships(int page);
}

final class RemoteOnboardingDataSource implements OnboardingDataSource {
  const RemoteOnboardingDataSource(this._client);

  static const _profilesPath = '/api/v1/accounts/profiles/';
  static const _profileMePath = '/api/v1/accounts/profiles/me/';
  static const _photosPath = '/api/v1/accounts/photos/';
  static const _faceVerificationPath = '/api/v1/accounts/face-verify/';
  static const _pledgesPath = '/api/v1/accounts/pledges/';
  static const _representativesPath = '/api/v1/accounts/representatives/';
  static const _representativeConsentPath =
      '/api/v1/accounts/representatives/send-consent-request/';
  static const _educationLevelsPath = '/api/v1/references/education-levels/';
  static const _regionsPath = '/api/v1/locations/region/';
  static const _districtsPath = '/api/v1/locations/district/';
  static const _healthStatusesPath = '/api/v1/references/health-statuses/';
  static const _maritalStatusesPath = '/api/v1/references/marital-statuses/';
  static const _kinshipsPath = '/api/v1/references/kinships/';

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
          'middle_name': request.fatherName!.trim(),
        'gender': request.gender,
        'candidate_type': request.candidateType.apiValue,
        'birth_year': request.birthYear,
        'height': request.heightCm,
        if (request.weightKg != null) 'weight': request.weightKg,
        'region': request.regionId,
        'district': request.districtId,
        if (request.healthStatusId != null)
          'health_status': request.healthStatusId,
        'education_level': request.educationLevelId,
        'marital_status': request.maritalStatusId,
        'has_children': request.hasChildren,
        'children_count': request.childrenCount,
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
  Future<RepresentativeInfoModel> createRepresentativeInfo(
    RepresentativeInfoRequest request,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      _representativesPath,
      data: _representativePayload(request),
    );
    return RepresentativeInfoModel.fromJson(_payload(response.data));
  }

  @override
  Future<RepresentativeInfoModel> sendRepresentativeConsent(
    RepresentativeInfoRequest request,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      _representativeConsentPath,
      data: _representativePayload(request),
    );
    return RepresentativeInfoModel.fromJson(_payload(response.data));
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
  Future<void> updateProfileDetails({
    String? aboutMe,
    double? latitude,
    double? longitude,
  }) async {
    final data = <String, dynamic>{};
    if (aboutMe != null) data['bio'] = aboutMe;
    if (latitude != null) data['latitude'] = latitude.toStringAsFixed(6);
    if (longitude != null) {
      data['longitude'] = longitude.toStringAsFixed(6);
    }
    await _client.patch<Map<String, dynamic>>(_profileMePath, data: data);
  }

  @override
  Future<void> submitPledge({
    required String userId,
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  }) async {
    await _client.post<Map<String, dynamic>>(
      _pledgesPath,
      data: {
        'user': userId,
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
    String? search,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      _districtsPath,
      queryParameters: {
        'region': regionId,
        'page': page,
        if (search?.trim().isNotEmpty ?? false) 'search': search!.trim(),
      },
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

  @override
  Future<ReferencePageModel<HealthStatusModel>> getHealthStatuses(
    int page,
  ) async {
    final response = await _client.get<Map<String, dynamic>>(
      _healthStatusesPath,
      queryParameters: {'page': page},
    );
    final responsePage = _referencePage(response.data, page);
    return ReferencePageModel(
      items: responsePage.items
          .map(HealthStatusModel.fromJson)
          .toList(growable: false),
      page: page,
      hasNextPage: responsePage.hasNextPage,
    );
  }

  @override
  Future<ReferencePageModel<MaritalStatusModel>> getMaritalStatuses(
    int page,
  ) async {
    final response = await _client.get<Map<String, dynamic>>(
      _maritalStatusesPath,
      queryParameters: {'page': page},
    );
    final responsePage = _referencePage(response.data, page);
    return ReferencePageModel(
      items: responsePage.items
          .map(MaritalStatusModel.fromJson)
          .toList(growable: false),
      page: page,
      hasNextPage: responsePage.hasNextPage,
    );
  }

  @override
  Future<ReferencePageModel<KinshipModel>> getKinships(int page) async {
    final response = await _client.get<Map<String, dynamic>>(
      _kinshipsPath,
      queryParameters: {'page': page},
    );
    final responsePage = _referencePage(response.data, page);
    return ReferencePageModel(
      items: responsePage.items
          .map(KinshipModel.fromJson)
          .toList(growable: false),
      page: page,
      hasNextPage: responsePage.hasNextPage,
    );
  }
}

Map<String, dynamic> _representativePayload(RepresentativeInfoRequest request) {
  return {
    'profile': request.profileId,
    'candidate_role': request.candidateType.apiValue,
    'kinship': request.kinshipId,
    if (request.candidateContact?.trim().isNotEmpty ?? false)
      'candidate_contact': request.candidateContact!.trim(),
  };
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
