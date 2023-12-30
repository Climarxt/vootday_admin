import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_ended_event.dart';
part 'calendar_ended_state.dart';

class CalendarEndedBloc
    extends Bloc<CalendarEndedEvent, CalendarEndedState> {
  final EventRepository _eventRepository;

  CalendarEndedBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(CalendarEndedState.initial()) {
    on<CalendarEndedFetchEvent>(_mapCalendarEndedFetchEvent);
  }

  Future<void> _mapCalendarEndedFetchEvent(
    CalendarEndedFetchEvent event,
    Emitter<CalendarEndedState> emit,
  ) async {
    try {
      print('_mapCalendarEndedFetchEvent : Fetching this ended events...');
      final thisEndedEvents = await _eventRepository.getThisEndedEvents();

      if (thisEndedEvents.isNotEmpty) {
        print(
            '_mapCalendarEndedFetchEvent : This ended events fetched successfully.');
        emit(state.copyWith(
            thisEndedEvents: thisEndedEvents,
            status: CalendarEndedStatus.loaded));
      } else {
        print('_mapCalendarEndedFetchEvent : No events found.');
        emit(state.copyWith(
            thisEndedEvents: [], status: CalendarEndedStatus.noEvents));
      }
    } catch (err) {
      print('_mapCalendarEndedFetchEvent : Error fetching events - $err');
      emit(state.copyWith(
        status: CalendarEndedStatus.error,
        failure: const Failure(message: '_mapCalendarEndedFetchEvent : Unable to load the events'),
        thisEndedEvents: [],
      ));
    }
  }
}
