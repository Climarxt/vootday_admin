part of 'calendar_stats_bloc.dart';

enum CalendarStatsStatus { initial, loading, loaded, noEvents, error }

class CalendarStatsState extends Equatable {
  final int endedEventsCount;
  final int comingEventsCount;
  final CalendarStatsStatus status;
  final Failure failure;

  const CalendarStatsState({
    required this.endedEventsCount,
    required this.comingEventsCount,
    required this.status,
    required this.failure,
  });

  factory CalendarStatsState.initial() {
    return const CalendarStatsState(
      endedEventsCount: 0,
      comingEventsCount: 0,
      status: CalendarStatsStatus.initial,
      failure: Failure(),
    );
  }

  factory CalendarStatsState.loading() {
    return const CalendarStatsState(
      endedEventsCount: 0,
      comingEventsCount: 0,
      status: CalendarStatsStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [endedEventsCount, status, failure];

  CalendarStatsState copyWith({
    int? endedEventsCount,
    int? comingEventsCount,
    CalendarStatsStatus? status,
    Failure? failure,
  }) {
    return CalendarStatsState(
      endedEventsCount: endedEventsCount ?? this.endedEventsCount,
      comingEventsCount: comingEventsCount ?? this.comingEventsCount,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
