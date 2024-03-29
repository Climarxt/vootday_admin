import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_ended_event.dart';
part 'calendar_ended_state.dart';

class CalendarEndedBloc extends Bloc<CalendarEndedEvent, CalendarEndedState> {
  final EventRepository _eventRepository;

  CalendarEndedBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(CalendarEndedState.initial()) {
    on<CalendarEndedFetchEvent>(_mapCalendarEndedFetchEvent);
    on<EndedEventsLoadAll>(_onEndedEventsLoadAll);
  }

  Future<void> _mapCalendarEndedFetchEvent(
    CalendarEndedFetchEvent event,
    Emitter<CalendarEndedState> emit,
  ) async {
    try {
      debugPrint('_mapCalendarEndedFetchEvent : Fetching this ended events...');
      final thisEndedEvents = await _eventRepository.getThisEndedEvents();

      if (thisEndedEvents.isNotEmpty) {
        debugPrint(
            '_mapCalendarEndedFetchEvent : This ended events fetched successfully.');
        emit(state.copyWith(
            thisEndedEvents: thisEndedEvents,
            status: CalendarEndedStatus.loaded));
      } else {
        debugPrint('_mapCalendarEndedFetchEvent : No events found.');
        emit(state.copyWith(
            thisEndedEvents: [], status: CalendarEndedStatus.noEvents));
      }
    } catch (err) {
      debugPrint('_mapCalendarEndedFetchEvent : Error fetching events - $err');
      emit(state.copyWith(
        status: CalendarEndedStatus.error,
        failure: const Failure(
            message: '_mapCalendarEndedFetchEvent : Unable to load the events'),
        thisEndedEvents: [],
      ));
    }
  }

  void _onEndedEventsLoadAll(
    EndedEventsLoadAll event,
    Emitter<CalendarEndedState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CalendarEndedStatus.loading));
      final List<Map<String, dynamic>> allEvents =
          await _eventRepository.getEndedEvents();
      emit(state.copyWith(
          allEvents: allEvents, status: CalendarEndedStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: CalendarEndedStatus.error,
        failure: Failure(message: e.toString()),
      ));
    }
  }
}
