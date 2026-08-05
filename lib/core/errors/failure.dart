import 'package:equatable/equatable.dart';

enum FailureType {
  networkTimeout,
  noInternet,
  unauthorized,
  cancelled,
  forbidden,
  notFound,
  validation,
  configuration,
  unsupported,
  server,
  unknown,
}

final class Failure extends Equatable {
  const Failure({required this.type, this.statusCode, this.technicalReason});

  const Failure.networkTimeout() : this(type: FailureType.networkTimeout);

  const Failure.noInternet() : this(type: FailureType.noInternet);

  const Failure.unauthorized() : this(type: FailureType.unauthorized);

  const Failure.cancelled() : this(type: FailureType.cancelled);

  const Failure.forbidden() : this(type: FailureType.forbidden);

  const Failure.notFound() : this(type: FailureType.notFound);

  const Failure.validation() : this(type: FailureType.validation);

  const Failure.configuration() : this(type: FailureType.configuration);

  const Failure.unsupported() : this(type: FailureType.unsupported);

  const Failure.server({int? statusCode})
    : this(type: FailureType.server, statusCode: statusCode);

  const Failure.unknown({String? technicalReason})
    : this(type: FailureType.unknown, technicalReason: technicalReason);

  final FailureType type;
  final int? statusCode;
  final String? technicalReason;

  @override
  List<Object?> get props => [type, statusCode, technicalReason];
}
