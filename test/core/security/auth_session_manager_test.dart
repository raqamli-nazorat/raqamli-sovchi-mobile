import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/security/auth_session_manager.dart';
import 'package:raqamli_sovchi/core/security/secure_storage.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';

void main() {
  test(
    'staged tokens are effective but are not persisted before commit',
    () async {
      final store = _MemoryTokenStore();
      final manager = DefaultAuthSessionManager(store, _MemorySecureStorage());

      manager.stage(
        accessToken: 'pending-access',
        refreshToken: 'pending-refresh',
        userId: 'user-1',
      );

      expect(await manager.readEffectiveAccessToken(), 'pending-access');
      expect(await store.readAccessToken(), isNull);
      expect(await store.readRefreshToken(), isNull);
    },
  );

  test(
    'committing a pending session persists both tokens and clears memory',
    () async {
      final store = _MemoryTokenStore();
      final manager = DefaultAuthSessionManager(store, _MemorySecureStorage());
      manager.stage(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-1',
      );

      await manager.commitPendingTokens();

      expect(manager.hasPendingSession, isFalse);
      expect(await store.readAccessToken(), 'access');
      expect(await store.readRefreshToken(), 'refresh');
      expect(await manager.readProfileOnboardingCompleted(), isTrue);
    },
  );

  test(
    'committing while profile is incomplete persists token and completion flag',
    () async {
      final store = _MemoryTokenStore();
      final manager = DefaultAuthSessionManager(store, _MemorySecureStorage());
      manager.stage(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-1',
      );

      await manager.commitPendingTokens(profileOnboardingCompleted: false);

      expect(manager.hasPendingSession, isFalse);
      expect(await store.readAccessToken(), 'access');
      expect(await manager.readProfileOnboardingCompleted(), isFalse);
    },
  );

  test('clearAll removes both staged and persistent credentials', () async {
    final store = _MemoryTokenStore(
      accessToken: 'saved',
      refreshToken: 'saved-refresh',
    );
    final secureStorage = _MemorySecureStorage();
    final manager = DefaultAuthSessionManager(store, secureStorage);
    manager.stage(accessToken: 'pending', refreshToken: null, userId: 'user-1');
    await manager.saveProfileOnboardingCompleted(false);

    await manager.clearAll();

    expect(manager.hasPendingSession, isFalse);
    expect(await store.readAccessToken(), isNull);
    expect(await store.readRefreshToken(), isNull);
    expect(await manager.readProfileOnboardingCompleted(), isNull);
  });
}

final class _MemorySecureStorage implements SecureStorage {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async => _values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }
}

final class _MemoryTokenStore implements TokenStore {
  _MemoryTokenStore({this.accessToken, this.refreshToken});

  String? accessToken;
  String? refreshToken;

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
