// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tacg_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TacgUserResponse _$TacgUserResponseFromJson(Map<String, dynamic> json) =>
    TacgUserResponse(
      tacgUsers: (json['tacgUsers'] as List<dynamic>)
          .map((e) => TacgUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TacgUserResponseToJson(TacgUserResponse instance) =>
    <String, dynamic>{
      'tacgUsers': instance.tacgUsers,
    };

TacgUser _$TacgUserFromJson(Map<String, dynamic> json) => TacgUser(
      approved: json['approved'] as bool,
      createdAt: TacgUser._timestampToDateTime(json['createdAt']),
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      lastActive: TacgUser._timestampToDateTime(json['lastActive']),
      photoURL: json['photoURL'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$TacgUserToJson(TacgUser instance) => <String, dynamic>{
      'approved': instance.approved,
      'createdAt': TacgUser._dateTimeToTimestamp(instance.createdAt),
      'displayName': instance.displayName,
      'email': instance.email,
      'lastActive': TacgUser._dateTimeToTimestamp(instance.lastActive),
      'photoURL': instance.photoURL,
      'role': instance.role,
    };
