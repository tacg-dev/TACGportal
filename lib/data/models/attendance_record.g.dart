// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecordResponse _$AttendanceRecordResponseFromJson(
        Map<String, dynamic> json) =>
    AttendanceRecordResponse(
      records: (json['records'] as List<dynamic>)
          .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendanceRecordResponseToJson(
        AttendanceRecordResponse instance) =>
    <String, dynamic>{
      'records': instance.records,
    };

AttendanceRecord _$AttendanceRecordFromJson(Map<String, dynamic> json) =>
    AttendanceRecord(
      userId: json['userId'] as String?,
      eventId: json['eventId'] as String,
      status: json['status'] as bool?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$AttendanceRecordToJson(AttendanceRecord instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'eventId': instance.eventId,
      'status': instance.status,
      'id': instance.id,
    };
