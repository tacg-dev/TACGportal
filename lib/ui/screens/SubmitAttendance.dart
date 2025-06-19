import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/ui/widgets/basic_layout/Header.dart';
import 'package:tacgportal/ui/widgets/basic_layout/mydrawer.dart';

class Submitattendance extends StatelessWidget {
  const Submitattendance({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          // Persistent Drawer
          Expanded(flex: 1, child: Mydrawer()),
          // Header + Main Content
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Header Section
                Expanded(
                  flex: 1,
                  child: HeaderWidget(),
                ),
                // Body Section
                Expanded(
                  flex: 5,
                  child: SubmitAttendanceForm(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubmitAttendanceForm extends StatefulWidget {
  const SubmitAttendanceForm({super.key});

  @override
  _SubmitAttendanceFormState createState() => _SubmitAttendanceFormState();
}

class _SubmitAttendanceFormState extends State<SubmitAttendanceForm> {
  final _formKey = GlobalKey<FormState>();
  final _passcodeController = TextEditingController();
  TacgEvent? currentEvent;
  bool? loading;
  bool? present;
  String? passcode;

  @override
  void initState() {
    super.initState();
    // Initialize the current event and loading state
    loading = true;

    FirebaseFirestore.instance
        .collection("app_state")
        .doc("current_event")
        .get()
        .then((doc) {
      if (doc.exists) {
        String currentEventId = doc['eventId'];
        FirebaseFirestore.instance
            .collection("events")
            .doc(currentEventId)
            .get()
            .then((eventDoc) {
          if (eventDoc.exists) {
            setState(() {
              currentEvent = TacgEvent.fromJson(eventDoc.data()!);
              loading = false;
            });
          } else {
            setState(() {
              loading = false;
            });
          }
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });

    FirebaseFirestore.instance
        .collection("app_state")
        .doc("attendance_passcode")
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          passcode = doc['passcode'];
        });
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading!) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.66,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: currentEvent?.isMandatory == true
                        ? Colors.red
                        : Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              currentEvent?.title ?? "No Event Selected",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (currentEvent?.isMandatory == true)
                            Tooltip(
                              message: "This event is mandatory",
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "MANDATORY",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoRow(
                                context,
                                Icons.calendar_today,
                                "Date",
                                currentEvent?.date != null
                                    ? "${currentEvent!.date.month}/${currentEvent!.date.day}/${currentEvent!.date.year}"
                                    : "N/A"),
                          ),
                          Expanded(
                            child: _buildInfoRow(
                              context,
                              Icons.access_time,
                              "Time",
                              currentEvent?.time ?? "N/A",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (currentEvent?.description != null &&
                          currentEvent!.description.isNotEmpty)
                        _buildInfoRow(
                          context,
                          Icons.description,
                          "Description",
                          currentEvent!.description,
                        ),
                    ],
                  ),
                ),
              ),
              TextFormField(
                controller: _passcodeController,
                decoration: const InputDecoration(
                  labelText: 'Passcode',
                  hintText: 'Enter the event passcode',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a passcode';
                  } else if (value != passcode) {
                    return 'Incorrect passcode';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<bool>(
                decoration: const InputDecoration(
                  labelText: "Were you Present?",
                  hintText: "Select yes or no",
                ),
                value: present,
                items: const [
                  DropdownMenuItem(value: true, child: Text('Yes')),
                  DropdownMenuItem(value: false, child: Text('No')),
                ],
                onChanged: (bool? newValue) {
                  setState(() {
                    present = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {

                      // Show loading indicator
                      setState(() {
                        loading = true;
                      });
                      
                      // Get current user ID from Firebase Auth
                      final currentUser = FirebaseAuth.instance.currentUser;

                      if (currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error: No user logged in')),
                        );
                        return;
                      }

                      if (currentEvent == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error: No active event found')),
                        );
                        return;
                      }

                      // Construct document ID by concatenating event ID and user ID
                      String attendanceRecordId =
                          '${currentEvent!.id}_${currentUser.uid}';

                      // Reference to the attendance record
                      final attendanceRecordRef = FirebaseFirestore.instance
                          .collection('attendance_records')
                          .doc(attendanceRecordId);

                      

                      // Get the document
                      final docSnapshot = await attendanceRecordRef.get();

                      if (docSnapshot.exists) {
                        // Check if status needs updating
                        final currentStatus = docSnapshot.data()?['status'];

                        if (currentStatus != present) {
                          // Update only if status is different
                          await attendanceRecordRef.update({
                            'status': present,
                            'lastUpdated': FieldValue.serverTimestamp(),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Attendance updated successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // No change needed
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Attendance record already up to date'),
                            ),
                          );
                        }
                      } else {
                        // Record not found - should not happen, but handle it gracefully
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error: Attendance record not found'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      // Error handling
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error updating attendance: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      // Reset loading state
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
                child: const Text('Submit Attendance'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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
