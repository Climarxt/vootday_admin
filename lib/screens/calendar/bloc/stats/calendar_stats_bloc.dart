import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_stats_event.dart';
part 'calendar_stats_state.dart';

class CalendarStatsBloc extends Bloc<CalendarStatsEvent, CalendarStatsState> {
  final EventRepository _eventRepository;

  CalendarStatsBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(CalendarStatsState.initial()) {
    on<CalendarStatsCountEndedFetchEvent>(_mapCalendarStatsCountEndedFetchEvent);
  }

  Future<void> _mapCalendarStatsCountEndedFetchEvent(
    CalendarStatsCountEndedFetchEvent event,
    Emitter<CalendarStatsState> emit,
  ) async {
    try {
      debugPrint('_mapCalendarStatsCountEndedFetchEvent : Fetching count events...');
      final int endedEventsCount = await _eventRepository.getCountEndedEvents();

      if (endedEventsCount > 0) {
        debugPrint(
            '_mapCalendarStatsCountEndedFetchEvent : This count events fetched successfully.');
        emit(state.copyWith(
            endedEventsCount: endedEventsCount,
            status: CalendarStatsStatus.loaded));
      } else {
        debugPrint('_mapCalendarStatsCountEndedFetchEvent : No events found');
        emit(state.copyWith(
            endedEventsCount: 0, status: CalendarStatsStatus.noEvents));
      }
    } catch (err) {
      debugPrint('_mapCalendarStatsCountEndedFetchEvent : Error fetching events - $err');
      emit(state.copyWith(
        status: CalendarStatsStatus.error,
        failure: const Failure(message: '_mapCalendarStatsCountEndedFetchEvent : Unable to load the events'),
        endedEventsCount: 0,
      ));
    }
  }
}
