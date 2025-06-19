import 'package:json_annotation/json_annotation.dart';

part 'tacg_event.g.dart';


@JsonSerializable()
class TacgEventResponse {
  final List<TacgEvent> events;

  const TacgEventResponse({required this.events});

  factory TacgEventResponse.fromJson(Map<String, dynamic> json) => 
      _$TacgEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TacgEventResponseToJson(this);
}

@JsonSerializable()
class TacgEvent {
  final String id;
  final String title;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime date;
  final String time;
  final String description;
  final bool isMandatory;

  const TacgEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    this.isMandatory = false,
  });
  
  factory TacgEvent.fromJson(Map<String, dynamic> json) => _$TacgEventFromJson(json);
  Map<String, dynamic> toJson() => _$TacgEventToJson(this);

  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

}