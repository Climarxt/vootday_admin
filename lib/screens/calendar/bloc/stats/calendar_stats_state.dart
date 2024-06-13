part of 'calendar_stats_bloc.dart';

enum CalendarStatsStatus { initial, loading, loaded, noEvents, error }

class CalendarStatsState extends Equatable {
  final int endedEventsCount;
  final int comingEventsCount;
  final CalendarStatsStatus endedEventsStatus;
  final CalendarStatsStatus comingEventsStatus;
  final Failure failure;

  const CalendarStatsState({
    required this.endedEventsCount,
    required this.comingEventsCount,
    required this.endedEventsStatus,
    required this.comingEventsStatus,
    required this.failure,
  });

  factory CalendarStatsState.initial() {
    return const CalendarStatsState(
      endedEventsCount: 0,
      comingEventsCount: 0,
      endedEventsStatus: CalendarStatsStatus.initial,
      comingEventsStatus: CalendarStatsStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [
        endedEventsCount,
        comingEventsCount,
        endedEventsStatus,
        comingEventsStatus,
        failure
      ];

  CalendarStatsState copyWith({
    int? endedEventsCount,
    int? comingEventsCount,
    CalendarStatsStatus? endedEventsStatus,
    CalendarStatsStatus? comingEventsStatus,
    Failure? failure,
  }) {
    return CalendarStatsState(
      endedEventsCount: endedEventsCount ?? this.endedEventsCount,
      comingEventsCount: comingEventsCount ?? this.comingEventsCount,
      endedEventsStatus: endedEventsStatus ?? this.endedEventsStatus,
      comingEventsStatus: comingEventsStatus ?? this.comingEventsStatus,
      failure: failure ?? this.failure,
    );
  }
}
