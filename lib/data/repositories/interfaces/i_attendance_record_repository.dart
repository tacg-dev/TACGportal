import 'package:tacgportal/data/models/attendance_record.dart';

abstract class IAttendanceRecordRepository {
  Future<List<AttendanceRecord>> getAttendanceRecords({bool forceRefresh = false});
  Future<void> addAttendanceRecord(AttendanceRecord attendanceRecord);
  Future<void> updateAttendanceRecord(AttendanceRecord attendanceRecord, bool state);
  Future<void> deleteAttendanceRecord(String userId, String eventId);
}
