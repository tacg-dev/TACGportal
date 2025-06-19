


import 'package:flutter/foundation.dart';
import 'package:tacgportal/data/models/event.dart';
import 'package:tacgportal/data/repositories/interfaces/i_calendar_repository.dart';

class CalendarProvider extends ChangeNotifier{

  final ICalendarRepository _calendarRepository;

  CalendarProvider(this._calendarRepository);

  List<Event> pEvents = [];

  bool pIsLoading = false;

  String? pError;

  List<Event> get events => pEvents;
  bool get isLoading => pIsLoading;
  String? get error => pError;

  Future<void> loadEvents({bool refresh = false}) async {
    pIsLoading = true;
    pError = null;
    notifyListeners();
    
    try {
      pEvents = await _calendarRepository.getEvents(forceRefresh: refresh);
      pError = null;
    } catch (e) {
      pError = e.toString();
    } finally {
      pIsLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(Event event) async {
    pIsLoading = true;
    notifyListeners();
    
    try {
      await _calendarRepository.addEvent(event);
      await loadEvents();
    } catch (e) {
      pError = e.toString();
      pIsLoading = false;
      notifyListeners();
    }
  }

}