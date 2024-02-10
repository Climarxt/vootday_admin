part of 'calendar_ended_bloc.dart';

enum CalendarEndedStatus { initial, loading, loaded, noEvents, error }

class CalendarEndedState extends Equatable {
  final List<Event?> thisEndedEvents;
  final List<Map<String, dynamic>> allEvents;
  final CalendarEndedStatus status;
  final Failure failure;

  const CalendarEndedState({
    required this.thisEndedEvents,
    this.allEvents = const [],
    required this.status,
    required this.failure,
  });

  factory CalendarEndedState.initial() {
    return const CalendarEndedState(
      thisEndedEvents: [],
      allEvents: [],
      status: CalendarEndedStatus.initial,
      failure: Failure(),
    );
  }

  factory CalendarEndedState.loading() {
    return const CalendarEndedState(
      thisEndedEvents: [],
      allEvents: [],
      status: CalendarEndedStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [thisEndedEvents, allEvents, status, failure];

  CalendarEndedState copyWith({
    List<Event?>? thisEndedEvents,
    List<Map<String, dynamic>>? allEvents,
    CalendarEndedStatus? status,
    Failure? failure,
  }) {
    return CalendarEndedState(
      thisEndedEvents: thisEndedEvents ?? this.thisEndedEvents,
      allEvents: allEvents ?? this.allEvents,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
