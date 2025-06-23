import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/active_member_db_info.dart';
import 'package:tacgportal/data/models/attendance_record.dart';
import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/data/repositories/attendance_record_repository.dart';
import 'package:tacgportal/data/repositories/tacg_event_repository.dart';
import 'package:tacgportal/data/repositories/tacg_user_repository.dart';
import 'package:tacgportal/data/services/api/active_member_db_service.dart';
import '../widgets/basic_layout/DrawerItem.dart';
import '../widgets/basic_layout/Header.dart';

class Testdata extends StatelessWidget {
  const Testdata({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Persistent Drawer
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 3)),
                    child: Drawer(
                      // Do not explicitly set backgroundColor; observe automatic behavior
                      child: ListView(
                        children: [
                          DrawerHeader(
                            child: Center(
                              child: Image.asset(
                                "lib/assets/tacg-nbg.png",
                                width: 300,
                              ),
                            ),
                          ),
                          const DrawerItem(
                            title: 'Home',
                            icon: Icons.home,
                            route: '/home',
                          ),
                          const DrawerItem(
                            title: 'Dashboard',
                            icon: Icons.dashboard,
                            route: '/dashboard',
                          ),
                          // const DrawerItem(
                          //   title: 'Orders',
                          //   icon: Icons.shopping_cart,
                          //   route: '/',
                          // ),
                          // const DrawerItem(
                          //   title: 'Products',
                          //   icon: Icons.shopping_bag,
                          //   route: '/',
                          // ),
                          // const DrawerItem(
                          //   title: 'Customers',
                          //   icon: Icons.people,
                          //   route: '/customers',
                          // ),
                          // const DrawerItem(
                          //   title: 'Reports',
                          //   icon: Icons.bar_chart,
                          //   route: '/reports',
                          // ),
                          // const DrawerItem(
                          //   title: 'Promotions',
                          //   icon: Icons.local_offer,
                          //   route: '/promotions',
                          // ),
                          // const DrawerItem(
                          //   title: 'Settings',
                          //   icon: Icons.settings,
                          //   route: '/settings',
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          TacgUserRepository tacgUserRepository =
                              TacgUserRepository();
                          final users = await tacgUserRepository.getUsers();
                          print(users);
                        },
                        child: const Text("Get Users"),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      TextButton(
                        onPressed: () async {
                          TacgEventRepository tacgEventRepository =
                              TacgEventRepository();
                          final events =
                              await tacgEventRepository.getTacgEvents();
                          print(events);
                        },
                        child: Text("Get Events"),
                      ),
                      TextButton(
                        onPressed: () async {
                          TacgEventRepository tacgEventRepository =
                              TacgEventRepository();
                          final event = TacgEvent(
                            title: "Test Event",
                            description: "This is a test event",
                            date: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                            time: "12:00 PM",
                            isMandatory: false,
                            id: '',
                          );

                          await tacgEventRepository.addTacgEvent(event);
                          print("no issues");
                        },
                        child: Text("Add Event"),
                      ),
                      TextButton(
                        onPressed: () async {
                          TacgEventRepository tacgEventRepository =
                              TacgEventRepository();

                          await tacgEventRepository.setCurrentEvent(
                              "Test Event_2025-05-12 00:00:00.000_12:00 PM",
                              "ZSpuXO9x2ZZxZIPyJxv5QzjaUvn2");
                          print("no issues");
                        },
                        child: const Text("Set Current Event"),
                      ),
                      TextButton(
                        onPressed: () async {
                          TacgEventRepository tacgEventRepository =
                              TacgEventRepository();

                          await tacgEventRepository.setAttendanceCode("coby");
                          print("no issues");
                        },
                        child: const Text("Set attendance code"),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      TextButton(
                        onPressed: () async {
                          AttendanceRecordRepository
                              attendanceRecordRepository =
                              AttendanceRecordRepository();

                          final records = await attendanceRecordRepository
                              .getAttendanceRecords();
                          print(records);
                        },
                        child: const Text("Get attendance records"),
                      ),
                      TextButton(
                        onPressed: () async {
                          AttendanceRecordRepository
                              attendanceRecordRepository =
                              AttendanceRecordRepository();
                          const attendanceRecord = AttendanceRecord(
                            userId: "ZSpuXO9x2ZZxZIPyJxv5QzjaUvn2",
                            eventId:
                                "Test Event_2025-05-12 00:00:00.000_12:00 PM",
                            status: false,
                          );
                          await attendanceRecordRepository
                              .addAttendanceRecord(attendanceRecord);
                          print("no issues");
                        },
                        child: const Text("add attendance record"),
                      ),
                      TextButton(
                        onPressed: () async {
                          AttendanceRecordRepository
                              attendanceRecordRepository =
                              AttendanceRecordRepository();
                          const attendanceRecord = AttendanceRecord(
                            userId: "ZSpuXO9x2ZZxZIPyJxv5QzjaUvn2",
                            eventId:
                                "Test Event_2025-05-12 00:00:00.000_12:00 PM",
                            status: false,
                          );
                          await attendanceRecordRepository
                              .updateAttendanceRecord(attendanceRecord, true);
                          print("no issues");
                        },
                        child: const Text("update attendance record"),
                      ),
                      TextButton(
                        onPressed: () async {
                          AttendanceRecordRepository
                              attendanceRecordRepository =
                              AttendanceRecordRepository();

                          await attendanceRecordRepository
                              .createMassAttendanceRecord(
                                  Timestamp.fromDate(DateTime(2025, 1, 1)));
                          print("no issues");
                        },
                        child: const Text("create mass attendance record"),
                      ),
                      TextButton(
                        onPressed: () async {
                          List<ActiveMemberDbInfo> activeMembers =
                              await fetchActiveMemberDatabase(true);
                          for (var member in activeMembers) {
                            print(
                                "Member: ${member.firstName} ${member.lastName}, Email: ${member.emailAddress}");
                          }
                        },
                        child: const Text("test active member database"),
                      ),
                    ],
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
