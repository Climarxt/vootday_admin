part of 'calendar_ended_bloc.dart';

enum CalendarEndedStatus { initial, loading, loaded, noEvents, error }

class CalendarEndedState extends Equatable {
  final List<Event?> thisEndedEvents;
  final CalendarEndedStatus status;
  final Failure failure;

  const CalendarEndedState({
    required this.thisEndedEvents,
    required this.status,
    required this.failure,
  });

  factory CalendarEndedState.initial() {
    return const CalendarEndedState(
      thisEndedEvents: [],
      status: CalendarEndedStatus.initial,
      failure: Failure(),
    );
  }

  factory CalendarEndedState.loading() {
    return const CalendarEndedState(
      thisEndedEvents: [],
      status: CalendarEndedStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [thisEndedEvents, status, failure];

  CalendarEndedState copyWith({
    List<Event?>? thisEndedEvents,
    CalendarEndedStatus? status,
    Failure? failure,
  }) {
    return CalendarEndedState(
      thisEndedEvents: thisEndedEvents ?? this.thisEndedEvents,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
