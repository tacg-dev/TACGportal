import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'tacg_user.g.dart';

@JsonSerializable()
class TacgUserResponse {
  final List<TacgUser> tacgUsers;

  const TacgUserResponse({required this.tacgUsers});

  factory TacgUserResponse.fromJson(Map<String, dynamic> json) =>
      _$TacgUserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TacgUserResponseToJson(this);
}

@JsonSerializable()
class TacgUser {
  final bool approved;

  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  final DateTime? createdAt;

  final String? displayName;
  final String? email;

  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  final DateTime? lastActive;

  final String? photoURL;
  final String? role;

  const TacgUser({
    required this.approved,
    this.createdAt,
    this.displayName,
    this.email,
    this.lastActive,
    this.photoURL,
    this.role,
  });

  factory TacgUser.fromJson(Map<String, dynamic> json) =>
      _$TacgUserFromJson(json);
  Map<String, dynamic> toJson() => _$TacgUserToJson(this);

  // New conversion methods that handle both String and Timestamp
  static DateTime? _timestampToDateTime(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return null;
  }

  static dynamic _dateTimeToTimestamp(DateTime? date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
  }
}
