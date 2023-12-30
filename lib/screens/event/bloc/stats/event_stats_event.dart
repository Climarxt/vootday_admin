part of 'event_stats_bloc.dart';

abstract class EventStatsEvent extends Equatable {
  const EventStatsEvent();

  @override
  List<Object?> get props => [];
}

class EventStatsCountLikesFetchEvent extends EventStatsEvent {
  final String eventId;

  const EventStatsCountLikesFetchEvent({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
