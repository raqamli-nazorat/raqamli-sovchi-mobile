import 'package:equatable/equatable.dart';

import '../../domain/entities/session.dart';

final class AuthSessionModel extends Equatable {
  const AuthSessionModel({this.data, this.error, this.success});

  factory AuthSessionModel.local({
    required String userId,
    required String displayName,
    required String accessToken,
    String? refreshToken,
    String? phoneNumber,
    bool isVerified = false,
  }) {
    return AuthSessionModel(
      data: AuthSessionDataModel(
        user: AuthUserModel(
          id: userId,
          fullName: displayName,
          phoneNumber: phoneNumber,
          isVerified: isVerified,
        ),
        tokens: AuthTokensModel(refresh: refreshToken, access: accessToken),
      ),
      success: true,
    );
  }

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final responseData = json['data'];
    if (responseData is Map) {
      return AuthSessionModel(
        data: AuthSessionDataModel.fromJson(_asMap(responseData)),
        error: json['error'],
        success: _asBool(json['success']),
      );
    }

    final rootUser = json['user'];
    final rootTokens = json['tokens'];
    if (rootUser is Map || rootTokens is Map) {
      return AuthSessionModel(
        data: AuthSessionDataModel(
          user: rootUser is Map
              ? AuthUserModel.fromJson(_asMap(rootUser))
              : null,
          tokens: rootTokens is Map
              ? AuthTokensModel.fromJson(_asMap(rootTokens))
              : null,
          created: _asBool(json['created']),
        ),
        error: json['error'],
        success: _asBool(json['success']),
      );
    }

    return AuthSessionModel(
      data: AuthSessionDataModel(
        user: AuthUserModel(
          id: _asString(json['user_id'] ?? json['id']),
          fullName: _asString(json['display_name'] ?? json['full_name']),
          phoneNumber: _asString(json['phone_number']),
          isVerified: _asBool(json['is_verified']),
        ),
        tokens: AuthTokensModel(
          refresh: _asString(json['refresh'] ?? json['refresh_token']),
          access: _asString(json['access'] ?? json['access_token']),
        ),
      ),
      error: json['error'],
      success: _asBool(json['success']),
    );
  }

  factory AuthSessionModel.fromAuthResponse(Map<String, dynamic> json) {
    return AuthSessionModel.fromJson(json);
  }

  factory AuthSessionModel.fromGoogleResponse(Map<String, dynamic> json) {
    return AuthSessionModel.fromAuthResponse(json);
  }

  final AuthSessionDataModel? data;
  final Object? error;
  final bool? success;

  String get userId => data?.user?.id ?? 'unknown';

  String get displayName {
    final fullName = data?.user?.fullName;
    if (fullName != null && fullName.isNotEmpty) return fullName;
    final email = data?.user?.email?.toString();
    if (email != null && email.isNotEmpty) return email;
    final phoneNumber = data?.user?.phoneNumber;
    if (phoneNumber != null && phoneNumber.isNotEmpty) return phoneNumber;
    return 'User';
  }

  String get accessToken => data?.tokens?.access ?? '';

  String? get refreshToken => data?.tokens?.refresh;

  String? get phoneNumber => data?.user?.phoneNumber;

  bool get isVerified => data?.user?.isVerified == true;

  AuthSessionModel withPhoneNumberFallback(String phoneNumber) {
    final existingPhoneNumber = this.phoneNumber;
    if (existingPhoneNumber != null && existingPhoneNumber.isNotEmpty) {
      return this;
    }

    final currentData = data ?? const AuthSessionDataModel();
    final currentUser = currentData.user ?? const AuthUserModel();
    return copyWith(
      data: currentData.copyWith(
        user: currentUser.copyWith(phoneNumber: phoneNumber),
      ),
    );
  }

  AuthSessionModel copyWith({
    AuthSessionDataModel? data,
    Object? error,
    bool? success,
  }) {
    return AuthSessionModel(
      data: data ?? this.data,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  Session toEntity() {
    return Session(
      userId: userId,
      displayName: displayName,
      phoneNumber: phoneNumber,
      isVerified: isVerified,
      status: data?.user?.status,
      candidateType: data?.user?.candidateType,
      profileInfo: data?.user?.profileInfo,
    );
  }

  @override
  List<Object?> get props => [data, error, success];
}

final class AuthSessionDataModel extends Equatable {
  const AuthSessionDataModel({this.user, this.tokens, this.created});

  factory AuthSessionDataModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionDataModel(
      user: json['user'] is Map
          ? AuthUserModel.fromJson(_asMap(json['user']))
          : AuthUserModel.fromJson(json),
      tokens: json['tokens'] is Map
          ? AuthTokensModel.fromJson(_asMap(json['tokens']))
          : AuthTokensModel.fromJson(json),
      created: _asBool(json['created']),
    );
  }

  final AuthUserModel? user;
  final AuthTokensModel? tokens;
  final bool? created;

  AuthSessionDataModel copyWith({
    AuthUserModel? user,
    AuthTokensModel? tokens,
    bool? created,
  }) {
    return AuthSessionDataModel(
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      created: created ?? this.created,
    );
  }

  @override
  List<Object?> get props => [user, tokens, created];
}

