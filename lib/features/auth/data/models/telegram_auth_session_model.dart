import 'package:equatable/equatable.dart';

import '../../domain/entities/telegram_auth_session.dart';

final class TelegramAuthSessionModel extends Equatable {
  const TelegramAuthSessionModel({
    required this.sessionId,
    required this.status,
    required this.botUrl,
    this.expiresAt,
    this.createdAt,
  });

  factory TelegramAuthSessionModel.fromJson(Map<String, dynamic> json) {
    return TelegramAuthSessionModel(
      sessionId: (json['session_id'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      botUrl: (json['bot_url'] ?? '').toString(),
      expiresAt: DateTime.tryParse(json['expires_at']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  final String sessionId;
  final String status;
  final String botUrl;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  TelegramAuthSession toEntity() {
    return TelegramAuthSession(
      sessionId: sessionId,
      status: status,
      botUrl: botUrl,
      expiresAt: expiresAt,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [sessionId, status, botUrl, expiresAt, createdAt];
}
