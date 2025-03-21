import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tacgportal/widgets/calendar_event.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("lib/assets/tacg-nbg.png"),
                    radius: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Arun Natarajan",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Consultant 2026',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) {
                  return TableCalendar(
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    focusedDay: today,
                    firstDay: DateTime.utc(2022, 1, 1),
                    lastDay: DateTime.utc(2027, 1, 1),
                    onDaySelected: _onDaySelected,
                  );
                } else if (index % 2 == 0) {
                  return const Divider(); // Horizontal line
                } else if (index % 2 == 1) {
                  return Column(
                    children: [
                      calendar_event(
                        date: DateTime.now(),
                        description: 'Meeting with team',
                        time: '10:00 AM',
                        location: 'Conference Room',
                      ),
                    ],
                  );
                } else {
                  return const Divider(); // Horizontal line
                }
              },
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
