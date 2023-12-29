part of 'calendar_ended_bloc.dart';

enum CalendarEndedStatus { initial, loading, loaded, noEvents, error }

class CalendarEndedState extends Equatable {
  final List<Event?> thisWeekEvents;
  final CalendarEndedStatus status;
  final Failure failure;

  const CalendarEndedState({
    required this.thisWeekEvents,
    required this.status,
    required this.failure,
  });

  factory CalendarEndedState.initial() {
    return const CalendarEndedState(
      thisWeekEvents: [],
      status: CalendarEndedStatus.initial,
      failure: Failure(),
    );
  }

  factory CalendarEndedState.loading() {
    return const CalendarEndedState(
      thisWeekEvents: [],
      status: CalendarEndedStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [thisWeekEvents, status, failure];

  CalendarEndedState copyWith({
    List<Event?>? thisWeekEvents,
    CalendarEndedStatus? status,
    Failure? failure,
  }) {
    return CalendarEndedState(
      thisWeekEvents: thisWeekEvents ?? this.thisWeekEvents,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
