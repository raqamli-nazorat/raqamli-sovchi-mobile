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
          ? AuthSessionModel.fromAuthResponse(<String, dynamic>{
              'data': <String, dynamic>{
                'user': <String, dynamic>{
                  ...user,
                  'is_verified': user['is_verified'] ?? true,
                },
                'tokens': tokens,
              },
              'success': true,
            })
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