final class AuthTokensModel extends Equatable {
  const AuthTokensModel({this.refresh, this.access});

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      refresh: _asString(json['refresh'] ?? json['refresh_token']),
      access: _asString(json['access'] ?? json['access_token']),
    );
  }

  final String? refresh;
  final String? access;

  AuthTokensModel copyWith({String? refresh, String? access}) {
    return AuthTokensModel(
      refresh: refresh ?? this.refresh,
      access: access ?? this.access,
    );
  }

  @override
  List<Object?> get props => [refresh, access];
}

final class AuthUserModel extends Equatable {
  const AuthUserModel({
    this.id,
    this.displayId,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.telegramId,
    this.candidateType,
    this.completionPercentage,
    this.status,
    this.authProvider,
    this.isVerified,
    this.isBlocked,
    this.roleInfo,
    this.profileInfo,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: _asString(json['id'] ?? json['user_id']),
      displayId: _asString(json['display_id']),
      fullName: _asString(json['full_name'] ?? json['display_name']),
      phoneNumber: _asString(json['phone_number']),
      email: json['email'],
      telegramId: json['telegram_id'],
      candidateType: _asString(json['candidate_type']),
      completionPercentage: _asInt(json['completion_percentage']),
      status: _asString(json['status']),
      authProvider: _asString(json['auth_provider']),
      isVerified: _asBool(json['is_verified']),
      isBlocked: _asBool(json['is_blocked']),
      roleInfo: json['role_info'] is Map
          ? AuthRoleInfoModel.fromJson(_asMap(json['role_info']))
          : null,
      profileInfo: json['profile_info'],
      createdAt: _asDateTime(json['created_at']),
      updatedAt: _asDateTime(json['updated_at']),
    );
  }

  final String? id;
  final String? displayId;
  final String? fullName;
  final String? phoneNumber;
  final Object? email;
  final Object? telegramId;
  final String? candidateType;
  final int? completionPercentage;
  final String? status;
  final String? authProvider;
  final bool? isVerified;
  final bool? isBlocked;
  final AuthRoleInfoModel? roleInfo;
  final Object? profileInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AuthUserModel copyWith({
    String? id,
    String? displayId,
    String? fullName,
    String? phoneNumber,
    Object? email,
    Object? telegramId,
    String? candidateType,
    int? completionPercentage,
    String? status,
    String? authProvider,
    bool? isVerified,
    bool? isBlocked,
    AuthRoleInfoModel? roleInfo,
    Object? profileInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      displayId: displayId ?? this.displayId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      telegramId: telegramId ?? this.telegramId,
      candidateType: candidateType ?? this.candidateType,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      status: status ?? this.status,
      authProvider: authProvider ?? this.authProvider,
      isVerified: isVerified ?? this.isVerified,
      isBlocked: isBlocked ?? this.isBlocked,
      roleInfo: roleInfo ?? this.roleInfo,
      profileInfo: profileInfo ?? this.profileInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayId,
    fullName,
    phoneNumber,
    email,
    telegramId,
    candidateType,
    completionPercentage,
    status,
    authProvider,
    isVerified,
    isBlocked,
    roleInfo,
    profileInfo,
    createdAt,
    updatedAt,
  ];
}

final class AuthRoleInfoModel extends Equatable {
  const AuthRoleInfoModel({this.id, this.name});

  factory AuthRoleInfoModel.fromJson(Map<String, dynamic> json) {
    return AuthRoleInfoModel(
      id: _asString(json['id']),
      name: _asString(json['name']),
    );
  }

  final String? id;
  final String? name;

  AuthRoleInfoModel copyWith({String? id, String? name}) {
    return AuthRoleInfoModel(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  return value.map((key, value) => MapEntry(key.toString(), value));
}

String? _asString(Object? value) {
  if (value == null) return null;
  return value.toString();
}

bool? _asBool(Object? value) {
  if (value is bool) return value;
  if (value is String) return bool.tryParse(value);
  return null;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _asDateTime(Object? value) {
  final stringValue = _asString(value);
  if (stringValue == null || stringValue.isEmpty) return null;
  return DateTime.tryParse(stringValue);
}
