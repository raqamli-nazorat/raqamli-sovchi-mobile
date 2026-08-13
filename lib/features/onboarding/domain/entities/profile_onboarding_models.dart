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
    this.representedCandidateType,
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
  final CandidateType? representedCandidateType;

  String get gender {
    final effectiveType = candidateType == CandidateType.representative
        ? representedCandidateType
        : candidateType;
    return effectiveType == CandidateType.groom ? 'male' : 'female';
  }

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
    representedCandidateType,
  ];
}

final class RepresentativeInfoRequest extends Equatable {
  const RepresentativeInfoRequest({
    required this.profileId,
    required this.candidateType,
    required this.kinshipId,
    this.candidateContact,
  });

  final String profileId;
  final CandidateType candidateType;
  final String kinshipId;
  final String? candidateContact;

  @override
  List<Object?> get props => [
    profileId,
    candidateType,
    kinshipId,
    candidateContact,
  ];
}

final class RepresentativeInfo extends Equatable {
  const RepresentativeInfo({required this.id, required this.isApproved});

  final String id;
  final bool isApproved;

  @override
  List<Object?> get props => [id, isApproved];
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
