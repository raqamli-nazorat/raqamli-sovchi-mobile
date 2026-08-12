import 'package:equatable/equatable.dart';

import 'candidate_type.dart';

final class ProfileBootstrapRequest extends Equatable {
  const ProfileBootstrapRequest({
    required this.firstName,
    required this.lastName,
    this.fatherName,
    required this.candidateType,
    required this.birthYear,
    required this.heightCm,
    required this.regionId,
    required this.districtId,
    required this.educationLevelId,
    required this.maritalStatusId,
    required this.hasChildren,
    required this.childrenCount,
    this.weightKg,
    this.healthStatusId,
  });

  final String firstName;
  final String lastName;
  final String? fatherName;
  final CandidateType candidateType;
  final int birthYear;
  final int heightCm;
  final int? weightKg;
  final String regionId;
  final String districtId;
  final String educationLevelId;
  final String maritalStatusId;
  final bool hasChildren;
  final int childrenCount;
  final String? healthStatusId;

  String get gender => candidateType == CandidateType.groom ? 'male' : 'female';

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    fatherName,
    candidateType,
    birthYear,
    heightCm,
    regionId,
    districtId,
    educationLevelId,
    maritalStatusId,
    hasChildren,
    childrenCount,
    weightKg,
    healthStatusId,
  ];
}

final class ProfileBootstrap extends Equatable {
  const ProfileBootstrap({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

final class ProfilePhoto extends Equatable {
  const ProfilePhoto({
    required this.id,
    required this.order,
    required this.isMain,
    this.imageUrl,
  });

  final String id;
  final String? imageUrl;
  final int order;
  final bool isMain;

  @override
  List<Object?> get props => [id, imageUrl, order, isMain];
}

final class FaceVerificationResult extends Equatable {
  const FaceVerificationResult({required this.verified, this.message});

  final bool verified;
  final String? message;

  @override
  List<Object?> get props => [verified, message];
}
