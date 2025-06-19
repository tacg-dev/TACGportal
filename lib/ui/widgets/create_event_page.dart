import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/data/repositories/tacg_event_repository.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
        backgroundColor: const Color(0xFFB71C1C), // TAMU maroon
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: CreateEventForm(),
      ),
    );
  }
}

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  CreateEventFormState createState() {
    return CreateEventFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateEventFormState extends State<CreateEventForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<CreateEventFormState>.
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  final _dateController =
      TextEditingController(); // To display the formatted date
  final _timeController =
      TextEditingController(); // To display the formatted time
  final _descriptionController =
      TextEditingController(); // To display the formatted description
  bool? _isMandatory;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Add this method to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2029),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Format the date for display
        _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.66,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Event Title",
                  hintText: "Enter the title of the event",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "Event Date",
                  hintText: "Select date",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true, // Prevents keyboard from appearing
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: "Event Time",
                  hintText: "Select time",
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Event Description",
                  hintText: "Enter the description of the event",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<bool>(
                decoration: const InputDecoration(
                  labelText: "Is Mandatory Event?",
                  hintText: "Select yes or no",
                ),
                value: _isMandatory,
                items: const [
                  DropdownMenuItem(value: true, child: Text('Yes')),
                  DropdownMenuItem(value: false, child: Text('No')),
                ],
                onChanged: (bool? newValue) {
                  setState(() {
                    _isMandatory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,

                      TacgEvent event = TacgEvent(
                        id: '${_selectedDate.toString()}_${_timeController.text}_${_titleController.text}',
                        title: _titleController.text,
                        date: _selectedDate!,
                        time: _timeController.text,
                        description: _descriptionController.text,
                        isMandatory: _isMandatory ?? false,
                      );

                      TacgEventRepository eventRepository =
                          TacgEventRepository();
                      eventRepository.isDuplicateEvent(event).then(
                        (isDuplicate) {
                          if (isDuplicate) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Event already exists!'),
                              ),
                            );
                          } else {
                            eventRepository.addTacgEvent(event);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Event created successfully!'),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
