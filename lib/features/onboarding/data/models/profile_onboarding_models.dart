import '../../domain/entities/profile_onboarding_models.dart';

final class ProfileBootstrapModel {
  const ProfileBootstrapModel({required this.id});

  factory ProfileBootstrapModel.fromJson(Map<String, dynamic> json) {
    return ProfileBootstrapModel(id: (json['id'] ?? '').toString());
  }

  final String id;

  ProfileBootstrap toEntity() => ProfileBootstrap(id: id);
}

final class ProfilePhotoModel {
  const ProfilePhotoModel({
    required this.id,
    required this.order,
    required this.isMain,
    this.imageUrl,
  });

  factory ProfilePhotoModel.fromJson(Map<String, dynamic> json) {
    return ProfilePhotoModel(
      id: (json['id'] ?? '').toString(),
      imageUrl: json['image']?.toString(),
      order: int.tryParse((json['order'] ?? 1).toString()) ?? 1,
      isMain: json['is_main'] == true,
    );
  }

  final String id;
  final String? imageUrl;
  final int order;
  final bool isMain;

  ProfilePhoto toEntity() =>
      ProfilePhoto(id: id, imageUrl: imageUrl, order: order, isMain: isMain);
}

final class FaceVerificationResultModel {
  const FaceVerificationResultModel({required this.verified, this.message});

  factory FaceVerificationResultModel.fromJson(Map<String, dynamic> json) {
    return FaceVerificationResultModel(
      verified: json['verified'] == true,
      message: json['message']?.toString(),
    );
  }

  final bool verified;
  final String? message;

  FaceVerificationResult toEntity() {
    return FaceVerificationResult(verified: verified, message: message);
  }
}

final class RepresentativeInfoModel {
  const RepresentativeInfoModel({required this.id, required this.isApproved});

  factory RepresentativeInfoModel.fromJson(Map<String, dynamic> json) {
    return RepresentativeInfoModel(
      id: (json['id'] ?? '').toString(),
      isApproved: json['is_approved'] == true,
    );
  }

  final String id;
  final bool isApproved;

  RepresentativeInfo toEntity() {
    return RepresentativeInfo(id: id, isApproved: isApproved);
  }
}
