


import 'package:tacgportal/data/models/event.dart';
import 'package:tacgportal/data/repositories/interfaces/i_calendar_repository.dart';
import 'package:tacgportal/data/services/api/calendar_api_service.dart';

class CalendarRepository implements ICalendarRepository {
  final CalendarApiService calendarApiService;
  List<Event>? cachedEvents;
  
  DateTime? lastFetchDate;

  CalendarRepository({required this.calendarApiService});

  @override
  Future<List<Event>> getEvents({bool forceRefresh = false}) async {
    final shouldFetch = cachedEvents == null || forceRefresh || lastFetchDate == null ||
     DateTime.now().difference(lastFetchDate!).inMinutes > 30;

     if (shouldFetch) {
        try {
            final events = await calendarApiService.getEvents();
            cachedEvents = events;
            lastFetchDate = DateTime.now();
            return events;
        }
        catch (e){
          if (cachedEvents != null){
            return cachedEvents!;
          }
          rethrow;
        }
     }
     else{
      return cachedEvents!;
     }

     
  }

  @override
  Future<void> addEvent(Event event) async {
    print("not for use currently");
  }

}
