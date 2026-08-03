import 'package:equatable/equatable.dart';

import '../../domain/entities/current_user.dart';

final class CurrentUserModel extends Equatable {
  const CurrentUserModel({
    required this.id,
    required this.displayName,
    this.phoneNumber,
    this.email,
    this.isVerified = false,
    this.completionPercentage,
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      id: json['id'].toString(),
      displayName: (json['full_name'] ?? '').toString(),
      phoneNumber: json['phone_number']?.toString(),
      email: json['email']?.toString(),
      isVerified: json['is_verified'] == true,
      completionPercentage: json['completion_percentage']?.toString(),
    );
  }

  final String id;
  final String displayName;
  final String? phoneNumber;
  final String? email;
  final bool isVerified;
  final String? completionPercentage;

  CurrentUser toEntity() {
    return CurrentUser(
      id: id,
      displayName: displayName,
      phoneNumber: phoneNumber,
      email: email,
      isVerified: isVerified,
      completionPercentage: completionPercentage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    phoneNumber,
    email,
    isVerified,
    completionPercentage,
  ];
}
