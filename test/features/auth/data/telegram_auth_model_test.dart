import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/auth/data/models/telegram_auth_session_model.dart';
import 'package:raqamli_sovchi/features/auth/data/models/telegram_auth_status_model.dart';

void main() {
  test('maps Telegram create-session response', () {
    final model = TelegramAuthSessionModel.fromJson({
      'session_id': 'session-1',
      'status': 'pending',
      'bot_url': 'https://t.me/example?start=session-1',
      'expires_at': '2026-08-04T10:00:00Z',
      'created_at': '2026-08-04T09:55:00Z',
    });

    expect(model.sessionId, 'session-1');
    expect(model.status, 'pending');
    expect(model.botUrl, contains('session-1'));
    expect(model.toEntity().expiresAt, isNotNull);
  });

  test('maps authenticated Telegram response with nested tokens', () {
    final model = TelegramAuthStatusModel.fromJson({
      'status': 'authenticated',
      'user': {
        'id': 'user-1',
        'phone_number': '+998901234567',
        'full_name': 'Test User',
      },
      'tokens': {'access': 'access-token', 'refresh': 'refresh-token'},
    });

    final session = model.toEntity().session;
    expect(model.status, 'authenticated');
    expect(session?.userId, 'user-1');
    expect(session?.displayName, 'Test User');
    expect(session?.phoneNumber, '+998901234567');
  });
}
