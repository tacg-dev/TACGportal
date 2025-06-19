import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/attendance_record.dart';
import 'package:tacgportal/data/repositories/attendance_record_repository.dart';

import 'package:tacgportal/router.dart';
import 'package:tacgportal/ui/widgets/attendance_table_screen.dart';
import 'package:tacgportal/ui/widgets/create_attendance_record_page.dart';
import 'package:tacgportal/ui/widgets/basic_layout/mydrawer.dart';
import '../widgets/basic_layout/Header.dart';

class Adminattendance extends StatelessWidget {
  const Adminattendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Persistent Drawer
          const Expanded(flex: 1, child: Mydrawer()),
          // Header + Main Content
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Header Section
                const Expanded(
                  flex: 1,
                  child: HeaderWidget(),
                ),
                // Body Section
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Add Attendance Record",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                decoration: const BoxDecoration(
                                  color: Color(
                                      0xFFB71C1C), // Set background color to maroon
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateAttendanceRecordPage(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  color: Colors
                                      .white, // Optional: Set icon color to white for contrast
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Create Mass Attendance Record for Current Event",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              decoration: const BoxDecoration(
                                color: Color(
                                    0xFFB71C1C), // Set background color to maroon
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  AttendanceRecordRepository
                                      attendanceRecordRepository =
                                      AttendanceRecordRepository();
                                  final semesterStartTime =
                                      attendanceRecordRepository
                                          .getCurrentSemesterStartTimestamp();
                                  attendanceRecordRepository
                                      .createMassAttendanceRecord(
                                          semesterStartTime);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Mass Attendance Record created successfully")));
                                },
                                icon: const Icon(Icons.groups),
                                color: Colors
                                    .white, // Optional: Set icon color to white for contrast
                              ),
                            ),
                          ],
                        ),
                        AttendanceTableScreen(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
