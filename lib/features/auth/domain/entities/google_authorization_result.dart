import 'package:equatable/equatable.dart';

final class GoogleAuthorizationResult extends Equatable {
  const GoogleAuthorizationResult({required this.idToken});

  final String idToken;

  @override
  List<Object?> get props => [idToken];
}
