part of 'calendar_coming_soon_bloc.dart';

enum CalendarComingSoonStatus { initial, loading, loaded, noEvents, error }

class CalendarComingSoonState extends Equatable {
  final List<Event?> thisComingSoonEvents;
  final List<Map<String, dynamic>> allEvents;
  final CalendarComingSoonStatus status;
  final Failure failure;

  const CalendarComingSoonState({
    required this.thisComingSoonEvents,
    this.allEvents = const [],
    required this.status,
    required this.failure,
  });

  factory CalendarComingSoonState.initial() {
    return const CalendarComingSoonState(
      thisComingSoonEvents: [],
      allEvents: [],
      status: CalendarComingSoonStatus.initial,
      failure: Failure(),
    );
  }

  factory CalendarComingSoonState.loading() {
    return const CalendarComingSoonState(
      thisComingSoonEvents: [],
      allEvents: [],
      status: CalendarComingSoonStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [thisComingSoonEvents, allEvents, status, failure];

  CalendarComingSoonState copyWith({
    List<Event?>? thisComingSoonEvents,
    List<Map<String, dynamic>>? allEvents,
    CalendarComingSoonStatus? status,
    Failure? failure,
  }) {
    return CalendarComingSoonState(
      thisComingSoonEvents: thisComingSoonEvents ?? this.thisComingSoonEvents,
      allEvents: allEvents ?? this.allEvents,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
