import 'package:equatable/equatable.dart';

import 'session.dart';

final class TelegramAuthStatus extends Equatable {
  const TelegramAuthStatus({required this.status, this.session});

  final String status;
  final Session? session;

  bool get isPending => status == 'pending';
  bool get isAuthenticated => status == 'authenticated';
  bool get isExpired => status == 'expired';

  @override
  List<Object?> get props => [status, session];
}
