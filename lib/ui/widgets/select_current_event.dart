import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/data/repositories/tacg_event_repository.dart';
import 'package:tacgportal/ui/widgets/event_card.dart';

class SelectCurrentEventPage extends StatefulWidget {
  final Future<List<TacgEvent>> eventsFuture;

  const SelectCurrentEventPage({super.key, required this.eventsFuture});

  @override
  State<SelectCurrentEventPage> createState() => _SelectCurrentEventPageState();
}

class _SelectCurrentEventPageState extends State<SelectCurrentEventPage> {
  String? selectedEventId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnWidth = screenWidth < 600 ? 250.0 : 300.0;
    TacgEventRepository eventRepository = TacgEventRepository();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Current Event'),
        backgroundColor: const Color(0xFFB71C1C),
      ),
      body: FutureBuilder<List<TacgEvent>>(
        future: widget.eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found'));
          }

          final events = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.125),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: columnWidth,
                    mainAxisExtent: 350.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final event = events[index];
                      final eventId = eventRepository.getTacgEventId(event);
                      final isSelected = selectedEventId == eventId;
                      return Column(
                        children: [
                          EventCard(event: event),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedEventId = eventId;
                                });

                                eventRepository.setCurrentEvent(eventId,
                                    FirebaseAuth.instance.currentUser!.uid);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Current event set to: ${event.title}'),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (states) {
                                    return isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer;
                                  },
                                ),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (states) {
                                    return isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer
                                        : Theme.of(context).colorScheme.primary;
                                  },
                                ),
                              ),
                              child: Text("Make Current Event")),
                        ],
                      );
                    },
                    childCount: events.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
