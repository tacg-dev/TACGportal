import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/attendance_record.dart';
import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/data/repositories/attendance_record_repository.dart';
import 'package:tacgportal/data/repositories/tacg_event_repository.dart';

class CreateAttendanceRecordPage extends StatelessWidget {
  const CreateAttendanceRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Attendance Record'),
        backgroundColor: const Color(0xFFB71C1C), // TAMU maroon
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: CreateAttendanceRecordForm(),
      ),
    );
  }
}

class CreateAttendanceRecordForm extends StatefulWidget {
  const CreateAttendanceRecordForm({super.key});

  @override
  CreateAttendanceRecordFormState createState() {
    return CreateAttendanceRecordFormState();
  }
}

class UserModel {
  final String id;
  final String displayName;
  final String email;

  UserModel({required this.id, required this.displayName, required this.email});

  @override
  String toString() => displayName; // For display in autocomplete
}

class CreateAttendanceRecordFormState
    extends State<CreateAttendanceRecordForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<CreateEventFormState>.
  final _formKey = GlobalKey<FormState>();
// Selected user data
  UserModel? _selectedUser;
  String? _selectedEventId;
  bool? _status;

  // List of all users for search
  List<UserModel> _allUsers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // List of events for dropdown
  List<TacgEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchEvents();
  }

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

  // Fetch events for dropdown
  Future<void> _fetchEvents() async {
    try {
      final eventRepo = TacgEventRepository();
      final eventsList = await eventRepo.getTacgEvents();

      setState(() {
        _events = eventsList;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading events: $e';
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a user')),
        );
        return;
      }

      if (_selectedEventId == null) {
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an event')),
        );
        return;
      }

      // Create a new attendance record
      AttendanceRecord newattendanceRecord = AttendanceRecord(
        id: '${_selectedEventId}_${_selectedUser!.id}', 
        userId: _selectedUser!.id,
        eventId: _selectedEventId!,
        status: _status ?? false, // Default status, can be modified if needed
      );
      AttendanceRecordRepository attendanceRepo = AttendanceRecordRepository();
      attendanceRepo.addAttendanceRecord(newattendanceRecord).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Attendance record created successfully')),
        );
        // Clear form
        setState(() {
          _selectedUser = null;
          _selectedEventId = null;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating record: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    // Build the form with autocomplete
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.66,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Member',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Autocomplete widget for user search
              Autocomplete<UserModel>(
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
                onSelected: (UserModel user) {
                  setState(() {
                    _selectedUser = user;
                  });
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
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

              const SizedBox(height: 16),

              // Show selected user information
              if (_selectedUser != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Member: ${_selectedUser!.displayName}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Email: ${_selectedUser!.email}'),
                            Text('ID: ${_selectedUser!.id}',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _selectedUser = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // Event dropdown Text Header
              const Text(
                'Select Event',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Autocomplete<TacgEvent>(
                displayStringForOption: (TacgEvent event) => event.title,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<TacgEvent>.empty();
                  }

                  return _events.where((event) => event.title
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (TacgEvent event) {
                  setState(() {
                    _selectedEventId = event.id;
                  });
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search for an event',
                      prefixIcon: const Icon(Icons.event),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (_) => _selectedEventId == null
                        ? 'Please select an event'
                        : null,
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
                            final TacgEvent event = options.elementAt(index);
                            return ListTile(
                              leading: const Icon(Icons.calendar_today),
                              title: Text(event.title),
                              subtitle: Text(event.date.toString()),
                              onTap: () => onSelected(event),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              if (_selectedEventId != null)
                Builder(builder: (context) {
                  final selectedEvent = _events.firstWhere(
                    (event) => event.id == _selectedEventId,
                    orElse: () => TacgEvent(
                        id: '',
                        title: 'Unknown',
                        date: DateTime.now(),
                        time: '',
                        description: '',
                        isMandatory: false),
                  );

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event_available, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Event: ${selectedEvent.title}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('Date: ${selectedEvent.date}'),
                              Text('Time: ${selectedEvent.time}'),
                              if (selectedEvent.isMandatory)
                                const Text('This is a mandatory event',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              Text('ID: ${selectedEvent.id}',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedEventId = null;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
              // Status switch
              Row(
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  Switch(
                    value: _status ?? false,
                    onChanged: (bool value) {
                      setState(() {
                        _status = value;
                      });
                    },
                  ),
                  Text(_status == true ? 'Present' : 'Absent'),
                ],
              ),
              const SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text(
                    'Create Attendance Record',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
