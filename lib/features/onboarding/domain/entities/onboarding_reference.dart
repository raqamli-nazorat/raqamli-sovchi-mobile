import 'package:equatable/equatable.dart';

final class EducationLevel extends Equatable {
  const EducationLevel({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

final class Region extends Equatable {
  const Region({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

final class District extends Equatable {
  const District({required this.id, required this.name, this.regionId});

  final String id;
  final String name;
  final String? regionId;

  @override
  List<Object?> get props => [id, name, regionId];
}

final class ReferencePage<T> extends Equatable {
  const ReferencePage({
    required this.items,
    required this.page,
    required this.hasNextPage,
  });

  final List<T> items;
  final int page;
  final bool hasNextPage;

  @override
  List<Object?> get props => [items, page, hasNextPage];
}
