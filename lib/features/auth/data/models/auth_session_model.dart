import 'package:equatable/equatable.dart';

import '../../domain/entities/session.dart';

final class AuthSessionModel extends Equatable {
  const AuthSessionModel({
    required this.userId,
    required this.displayName,
    required this.accessToken,
    this.refreshToken,
    this.phoneNumber,
    this.isVerified = false,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      userId: (json['user_id'] ?? json['id'] ?? 'unknown').toString(),
      displayName: (json['display_name'] ?? json['full_name'] ?? 'User')
          .toString(),
      accessToken: (json['access'] ?? json['access_token'] ?? '').toString(),
      refreshToken: (json['refresh'] ?? json['refresh_token'])?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      isVerified: json['is_verified'] == true,
    );
  }

  final String userId;
  final String displayName;
  final String accessToken;
  final String? refreshToken;
  final String? phoneNumber;
  final bool isVerified;

  Session toEntity() {
    return Session(
      userId: userId,
      displayName: displayName,
      phoneNumber: phoneNumber,
      isVerified: isVerified,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    displayName,
    accessToken,
    refreshToken,
    phoneNumber,
    isVerified,
  ];
}
