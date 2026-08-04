import 'package:equatable/equatable.dart';

import '../../domain/entities/telegram_auth_status.dart';
import 'auth_session_model.dart';

final class TelegramAuthStatusModel extends Equatable {
  const TelegramAuthStatusModel({required this.status, this.session});

  factory TelegramAuthStatusModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final tokens = json['tokens'];
    final hasSession =
        user is Map<String, dynamic> && tokens is Map<String, dynamic>;

    return TelegramAuthStatusModel(
      status: (json['status'] ?? '').toString(),
      session: hasSession
          ? AuthSessionModel(
              userId: (user['id'] ?? '').toString(),
              displayName: (user['full_name'] ?? 'Raqamli Sovchi').toString(),
              accessToken: (tokens['access'] ?? '').toString(),
              refreshToken: tokens['refresh']?.toString(),
              phoneNumber: user['phone_number']?.toString(),
              isVerified: true,
            )
          : null,
    );
  }

  final String status;
  final AuthSessionModel? session;

  TelegramAuthStatus toEntity() {
    return TelegramAuthStatus(status: status, session: session?.toEntity());
  }

  @override
  List<Object?> get props => [status, session];
}
