import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/features/onboarding/data/data_sources/onboarding_data_source.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/candidate_type.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/profile_onboarding_models.dart';

void main() {
  test(
    'bootstraps a profile without client-owned user or weight fields',
    () async {
      final client = _RecordingApiClient(responseData: {'id': 'profile-1'});
      final dataSource = RemoteOnboardingDataSource(client);

      await dataSource.createProfile(
        const ProfileBootstrapRequest(
          firstName: 'Ali',
          lastName: 'Valiyev',
          candidateType: CandidateType.groom,
          birthYear: 1995,
          heightCm: 178,
          regionId: 'region-1',
          districtId: 'district-1',
          educationLevelId: 'education-1',
        ),
      );

      expect(client.postPath, '/api/v1/accounts/profiles/');
      expect(client.postData, {
        'first_name': 'Ali',
        'last_name': 'Valiyev',
        'gender': 'male',
        'candidate_type': 'groom',
        'birth_year': 1995,
        'height': 178,
        'region': 'region-1',
        'district': 'district-1',
        'education_level': 'education-1',
      });
    },
  );

  test('posts pledge with consent flags and without a user field', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteOnboardingDataSource(client);

    await dataSource.submitPledge(acceptedTerms: true, hasSeriousBadge: false);

    expect(client.postPath, '/api/v1/accounts/pledges/');
    expect(client.postData, {
      'accepted_terms': true,
      'has_serious_badge': false,
    });
  });

  test('uploads a photo with the bootstrapped profile id', () async {
    final client = _RecordingApiClient(responseData: {'id': 'photo-1'});
    final dataSource = RemoteOnboardingDataSource(client);
    final directory = await Directory.systemTemp.createTemp('onboarding');
    final file = File('${directory.path}/photo.jpg');
    await file.writeAsBytes([1, 2, 3]);

    try {
      await dataSource.uploadPhoto(
        profileId: 'profile-1',
        localFilePath: file.path,
        order: 1,
        isMain: true,
      );

      final formData = client.postData! as FormData;
      final fields = {
        for (final field in formData.fields) field.key: field.value,
      };
      expect(client.postPath, '/api/v1/accounts/photos/');
      expect(fields, {'profile': 'profile-1', 'order': '1', 'is_main': 'true'});
      expect(formData.files.single.key, 'image');
    } finally {
      await directory.delete(recursive: true);
    }
  });
}

final class _RecordingApiClient implements ApiClient {
  _RecordingApiClient({this.responseData = const {}});

  final Map<String, dynamic> responseData;
  String? postPath;
  Object? postData;

  Response<T> _response<T>(String path) => Response<T>(
    requestOptions: RequestOptions(path: path),
    data: responseData as T,
  );

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    postPath = path;
    postData = data;
    return _response<T>(path);
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();
}
