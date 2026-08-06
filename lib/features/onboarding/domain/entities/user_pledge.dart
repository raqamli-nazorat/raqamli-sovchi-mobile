import 'package:equatable/equatable.dart';

final class UserPledge extends Equatable {
  const UserPledge({
    required this.id,
    required this.acceptedTerms,
    required this.hasSeriousBadge,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final bool acceptedTerms;
  final bool hasSeriousBadge;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    acceptedTerms,
    hasSeriousBadge,
    createdAt,
    updatedAt,
  ];
}
