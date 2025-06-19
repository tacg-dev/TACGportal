import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/data/repositories/tacg_event_repository.dart';
import 'package:tacgportal/ui/widgets/create_event_page.dart';
import 'package:tacgportal/ui/widgets/event_card.dart';
import 'package:tacgportal/ui/widgets/select_current_event.dart';
import 'package:tacgportal/ui/widgets/basic_layout/mydrawer.dart';
import '../widgets/basic_layout/Header.dart';

class AdminEvents extends StatefulWidget {
  const AdminEvents({super.key});

  @override
  State<AdminEvents> createState() => _AdminEventsState();
}

class _AdminEventsState extends State<AdminEvents> {
  final TacgEventRepository eventRepository = TacgEventRepository();
  late Future<List<TacgEvent>> eventsFuture;
  late Future<TacgEvent> current_event;

  @override
  void initState() {
    super.initState();
    // Start loading events when widget initializes
    eventsFuture = eventRepository.getTacgEvents();
    current_event = eventRepository.getCurrentEvent();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnWidth = screenWidth < 600 ? 250.0 : 300.0;

    return Scaffold(
      body: Row(
        children: [
          // Persistent Drawer
          const Expanded(flex: 1, child: Mydrawer()),

          // Main content area
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Header remains the same
                const Expanded(flex: 1, child: HeaderWidget()),

                // Body section with grid - FIXED SCROLLING
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //First section with event creation and current event display
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Column(
                            children: [
                              // Add Event Button
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                ),
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  right: 8.0,
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
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
                                                const CreateEventPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add),
                                      color: Colors
                                          .white, // Optional: Set icon color to white for contrast
                                    ),
                                  ),
                                ),
                              ),
                              // Current Event Text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Current Event",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SelectCurrentEventPage(
                                            eventsFuture: eventsFuture,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                    color: Colors
                                        .black, // Optional: Set icon color to white for contrast
                                  ),
                                ],
                              ),
                              //linear gradient underline
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                height: 3,
                                width: 150, // Width of the underline
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue,
                                      Colors.purple,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              // Current Event Card
                              FutureBuilder(
                                future: current_event,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData) {
                                    return const Center(
                                        child: Text('No event found'));
                                  }

                                  final event = snapshot.data as TacgEvent;

                                  return Align(
                                    alignment: Alignment.center,
                                    child: FractionallySizedBox(
                                      widthFactor:
                                          0.3, // Takes 70% of parent width
                                      child: EventCard(event: event),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        // Second section with grid of events
                        Container(
                          height: 500,
                          margin: const EdgeInsets.only(
                              top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FutureBuilder<List<TacgEvent>>(
                            future: eventsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No events found'));
                              }

                              final events = snapshot.data!;
                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              final horizontalPadding = screenWidth * 0.05;
                              return CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding,
                                    ),
                                    sliver: SliverGrid(
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: columnWidth,
                                        mainAxisExtent: 300.0,
                                        mainAxisSpacing: 10.0,
                                        crossAxisSpacing: 10.0,
                                      ),
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          // This is already lazy - only builds visible items
                                          final event = events[index];
                                          return EventCard(event: event);
                                        },
                                        childCount: events.length,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
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



// Navigator.push(
//                 context,
//                 MaterialPageRoute<ProfileScreen>(
//                   builder: (context) => ProfileScreen(
//                     appBar: AppBar(
//                       title: const Text('Profile'),
//                     ),
//                     actions: [
//                       SignedOutAction((context) {
//                         Navigator.of(context).pop();
//                       })
//                     ],
//                     children: [
//                       const Divider(),
//                       Padding(
//                         padding: const EdgeInsets.all(2),
//                         child: AspectRatio(
//                           aspectRatio: 1,
//                           child: Image.asset('lib/assets/tacg-nbg.png'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
