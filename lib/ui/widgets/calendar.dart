import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tacgportal/data/models/event.dart';
import 'package:tacgportal/data/providers/calendar_provider.dart';
import 'package:tacgportal/data/repositories/calendar_repository.dart';
import 'package:tacgportal/data/services/api/calendar_api_service.dart';
import 'package:tacgportal/ui/widgets/calendar_event.dart';

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
  void initState() {
    super.initState();
    // Load events when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CalendarProvider>(context, listen: false).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    
    return Consumer<CalendarProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        print(provider.events);

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: CustomScrollView(
            slivers: [
              // User profile section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                        radius: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.displayName ?? '',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Consultant',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
              // SliverList for the calendar and events or "No upcoming events" card
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    // First item is always the calendar
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
                    }

                    // If there are no events, show a "No upcoming events" card
                    if (provider.events.isEmpty && index == 1) {
                      return Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'No upcoming events',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      );
                    }

                    // If there are events, show each event followed by a divider
                    if (provider.events.isNotEmpty) {
                      int eventIndex =
                          index - 1; // Subtract 1 to account for the calendar
                      if (eventIndex < provider.events.length) {
                        return Column(
                          children: [
                            calendar_event(
                              date: provider.events[eventIndex].start!,
                              description:
                                  provider.events[eventIndex].description!,
                              time: provider.events[eventIndex].time!,
                              location: provider.events[eventIndex].location!,
                              title: provider.events[eventIndex].title!,
                            ),
                            const Divider(),
                          ],
                        );
                      }
                    }

                    return null; // This should not be reached
                  },
                  childCount:
                      provider.events.isEmpty ? 2 : provider.events.length + 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
