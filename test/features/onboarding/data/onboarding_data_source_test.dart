import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/features/onboarding/data/data_sources/onboarding_data_source.dart';

void main() {
  test('patches candidate type with backend enum value', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteOnboardingDataSource(client);

    await dataSource.updateCandidateType('groom');

    expect(client.patchPath, '/api/v1/accounts/profiles/me/');
    expect(client.patchData, {'candidate_type': 'groom'});
  });

  test('posts pledge with authenticated user and both consent flags', () async {
    final client = _RecordingApiClient(
      responseData: {
        'id': 'pledge-1',
        'accepted_terms': true,
        'has_serious_badge': true,
      },
    );
    final dataSource = RemoteOnboardingDataSource(client);

    final pledge = await dataSource.submitPledge(
      userId: 'user-1',
      acceptedTerms: true,
      hasSeriousBadge: true,
    );

    expect(client.postPath, '/api/v1/accounts/pledges/');
    expect(client.postData, {
      'user': 'user-1',
      'accepted_terms': true,
      'has_serious_badge': true,
    });
    expect(pledge.id, 'pledge-1');
  });
}

final class _RecordingApiClient implements ApiClient {
  _RecordingApiClient({this.responseData = const {}});

  final Map<String, dynamic> responseData;
  String? patchPath;
  Object? patchData;
  String? postPath;
  Object? postData;

  Response<T> _response<T>(String path) {
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: responseData as T,
    );
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    patchPath = path;
    patchData = data;
    return _response<T>(path);
  }

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
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();
}
