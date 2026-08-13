import 'package:equatable/equatable.dart';

final class Session extends Equatable {
  const Session({
    required this.userId,
    required this.displayName,
    this.phoneNumber,
    this.isVerified = false,
    this.status,
    this.candidateType,
    this.profileInfo,
  });

  final String userId;
  final String displayName;
  final String? phoneNumber;
  final bool isVerified;
  final String? status;
  final String? candidateType;
  final Object? profileInfo;

  bool get needsCandidateType =>
      _normalizedStatus == _incompleteProfileStatus &&
      profileInfo == null &&
      (candidateType == null || candidateType!.isEmpty);

  bool get needsProfileOnboarding =>
      _normalizedStatus == _incompleteProfileStatus || profileInfo == null;

  String get _normalizedStatus {
    return (status ?? '')
        .trim()
        .toLowerCase()
        .replaceAll('\u2018', "'")
        .replaceAll('\u2019', "'")
        .replaceAll('\u02bb', "'");
  }

  Session copyWith({
    String? userId,
    String? displayName,
    String? phoneNumber,
    bool? isVerified,
    String? status,
    String? candidateType,
    Object? profileInfo,
  }) {
    return Session(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      candidateType: candidateType ?? this.candidateType,
      profileInfo: profileInfo ?? this.profileInfo,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    displayName,
    phoneNumber,
    isVerified,
    status,
    candidateType,
    profileInfo,
  ];
}

const _incompleteProfileStatus = "anketa to'liq emas";
