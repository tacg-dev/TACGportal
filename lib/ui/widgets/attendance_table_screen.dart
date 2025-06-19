import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/attendance_record.dart';
import 'package:tacgportal/data/services/firestore_paginator.dart';

class AttendanceTableScreen extends StatefulWidget {
  @override
  _AttendanceTableScreenState createState() => _AttendanceTableScreenState();
}

class _AttendanceTableScreenState extends State<AttendanceTableScreen> {
  final int pageSize = 5;
  final String collectionPath = 'attendance_records';
  final String orderByField = 'eventId';

  late final FirestorePaginator<AttendanceRecord> paginator;
  final converter =
      (DocumentSnapshot doc) => AttendanceRecord.fromFirestore(doc);

  bool _isLoading = false;
  List<AttendanceRecord> _records = [];
  late StreamSubscription _loadingSubscription;
  late StreamSubscription _recordsSubscription;

  @override
  void initState() {
    super.initState();
    paginator = FirestorePaginator(
      converter: converter,
      collectionPath: collectionPath,
      orderByField: orderByField,
      pageSize: pageSize,
    );

    paginator.initialize();

    _loadingSubscription = paginator.isLoadingStream.listen((isLoading) {
      setState(() {
        _isLoading = isLoading;
      });
    });

    _recordsSubscription = paginator.dataStream.listen((records) {
      setState(() {
        _records = records.cast<AttendanceRecord>();
      });
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        _isLoading
            ? CircularProgressIndicator()
            : DataTable(
                columns: const [
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Event ID')),
                  DataColumn(label: Text('User ID')),
                ],
                rows: _records
                    .map((attRecord) => DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  Text(attRecord.status == true
                                      ? 'Present'
                                      : 'Absent'),
                                  SizedBox(width: 6),
                                  Icon(
                                    attRecord.status == true
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: attRecord.status == true
                                        ? Colors.green
                                        : Colors.red,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(attRecord.eventId ?? '')),
                            DataCell(Text(attRecord.userId ?? '')),
                          ],
                        ))
                    .toList(),
              ),

        // Pagination controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  paginator.currentPage > 1 ? paginator.previousPage : null,
              child: const Text('Previous'),
            ),
            const SizedBox(width: 16),
            Text('Page ${paginator.currentPage}'),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: paginator.hasMoreData ? paginator.nextPage : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Cancel subscriptions to prevent memory leaks
    _loadingSubscription.cancel();
    _recordsSubscription.cancel();

    // Dispose the paginator
    paginator.dispose();

    super.dispose();
  }
}
