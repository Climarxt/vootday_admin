part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class EventFetchEvent extends EventEvent {
  final String eventId;

  const EventFetchEvent({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class EventUpdateFieldEvent extends EventEvent {
  final String eventId;
  final String field;
  final dynamic newValue;

  const EventUpdateFieldEvent({
    required this.eventId,
    required this.field,
    required this.newValue,
  });

  @override
  List<Object> get props => [eventId, field, newValue];
}
