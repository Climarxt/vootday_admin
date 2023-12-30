import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'calendar_coming_soon_event.dart';
part 'calendar_coming_soon_state.dart';

class CalendarComingSoonBloc
    extends Bloc<CalendarComingSoonEvent, CalendarComingSoonState> {
  final EventRepository _eventRepository;

  CalendarComingSoonBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(CalendarComingSoonState.initial()) {
    on<CalendarComingSoonFetchEvent>(_mapCalendarComingSoonFetchEvent);
  }

  Future<void> _mapCalendarComingSoonFetchEvent(
    CalendarComingSoonFetchEvent event,
    Emitter<CalendarComingSoonState> emit,
  ) async {
    try {
      debugPrint('_mapCalendarComingSoonFetchEvent : Fetching this coming soon events...');
      final thisComingSoonEvents = await _eventRepository.getComingSoonEvents();

      if (thisComingSoonEvents.isNotEmpty) {
        debugPrint(
            '_mapCalendarComingSoonFetchEvent : This coming soon events fetched successfully.');
        emit(state.copyWith(
            thisComingSoonEvents: thisComingSoonEvents,
            status: CalendarComingSoonStatus.loaded));
      } else {
        debugPrint(
            '_mapCalendarComingSoonFetchEvent : No events found');
        emit(state.copyWith(
            thisComingSoonEvents: [],
            status: CalendarComingSoonStatus.noEvents));
      }
    } catch (err) {
      debugPrint('_mapCalendarComingSoonFetchEvent : Error fetching events - $err');
      emit(state.copyWith(
        status: CalendarComingSoonStatus.error,
        failure: const Failure(message: '_mapCalendarComingSoonFetchEvent : Unable to load the events'),
        thisComingSoonEvents: [],
      ));
    }
  }
}
