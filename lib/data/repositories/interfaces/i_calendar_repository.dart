

import 'package:tacgportal/data/models/event.dart';

abstract class ICalendarRepository {
  Future<List<Event>> getEvents({bool forceRefresh = false});
  Future<void> addEvent(Event event);
}