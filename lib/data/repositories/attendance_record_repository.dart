import 'package:tacgportal/data/models/attendance_record.dart';
import 'package:tacgportal/data/repositories/interfaces/i_attendance_record_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecordRepository implements IAttendanceRecordRepository {
  List<AttendanceRecord>? cachedRecords;
  DateTime? lastFetchDate;

  AttendanceRecordRepository();

  @override
  Future<List<AttendanceRecord>> getAttendanceRecords(
      {bool forceRefresh = false}) async {
    final shouldFetch = cachedRecords == null ||
        forceRefresh ||
        lastFetchDate == null ||
        DateTime.now().difference(lastFetchDate!).inMinutes > 30;

    if (shouldFetch) {
      try {
        // Get attendance records collection from Firestore
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('attendance_records')
            .get();

        // Convert each document to an AttendanceRecord object using fromJson
        final records = querySnapshot.docs.map((doc) {
          // Merge document ID with document data
          final data = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          return AttendanceRecord.fromJson(data);
        }).toList();

        // Update cache
        cachedRecords = records;
        lastFetchDate = DateTime.now();
        return records;
      } catch (e) {
        if (cachedRecords != null) {
          return cachedRecords!;
        }
        rethrow;
      }
    } else {
      return cachedRecords!;
    }
  }

  @override
  Future<void> addAttendanceRecord(AttendanceRecord attendanceRecord) async {
    if (await isDuplicateAttendanceRecord(attendanceRecord)) {
      print("Attendance record already exists.");
      return;
    }    // Add the attendance record to Firestore
    String docId = '${attendanceRecord.eventId}_${attendanceRecord.userId}';
    
    final docRef =
        FirebaseFirestore.instance.collection('attendance_records').doc(docId);
    await docRef.set(attendanceRecord.toJson());
  }

  @override
  Future<void> updateAttendanceRecord(
      AttendanceRecord attendanceRecord, bool state) async {
    if (await isDuplicateAttendanceRecord(attendanceRecord) == false) {
      print("Attendance record does not exist.");
      return;
    }    // Update the attendance record in Firestore
    String docId = '${attendanceRecord.eventId}_${attendanceRecord.userId}';
    final docRef =
        FirebaseFirestore.instance.collection('attendance_records').doc(docId);

    await docRef.update({"status": state}).then(
      (value) => print("success"),
      onError: (e) => print("failed to update attendance record"),
    );
  }

  @override
  Future<void> deleteAttendanceRecord(String userId, String eventId) async {
    print("not for use currently");
  }
  
  Future<bool> isDuplicateAttendanceRecord(AttendanceRecord newRecord) async {
    String docId = '${newRecord.eventId}_${newRecord.userId}';
    final docRef =
        FirebaseFirestore.instance.collection('attendance_records').doc(docId);
    return docRef.get().then((doc) {
      return doc.exists;
    });
  }

  Future<void> createMassAttendanceRecord(Timestamp lastActive) async {
    final QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('lastActive', isGreaterThan: lastActive)
        .get();

    String currentEventId = await FirebaseFirestore.instance
        .collection('app_state')
        .doc("current_event")
        .get()
        .then((doc) => doc['eventId']);
    for (var userDoc in userQuerySnapshot.docs) {
      // ignore: non_constant_identifier_names
      AttendanceRecord temp_att_record = AttendanceRecord(
        userId: userDoc.id,
        eventId: currentEventId,
        status: false,
      );
      await addAttendanceRecord(temp_att_record);
    }
  }

  Timestamp getCurrentSemesterStartTimestamp() {
    final now = DateTime.now();
    final currentYear = now.year;

    // Create DateTime for January 1 and July 1 of the current year
    final januaryFirst = DateTime(currentYear, 1, 1);
    final julyFirst = DateTime(currentYear, 7, 1);

    // If current date is before July 1st, use January 1st
    // Otherwise use July 1st
    final targetDate = now.isBefore(julyFirst) ? januaryFirst : julyFirst;

    // Convert to Timestamp and return
    return Timestamp.fromDate(targetDate);
  }
}
