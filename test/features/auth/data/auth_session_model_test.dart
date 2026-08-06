import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/auth/data/models/auth_session_model.dart';

void main() {
  test('maps wrapped phone auth response to named nested models', () {
    final model = AuthSessionModel.fromAuthResponse({
      'data': {
        'user': {
          'id': 'a9e32ca1-920b-49bf-8550-4d53c122915b',
          'display_id': 'USR-A9E32',
          'full_name': '+998123456789',
          'phone_number': '+998123456789',
          'email': null,
          'telegram_id': null,
          'candidate_type': null,
          'completion_percentage': 0,
          'status': "Anketa to'liq emas",
          'auth_provider': 'phone',
          'is_verified': false,
          'is_blocked': false,
          'role_info': {'id': 'role-1', 'name': 'Admin'},
          'profile_info': null,
          'created_at': '2026-08-03T16:02:17.156246+05:00',
          'updated_at': '2026-08-03T16:02:17.156250+05:00',
        },
        'tokens': {'refresh': 'refresh-token', 'access': 'access-token'},
        'created': false,
      },
      'error': null,
      'success': true,
    });

    expect(model.success, isTrue);
    expect(model.data?.created, isFalse);
    expect(model.data?.user?.displayId, 'USR-A9E32');
    expect(model.data?.user?.roleInfo?.name, 'Admin');
    expect(model.data?.user?.completionPercentage, 0);
    expect(model.data?.user?.createdAt, isNotNull);
    expect(model.accessToken, 'access-token');
    expect(model.refreshToken, 'refresh-token');
    expect(model.userId, 'a9e32ca1-920b-49bf-8550-4d53c122915b');
    expect(model.displayName, '+998123456789');
    expect(model.phoneNumber, '+998123456789');
    expect(model.isVerified, isFalse);

    final entity = model.toEntity();
    expect(entity.userId, model.userId);
    expect(entity.displayName, model.displayName);
    expect(entity.phoneNumber, model.phoneNumber);
    expect(entity.status, "Anketa to'liq emas");
    expect(entity.candidateType, isNull);
    expect(entity.profileInfo, isNull);
    expect(entity.needsCandidateType, isTrue);
  });

  test('keeps flat token response compatibility', () {
    final model = AuthSessionModel.fromJson({
      'access': 'access-token',
      'refresh': 'refresh-token',
    });

    expect(model.accessToken, 'access-token');
    expect(model.refreshToken, 'refresh-token');
    expect(model.userId, 'unknown');
    expect(model.displayName, 'User');
  });
}
