import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/attendance_record.dart';
import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/data/repositories/attendance_record_repository.dart';
import 'package:tacgportal/data/repositories/tacg_event_repository.dart';
import 'package:tacgportal/data/repositories/tacg_user_repository.dart';
import 'package:tacgportal/ui/widgets/Statistics/aggregate_attendance.dart';
import 'package:tacgportal/ui/widgets/Statistics/individual_attendance.dart';
import 'package:tacgportal/ui/widgets/basic_layout/mydrawer.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../widgets/basic_layout/DrawerItem.dart';
import '../widgets/basic_layout/Header.dart';

enum StatisticsViews {
  individual("Individual Attendance", Icons.person),
  aggregate("Aggregate Attendance", Icons.group);

  const StatisticsViews(this.label, this.icon);
  final String label;
  final IconData icon;

  static final List<DropdownMenuEntry<StatisticsViews>> entries =
      StatisticsViews.values
          .map((view) => DropdownMenuEntry<StatisticsViews>(
                value: view,
                label: view.label,
                leadingIcon: Icon(view.icon),
              ))
          .toList();
}

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  StatisticsViews selectedView = StatisticsViews.aggregate;
  final TextEditingController viewController = TextEditingController();

  Widget _buildSelectedView() {
    switch (selectedView) {
      case StatisticsViews.individual:
        return const IndividualAttendance();
      case StatisticsViews.aggregate:
        return const AggregateAttendance();
    }
  }

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
                        //view selector
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "View",
                                      style: TextStyle(
                                        fontSize: 32,
                                      ),
                                    ),
                                  ),
                                  // const Divider(
                                  //   color: Colors.black,
                                  //   thickness: 2,
                                  //   height: 20,
                                  // ),
                                  DropdownMenu<StatisticsViews>(
                                    label: const Text("Select View"),
                                    controller: viewController,
                                    initialSelection: selectedView,
                                    dropdownMenuEntries: StatisticsViews.entries,
                                    onSelected: (StatisticsViews? value) {
                                      setState(() {
                                        if (value != null) {
                                          selectedView = value;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        
                        _buildSelectedView(),
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
