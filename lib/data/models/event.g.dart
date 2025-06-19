// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventResponse _$EventResponseFromJson(Map<String, dynamic> json) =>
    EventResponse(
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventResponseToJson(EventResponse instance) =>
    <String, dynamic>{
      'events': instance.events,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      description: json['description'] as String?,
      start: Event._dateTimeFromJson(json['start'] as String?),
      location: json['location'] as String?,
      end: Event._dateTimeFromJson(json['end'] as String?),
      title: json['title'] as String,
      time: json['time'] as String?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'description': instance.description,
      'start': Event._dateTimeToJson(instance.start),
      'location': instance.location,
      'end': Event._dateTimeToJson(instance.end),
      'title': instance.title,
      'time': instance.time,
    };
