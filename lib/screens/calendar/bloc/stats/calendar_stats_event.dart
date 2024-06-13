part of 'calendar_stats_bloc.dart';

abstract class CalendarStatsEvent extends Equatable {
  const CalendarStatsEvent();

  @override
  List<Object?> get props => [];
}

class CalendarStatsCountEndedFetchEvent extends CalendarStatsEvent {}

class CalendarStatsCountComingFetchEvent extends CalendarStatsEvent {}
