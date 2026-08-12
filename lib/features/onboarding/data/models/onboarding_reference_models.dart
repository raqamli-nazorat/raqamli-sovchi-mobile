import '../../domain/entities/onboarding_reference.dart';

final class EducationLevelModel {
  const EducationLevelModel({required this.id, required this.name});

  factory EducationLevelModel.fromJson(Map<String, dynamic> json) {
    return EducationLevelModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  final String id;
  final String name;

  EducationLevel toEntity() => EducationLevel(id: id, name: name);
}

final class RegionModel {
  const RegionModel({required this.id, required this.name});

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  final String id;
  final String name;

  Region toEntity() => Region(id: id, name: name);
}

final class DistrictModel {
  const DistrictModel({required this.id, required this.name, this.regionId});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    final region = json['region'];
    return DistrictModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      regionId: region is Map
          ? (region['id'] ?? '').toString()
          : region?.toString(),
    );
  }

  final String id;
  final String name;
  final String? regionId;

  District toEntity() => District(id: id, name: name, regionId: regionId);
}

final class ReferencePageModel<T> {
  const ReferencePageModel({
    required this.items,
    required this.page,
    required this.hasNextPage,
  });

  final List<T> items;
  final int page;
  final bool hasNextPage;
}
