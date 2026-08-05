import 'package:equatable/equatable.dart';

final class GoogleAuthorizationResult extends Equatable {
  const GoogleAuthorizationResult({required this.authorizationCode});

  final String authorizationCode;

  @override
  List<Object?> get props => [authorizationCode];
}
