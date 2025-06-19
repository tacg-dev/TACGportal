import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacgportal/data/models/attendance_record.dart';
import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/data/repositories/tacg_event_repository.dart';

Future<List<(TacgEvent, int)>> aggregateAttendance(
  BuildContext context,
  DateTime startDate,
  DateTime endDate,
) async {
  print("got here0");
  List<TacgEvent> allEvents =
      await Provider.of<TacgEventRepository>(context, listen: false)
          .getTacgEvents();

  // Filter events by date range
  List<TacgEvent> tacg_events = allEvents.where((event) {
    return event.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
           event.date.isBefore(endDate.add(const Duration(days: 1)));
  }).toList();

  final Map<String, TacgEvent> eventIdToEvent = {
    for (var event in tacg_events) event.id: event,
  };

  print("got here");
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection("attendance_records")
      .where("status", isEqualTo: true)
      .get();

  final attendance_records = querySnapshot.docs.map((doc) {
    // Merge document ID with document data
    final data = {'id': doc.id, ...doc.data()};
    return AttendanceRecord.fromJson(data);
  }).toList();

  Map<TacgEvent, int> attendanceCount = {};
  print("got here2");
  for (var record in attendance_records) {
    TacgEvent? curr_event = eventIdToEvent[record.eventId];
    print("got here3");
    if (curr_event == null) {
      // Skip records for events outside our date range
      continue;
    }
    if (attendanceCount.containsKey(curr_event)) {
      attendanceCount[curr_event] = attendanceCount[curr_event]! + 1;
    } else {
      attendanceCount[curr_event] = 1;
    }
  }

  List<(TacgEvent, int)> sortedEvent_to_attendance =
      attendanceCount.entries.map((entry) => (entry.key, entry.value)).toList();
  sortedEvent_to_attendance.sort((a, b) => b.$2.compareTo(a.$2));

  return sortedEvent_to_attendance;
}