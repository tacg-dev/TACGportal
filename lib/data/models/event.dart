import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';


@JsonSerializable()
class EventResponse {
  final List<Event> events;

  const EventResponse({required this.events});

  factory EventResponse.fromJson(Map<String, dynamic> json) => _$EventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventResponseToJson(this);

}

@JsonSerializable()
class Event {
  final String? description;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? start;

  final String? location;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? end;
  
  final String title;

  final String? time;

  const Event({
    this.description,
    this.start,
    this.location,
    this.end,
    required this.title,
    this.time,
  });



  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);

  static DateTime? _dateTimeFromJson(String? date) => 
      date == null ? null : DateTime.parse(date);
  static String? _dateTimeToJson(DateTime? date) => 
      date?.toIso8601String();
}
