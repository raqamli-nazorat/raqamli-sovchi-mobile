import 'package:equatable/equatable.dart';

import 'token_store.dart';

/// Auth tokens received during onboarding but not yet committed to disk.
///
/// This keeps an unfinished profile from becoming a durable authenticated
/// session after an app restart.
final class PendingAuthSession extends Equatable {
  const PendingAuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.createdAt,
  });

  final String accessToken;
  final String? refreshToken;
  final String userId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [accessToken, refreshToken, userId, createdAt];
}

abstract interface class AuthSessionManager {
  PendingAuthSession? get pendingSession;

  bool get hasPendingSession;

  Future<String?> readEffectiveAccessToken();

  void stage({
    required String accessToken,
    required String? refreshToken,
    required String userId,
  });

  Future<void> commitPendingTokens();

  void clearPendingSession();

  Future<void> clearAll();
}

final class DefaultAuthSessionManager implements AuthSessionManager {
  DefaultAuthSessionManager(this._tokenStore);

  final TokenStore _tokenStore;
  PendingAuthSession? _pendingSession;

  @override
  PendingAuthSession? get pendingSession => _pendingSession;

  @override
  bool get hasPendingSession => _pendingSession != null;

  @override
  Future<String?> readEffectiveAccessToken() async {
    return _pendingSession?.accessToken ?? _tokenStore.readAccessToken();
  }

  @override
  void stage({
    required String accessToken,
    required String? refreshToken,
    required String userId,
  }) {
    _pendingSession = PendingAuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<void> commitPendingTokens() async {
    final pending = _pendingSession;
    if (pending == null) {
      throw StateError('No pending authentication session to commit.');
    }

    try {
      await _tokenStore.saveTokens(
        accessToken: pending.accessToken,
        refreshToken: pending.refreshToken,
      );
    } catch (_) {
      await _tokenStore.clear();
      rethrow;
    }

    _pendingSession = null;
  }

  @override
  void clearPendingSession() {
    _pendingSession = null;
  }

  @override
  Future<void> clearAll() async {
    _pendingSession = null;
    await _tokenStore.clear();
  }
}
