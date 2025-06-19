import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:tacgportal/data/models/event.dart';

class CalendarApiService {
  final String baseUrl;

  CalendarApiService({required this.baseUrl});

  Future<List<Event>> getEvents() async {
    var url = Uri.parse(baseUrl);

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> jsonCalendarEvents = jsonResponse['events'];
        return jsonCalendarEvents.map((json) => Event.fromJson(json)).toList();
      } catch (e) {
        print("Error decoding JSON: $e");
        throw Exception('Failed to decode JSON: $e');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }
}
