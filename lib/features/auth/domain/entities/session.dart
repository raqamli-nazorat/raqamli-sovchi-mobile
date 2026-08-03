import 'package:equatable/equatable.dart';

final class Session extends Equatable {
  const Session({
    required this.userId,
    required this.displayName,
    this.phoneNumber,
    this.isVerified = false,
  });

  final String userId;
  final String displayName;
  final String? phoneNumber;
  final bool isVerified;

  @override
  List<Object?> get props => [userId, displayName, phoneNumber, isVerified];
}
