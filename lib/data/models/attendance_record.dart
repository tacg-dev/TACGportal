
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance_record.g.dart';


@JsonSerializable()
class AttendanceRecordResponse {
  final List<AttendanceRecord> records;

  const AttendanceRecordResponse({required this.records});

  factory AttendanceRecordResponse.fromJson(Map<String, dynamic> json) => _$AttendanceRecordResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceRecordResponseToJson(this);
}

@JsonSerializable()
class AttendanceRecord {
  final String? userId;
  final String eventId;
  final bool? status;
  final String? id; 
  

  const AttendanceRecord({
    this.userId,
    required this.eventId,
    this.status,
    this.id,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) => _$AttendanceRecordFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceRecordToJson(this);

  factory AttendanceRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return AttendanceRecord(
      id: doc.id, // Include the document ID
      userId: data['userId'],
      eventId: data['eventId'],
      status: data['status'] is bool ? data['status'] : null,
    );
  }
}
  
    


