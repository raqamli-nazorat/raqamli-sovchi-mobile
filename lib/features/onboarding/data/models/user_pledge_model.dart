import 'package:equatable/equatable.dart';

import '../../domain/entities/user_pledge.dart';

final class UserPledgeModel extends Equatable {
  const UserPledgeModel({
    required this.id,
    required this.acceptedTerms,
    required this.hasSeriousBadge,
    this.createdAt,
    this.updatedAt,
  });

  factory UserPledgeModel.fromJson(Map<String, dynamic> json) {
    return UserPledgeModel(
      id: json['id']?.toString() ?? '',
      acceptedTerms: json['accepted_terms'] == true,
      hasSeriousBadge: json['has_serious_badge'] == true,
      createdAt: _dateTime(json['created_at']),
      updatedAt: _dateTime(json['updated_at']),
    );
  }

  final String id;
  final bool acceptedTerms;
  final bool hasSeriousBadge;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserPledge toEntity() {
    return UserPledge(
      id: id,
      acceptedTerms: acceptedTerms,
      hasSeriousBadge: hasSeriousBadge,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    acceptedTerms,
    hasSeriousBadge,
    createdAt,
    updatedAt,
  ];
}

DateTime? _dateTime(Object? value) {
  final text = value?.toString();
  return text == null ? null : DateTime.tryParse(text);
}
