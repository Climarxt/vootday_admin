import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/config/logger/logger.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_coming_soon_event.dart';
part 'calendar_coming_soon_state.dart';

class CalendarComingSoonBloc
    extends Bloc<CalendarComingSoonEvent, CalendarComingSoonState> {
  final EventRepository _eventRepository;
  final ContextualLogger logger;

  CalendarComingSoonBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        logger = ContextualLogger('CalendarComingSoonBloc'),
        super(CalendarComingSoonState.initial()) {
    on<CalendarComingSoonFetchEvent>(_mapCalendarComingSoonFetchEvent);
    on<UpcomingEventsLoadAll>(_onUpcomingEventsLoadAll);
  }

  Future<void> _mapCalendarComingSoonFetchEvent(
    CalendarComingSoonFetchEvent event,
    Emitter<CalendarComingSoonState> emit,
  ) async {
    const String functionName = '_mapCalendarComingSoonFetchEvent';
    logger.logInfo(functionName, 'Triggered');
    try {
      logger.logInfo(functionName, 'Fetching this coming soon events...');
      final thisComingSoonEvents = await _eventRepository.getComingSoonEvents();

      if (thisComingSoonEvents.isNotEmpty) {
        logger.logInfo(
            functionName, 'This coming soon events fetched successfully.');
        emit(state.copyWith(
            thisComingSoonEvents: thisComingSoonEvents,
            status: CalendarComingSoonStatus.loaded));
      } else {
        logger.logInfo(functionName, 'No events found');
        emit(state.copyWith(
            thisComingSoonEvents: [],
            status: CalendarComingSoonStatus.noEvents));
      }
    } catch (err) {
      logger.logError(functionName, 'Error fetching events', {
        'error': err.toString(),
      });
      emit(state.copyWith(
        status: CalendarComingSoonStatus.error,
        failure: const Failure(
            message:
                '_mapCalendarComingSoonFetchEvent : Unable to load the events'),
        thisComingSoonEvents: [],
      ));
    }
  }

  Future<void> _onUpcomingEventsLoadAll(
    UpcomingEventsLoadAll event,
    Emitter<CalendarComingSoonState> emit,
  ) async {
    const String functionName = '_onUpcomingEventsLoadAll';
    logger.logInfo(functionName, 'Triggered');
    try {
      emit(state.copyWith(status: CalendarComingSoonStatus.loading));
      final List<Map<String, dynamic>> allEvents =
          await _eventRepository.getUpComingEvents();
      logger.logInfo(functionName, 'Events fetched successfully');
      emit(state.copyWith(
          allEvents: allEvents, status: CalendarComingSoonStatus.loaded));
    } catch (e) {
      logger.logError(functionName, 'Error fetching events', {
        'error': e.toString(),
      });
      emit(state.copyWith(
        status: CalendarComingSoonStatus.error,
        failure: Failure(message: e.toString()),
      ));
    }
  }
}
