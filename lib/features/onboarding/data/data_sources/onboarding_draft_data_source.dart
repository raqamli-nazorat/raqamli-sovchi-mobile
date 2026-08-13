import 'dart:convert';

import '../../../../core/security/secure_storage.dart';
import '../models/profile_onboarding_draft_model.dart';

abstract interface class OnboardingDraftDataSource {
  Future<ProfileOnboardingDraftModel?> read();

  Future<void> write(ProfileOnboardingDraftModel draft);

  Future<void> clear();
}

final class SecureOnboardingDraftDataSource
    implements OnboardingDraftDataSource {
  const SecureOnboardingDraftDataSource(this._storage);

  static const _key = 'profile_onboarding_draft.v1';

  final SecureStorage _storage;

  @override
  Future<ProfileOnboardingDraftModel?> read() async {
    final value = await _storage.read(key: _key);
    if (value == null || value.isEmpty) return null;
    final decoded = jsonDecode(value);
    if (decoded is! Map) return null;
    return ProfileOnboardingDraftModel.fromJson(
      decoded.map((key, item) => MapEntry(key.toString(), item)),
    );
  }

  @override
  Future<void> write(ProfileOnboardingDraftModel draft) {
    return _storage.write(key: _key, value: jsonEncode(draft.toJson()));
  }

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
