import 'package:equatable/equatable.dart';

import 'session.dart';

final class CurrentUser extends Equatable {
  const CurrentUser({
    required this.id,
    required this.displayName,
    this.phoneNumber,
    this.email,
    this.isVerified = false,
    this.completionPercentage,
  });

  final String id;
  final String displayName;
  final String? phoneNumber;
  final String? email;
  final bool isVerified;
  final String? completionPercentage;

  Session toSession() {
    return Session(
      userId: id,
      displayName: displayName,
      phoneNumber: phoneNumber,
      isVerified: isVerified,
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
