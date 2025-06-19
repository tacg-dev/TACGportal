import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;

  UserModel({required this.id, required this.displayName, required this.email});

  @override
  String toString() => displayName; // For display in autocomplete
}

class IndividualAttendanceRecordModel {
  final bool? status;
  final String? title;
  final DateTime? date;
  final String? time;
  final bool isMandatory;

  IndividualAttendanceRecordModel({
    this.status,
    this.title,
    this.date,
    this.time,
    this.isMandatory = false,
  });
}

class IndividualAttendance extends StatefulWidget {
  const IndividualAttendance({super.key});

  @override
  State<IndividualAttendance> createState() => _IndividualAttendanceState();
}

class _IndividualAttendanceState extends State<IndividualAttendance> {
  List<UserModel> _allUsers = [];
  UserModel? _selectedUser;
  List<IndividualAttendanceRecordModel> _attendanceRecords = [];

  int _mandatoryMissed = 0;
  int _nonMandatoryMissed = 0;
  int _totalMissed = 0;
  int _totalAttended = 0;

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // get all users from Firestore and store them in _allUsers
  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        _allUsers = snapshot.docs
            .map((doc) => UserModel(
                id: doc.id,
                displayName: (doc['displayName'] ?? 'Unknown') as String,
                email: doc['email'] as String))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading users: $e';
        _isLoading = false;
      });
    }
  }

  // returns a list of IndividualAttendanceRecordModel based on the selected user
  Future<List<IndividualAttendanceRecordModel>> _fetchEvents() async {
    if (_selectedUser?.id == null) {
      return [];
    }

    List<IndividualAttendanceRecordModel> attendanceRecords = [];

    try {
      final query = await FirebaseFirestore.instance
          .collection('attendance_records')
          .where('userId', isEqualTo: _selectedUser!.id)
          .orderBy('eventId', descending: true)
          .get();

      // Reset counters before processing new records
      _mandatoryMissed = 0;
      _nonMandatoryMissed = 0;
      _totalMissed = 0;
      _totalAttended = 0;

      // Process each attendance record document

      for (var attendanceDoc in query.docs) {
        final attendanceData = attendanceDoc.data();

        // Get status from attendance record
        final bool? status = attendanceData['status'];
        final String? eventId = attendanceData['eventId'];

        if (eventId != null) {
          // Query the event document to get title, date, time, isMandatory
          final eventDoc = await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .get();

          if (eventDoc.exists) {
            final eventData = eventDoc.data();

            // Extract event details
            final String? title = eventData?['title'];
            final DateTime? date = eventData?['date'] != null
                ? DateTime.parse(eventData!['date'])
                : null;
            final String? time = eventData?['time'];
            final bool isMandatory = eventData?['isMandatory'] ?? false;

            // Create IndividualAttendanceRecordModel instance
            final attendanceRecord = IndividualAttendanceRecordModel(
              status: status,
              title: title,
              date: date,
              time: time,
              isMandatory: isMandatory,
            );

            attendanceRecords.add(attendanceRecord);

            // Update counters based on attendance record
            if (status == false) {
              // Missed event
              if (isMandatory) {
                _mandatoryMissed++;
              } else {
                _nonMandatoryMissed++;
              }
              _totalMissed++;
            } else if (status == true) {
              // Attended event
              _totalAttended++;
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching events: $e');
    }

    return attendanceRecords;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: [
        const Text(
          'Select Member',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Autocomplete widget for user search
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Autocomplete<UserModel>(
            displayStringForOption: (UserModel user) => user.displayName,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<UserModel>.empty();
              }

              return _allUsers.where((user) =>
                  user.displayName
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()) ||
                  user.email
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: (UserModel user) async {
              setState(() {
                _selectedUser = user;
                _isLoading = true; // Show loading indicator
              });

              // Fetch events asynchronously
              final records = await _fetchEvents();

              // Update state with the fetched records
              setState(() {
                _attendanceRecords = records;
                _isLoading = false;
              });
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Search by name or email',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (_) =>
                    _selectedUser == null ? 'Please select a user' : null,
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: SizedBox(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width * 0.66,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final UserModel user = options.elementAt(index);
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(user.displayName),
                          subtitle: Text(user.email),
                          onTap: () => onSelected(user),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        if (_selectedUser == null)
          Text(
            'Please select a user to view attendance records.',
            style: TextStyle(color: Colors.grey[600]),
          )
        else if (_isLoading)
          const Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Loading attendance records...'),
            ],
          )
        else if (_errorMessage.isNotEmpty)
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          )
        else if (_attendanceRecords.isEmpty)
          Text(
            'No attendance records found for ${_selectedUser!.displayName}',
            style: TextStyle(color: Colors.grey[600]),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Attendance Records for ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      _selectedUser!.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16.0,
                    runSpacing: 12.0,
                    children: [
                      _buildStatItem(Colors.green, 'Attended', _totalAttended),
                      _buildStatItem(Colors.black, 'Total Missed', _totalMissed),
                      _buildStatItem(
                          Colors.red, 'Mandatory Missed', _mandatoryMissed),
                      _buildStatItem(Colors.yellow, 'Non Mandatory Missed',
                          _nonMandatoryMissed),
                    ],
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.6,
                  // timeline
                  child: Timeline.tileBuilder(
                    builder: TimelineTileBuilder.connected(
                      itemCount: _attendanceRecords.length,
                      contentsAlign: ContentsAlign.basic,
                      connectionDirection: ConnectionDirection.after,

                      // Set these to null to hide first/last connectors
                      firstConnectorBuilder:
                          null, // No connector before first item
                      lastConnectorBuilder:
                          null, // No connector after last item

                      contentsBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_attendanceRecords[index].date.toString()),
                            Text(_attendanceRecords[index].time ?? 'No Time'),
                          ],
                        ),
                      ),

                      oppositeContentsBuilder: (context, index) {
                        final record = _attendanceRecords[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                record.title ?? 'No Title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (record.isMandatory)
                                Icon(
                                  Icons.priority_high,
                                  color: Colors.red,
                                  size: mediaQuery.size.width > 600 ? 32 : 24,
                                ),
                            ],
                          ),
                        );
                      },

                      indicatorBuilder: (context, index) {
                        final record = _attendanceRecords[index];
                        return DotIndicator(
                          color:
                              record.status == true ? Colors.green : Colors.red,
                          size: 16.0,
                        );
                      },

                      connectorBuilder: (context, index, connectorType) {
                        return const SolidLineConnector(
                          color: Colors.grey,
                          thickness: 2.0,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),
      ],
    );
  }
}

// Timeline.tileBuilder(
//         builder: TimelineTileBuilder.fromStyle(
//           contentsAlign: ContentsAlign.alternating,
//           contentsBuilder: (context, index) => Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Text('Timeline Event $index'),
//           ),
//           itemCount: 10,
//         ),

// FixedTimeline.tileBuilder(
//   builder: TimelineTileBuilder.connectedFromStyle(
//     connectionDirection: ConnectionDirection.before,
//     connectorStyleBuilder: (context, index) {
//       return (index == 1) ? ConnectorStyle.dashedLine : ConnectorStyle.solidLine;
//     },
//     indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
//     itemExtent: 40.0,
//     itemCount: 3,
//   ),
// )

Widget _buildStatItem(Color color, String label, int count) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        '$label: $count',
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
