part of 'calendar_ended_bloc.dart';

abstract class CalendarEndedEvent extends Equatable {
  const CalendarEndedEvent();

  @override
  List<Object?> get props => [];
}

class CalendarEndedFetchEvent extends CalendarEndedEvent {}

class EndedEventsLoadAll extends CalendarEndedEvent {
  @override
  List<Object> get props => [];
}
