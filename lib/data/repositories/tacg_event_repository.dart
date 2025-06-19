import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/data/repositories/interfaces/i_tacg_event_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TacgEventRepository implements ITacgEventRepository {
  List<TacgEvent>? cachedEvents;
  DateTime? lastFetchDate;

  TacgEventRepository();

  @override
  Future<List<TacgEvent>> getTacgEvents({bool forceRefresh = false}) async {
    final shouldFetch = cachedEvents == null ||
        forceRefresh ||
        lastFetchDate == null ||
        DateTime.now().difference(lastFetchDate!).inMinutes > 30;

    if (shouldFetch) {
      try {
        // Get events collection from Firestore
        final QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('events').get();

        // Convert each document to a TacgEvent object using fromJson
        final events = querySnapshot.docs.map((doc) {
          // Merge document ID with document data
          final data = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          return TacgEvent.fromJson(data);
        }).toList();

        // Update cache
        cachedEvents = events;
        lastFetchDate = DateTime.now();
        return events;
      } catch (e) {
        if (cachedEvents != null) {
          return cachedEvents!;
        }
        rethrow;
      }
    } else {
      return cachedEvents!;
    }
  }

  @override
  Future<void> addTacgEvent(TacgEvent event) async {
    if (await isDuplicateEvent(event)) {
      print("Event with the same title, date, and time already exists.");
      return;
    }    // Add the event to Firestore
    String docId = '${event.date.toString()}_${event.time}_${event.title}';
    final docRef = FirebaseFirestore.instance.collection('events').doc(docId);
    await docRef.set(event.toJson());
  }

  @override
  Future<void> updateTacgEvent(TacgEvent event) async {
    print("not for use currently");
  }

  @override
  Future<void> deleteTacgEvent(String eventId) async {
    print("not for use currently");
  }

  Future<bool> isDuplicateEvent(TacgEvent newEvent) async {
    String docId =
        '${newEvent.date.toString()}_${newEvent.time}_${newEvent.title}';
    final docRef = FirebaseFirestore.instance.collection('events').doc(docId);
    return docRef.get().then((doc) {
      if (doc.exists) {
        return true; // Event with the same title, date, and time already exists
      } else {
        return false; // No duplicate event found
      }
    });
  }

  // get tacg_eventId from TacgEvent object
  String getTacgEventId(TacgEvent event) {
    return '${event.date.toString()}_${event.time}_${event.title}';
  }
  // ignore: non_constant_identifier_names
  Future<void> setCurrentEvent(String tacg_eventId, String userId) async {
    print(tacg_eventId);
    final eventDoc = await FirebaseFirestore.instance
        .collection('events')
        .doc(tacg_eventId)
        .get();
    if (!eventDoc.exists) {
      throw Exception("Event not found");
    }

    await FirebaseFirestore.instance
        .collection('app_state')
        .doc("current_event")
        .set({
      'eventId': tacg_eventId,
      'createdBy': userId,
    });
  }

  Future<TacgEvent> getCurrentEvent() async {
    final eventDoc = await FirebaseFirestore.instance
        .collection('app_state')
        .doc("current_event")
        .get();
    if (!eventDoc.exists) {
      throw Exception("Current event not found");
    }

    final eventId = eventDoc.data()?['eventId'];
    if (eventId == null) {
      throw Exception("Event ID not found");
    }

    final eventSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .get();
    if (!eventSnapshot.exists) {
      throw Exception("Event not found");
    }

    return TacgEvent.fromJson({
      'id': eventSnapshot.id,
      ...eventSnapshot.data() as Map<String, dynamic>,
    });
  }

  // function to set attendance code for users to mark their attendance
  Future<void> setAttendanceCode(String code) async {
    await FirebaseFirestore.instance
        .collection('app_state')
        .doc("attendance_code")
        .set({
      'code': code,
    });
  }
}
