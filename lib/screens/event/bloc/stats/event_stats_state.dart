part of 'event_stats_bloc.dart';

enum EventStatsStatus { initial, loading, loaded, noEvents, error }

class EventStatsState extends Equatable {
  final int likesEventCount;
  final int remainingDaysCount;
  final EventStatsStatus status;
  final Failure failure;

  const EventStatsState({
    required this.likesEventCount,
    required this.remainingDaysCount,
    required this.status,
    required this.failure,
  });

  factory EventStatsState.initial() {
    return const EventStatsState(
      likesEventCount: 0,
      remainingDaysCount: 0,
      status: EventStatsStatus.initial,
      failure: Failure(),
    );
  }

  factory EventStatsState.loading() {
    return const EventStatsState(
      likesEventCount: 0,
      remainingDaysCount: 0,
      status: EventStatsStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [likesEventCount, status, failure];

  EventStatsState copyWith({
    int? likesEventCount,
    int? remainingDaysCount,
    EventStatsStatus? status,
    Failure? failure,
  }) {
    return EventStatsState(
      likesEventCount: likesEventCount ?? this.likesEventCount,
      remainingDaysCount: remainingDaysCount ?? this.remainingDaysCount,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
