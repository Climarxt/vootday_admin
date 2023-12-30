part of 'calendar_stats_bloc.dart';

enum CalendarStatsStatus { initial, loading, loaded, noEvents, error }

class CalendarStatsState extends Equatable {
  final int endedEventsCount;
  final CalendarStatsStatus status;
  final Failure failure;

  const CalendarStatsState({
    required this.endedEventsCount,
    required this.status,
    required this.failure,
  });

  factory CalendarStatsState.initial() {
    return const CalendarStatsState(
      endedEventsCount: 0,
      status: CalendarStatsStatus.initial,
      failure: Failure(),
    );
  }

  factory CalendarStatsState.loading() {
    return const CalendarStatsState(
      endedEventsCount: 0,
      status: CalendarStatsStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [endedEventsCount, status, failure];

  CalendarStatsState copyWith({
    required int endedEventsCount,
    CalendarStatsStatus? status,
    Failure? failure,
  }) {
    return CalendarStatsState(
      endedEventsCount: endedEventsCount,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
