import '../../../../core/security/auth_session_manager.dart';

final class ClearPendingAuthSessionUseCase {
  const ClearPendingAuthSessionUseCase(this._sessionManager);

  final AuthSessionManager _sessionManager;

  void call() => _sessionManager.clearPendingSession();
}
