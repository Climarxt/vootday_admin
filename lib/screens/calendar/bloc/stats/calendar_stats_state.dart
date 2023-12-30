part of 'calendar_stats_bloc.dart';

sealed class CalendarStatsState extends Equatable {
  const CalendarStatsState();
  
  @override
  List<Object> get props => [];
}

final class CalendarStatsInitial extends CalendarStatsState {}
