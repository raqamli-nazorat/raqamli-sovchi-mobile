import 'package:equatable/equatable.dart';

final class TelegramAuthSession extends Equatable {
  const TelegramAuthSession({
    required this.sessionId,
    required this.status,
    required this.botUrl,
    this.expiresAt,
    this.createdAt,
  });

  final String sessionId;
  final String status;
  final String botUrl;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [sessionId, status, botUrl, expiresAt, createdAt];
}
