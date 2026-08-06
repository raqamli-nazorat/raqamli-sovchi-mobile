import '../../../../core/network/api_client.dart';
import '../models/user_pledge_model.dart';

abstract interface class OnboardingDataSource {
  Future<void> updateCandidateType(String candidateType);

  Future<UserPledgeModel> submitPledge({
    required String userId,
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  });
}

final class RemoteOnboardingDataSource implements OnboardingDataSource {
  const RemoteOnboardingDataSource(this._client);

  static const _profilePath = '/api/v1/accounts/profiles/me/';
  static const _pledgePath = '/api/v1/accounts/pledges/';

  final ApiClient _client;

  @override
  Future<void> updateCandidateType(String candidateType) async {
    await _client.patch<Map<String, dynamic>>(
      _profilePath,
      data: {'candidate_type': candidateType},
    );
  }

  @override
  Future<UserPledgeModel> submitPledge({
    required String userId,
    required bool acceptedTerms,
    required bool hasSeriousBadge,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      _pledgePath,
      data: {
        'user': userId,
        'accepted_terms': acceptedTerms,
        'has_serious_badge': hasSeriousBadge,
      },
    );
    final data = response.data ?? const <String, dynamic>{};
    final payload = data['data'];
    return UserPledgeModel.fromJson(payload is Map ? _asMap(payload) : data);
  }
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  return value.map((key, value) => MapEntry(key.toString(), value));
}
