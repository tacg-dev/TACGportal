// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tacg_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TacgEventResponse _$TacgEventResponseFromJson(Map<String, dynamic> json) =>
    TacgEventResponse(
      events: (json['events'] as List<dynamic>)
          .map((e) => TacgEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TacgEventResponseToJson(TacgEventResponse instance) =>
    <String, dynamic>{
      'events': instance.events,
    };

TacgEvent _$TacgEventFromJson(Map<String, dynamic> json) => TacgEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      date: TacgEvent._dateTimeFromJson(json['date'] as String),
      time: json['time'] as String,
      description: json['description'] as String,
      isMandatory: json['isMandatory'] as bool? ?? false,
    );

Map<String, dynamic> _$TacgEventToJson(TacgEvent instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': TacgEvent._dateTimeToJson(instance.date),
      'time': instance.time,
      'description': instance.description,
      'isMandatory': instance.isMandatory,
    };
