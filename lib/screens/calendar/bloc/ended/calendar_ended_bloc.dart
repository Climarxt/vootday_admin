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
      print('CalendarEndedFetchEvent : Fetching this week events...');
      final thisWeekEvents = await _eventRepository.getThisWeekEvents();

      if (thisWeekEvents.isNotEmpty) {
        print(
            'CalendarEndedFetchEvent : This week events fetched successfully.');
        emit(state.copyWith(
            thisWeekEvents: thisWeekEvents,
            status: CalendarEndedStatus.loaded));
      } else {
        print('CalendarEndedFetchEvent : No events found for this week.');
        emit(state.copyWith(
            thisWeekEvents: [], status: CalendarEndedStatus.noEvents));
      }
    } catch (err) {
      print('CalendarEndedFetchEvent : Error fetching events - $err');
      emit(state.copyWith(
        status: CalendarEndedStatus.error,
        failure: const Failure(message: 'Unable to load the events'),
        thisWeekEvents: [],
      ));
    }
  }
}
