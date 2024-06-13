import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/config/logger/logger.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_stats_event.dart';
part 'calendar_stats_state.dart';

class CalendarStatsBloc extends Bloc<CalendarStatsEvent, CalendarStatsState> {
  final EventRepository _eventRepository;
  bool _isFetchingComingEvents = false;
  final ContextualLogger logger;

  CalendarStatsBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        logger = ContextualLogger('CalendarStatsBloc'),
        super(CalendarStatsState.initial()) {
    logger.logInfo('CalendarStatsBloc', 'CalendarStatsBloc initialized');
    on<CalendarStatsCountEndedFetchEvent>(
        _mapCalendarStatsCountEndedFetchEvent);
    on<CalendarStatsCountComingFetchEvent>(
        _mapCalendarStatsCountComingFetchEvent);
  }

  Future<void> _mapCalendarStatsCountEndedFetchEvent(
    CalendarStatsCountEndedFetchEvent event,
    Emitter<CalendarStatsState> emit,
  ) async {
    const String functionName = '_mapCalendarStatsCountEndedFetchEvent';
    emit(state.copyWith(endedEventsStatus: CalendarStatsStatus.loading));
    try {
      final endedEventsCount = await _eventRepository.getCountEndedEvents();
      logger.logInfo(functionName, 'Ended events count fetched successfully', {
        'endedEventsCount': endedEventsCount,
      });
      emit(state.copyWith(
        endedEventsCount: endedEventsCount,
        endedEventsStatus: CalendarStatsStatus.loaded,
      ));
    } catch (e) {
      logger.logError(functionName, 'Error fetching ended events count', {
        'error': e.toString(),
      });
      emit(state.copyWith(
        endedEventsStatus: CalendarStatsStatus.error,
        failure: Failure(message: e.toString()),
      ));
    }
  }

  Future<void> _mapCalendarStatsCountComingFetchEvent(
    CalendarStatsCountComingFetchEvent event,
    Emitter<CalendarStatsState> emit,
  ) async {
    const String functionName = '_mapCalendarStatsCountComingFetchEvent';
    if (_isFetchingComingEvents) return;
    _isFetchingComingEvents = true;

    emit(state.copyWith(comingEventsStatus: CalendarStatsStatus.loading));
    try {
      final comingEventsCount = await _eventRepository.getCountComingEvents();
      logger.logInfo(functionName, 'Fetching coming events count', {
        'comingEventsCount': comingEventsCount,
      });
      emit(state.copyWith(
        comingEventsCount: comingEventsCount,
        comingEventsStatus: CalendarStatsStatus.loaded,
      ));
    } catch (e) {
      logger.logError(functionName, 'Error fetching coming events count', {
        'error': e.toString(),
      });
      emit(state.copyWith(
        comingEventsStatus: CalendarStatsStatus.error,
        failure: Failure(message: e.toString()),
      ));
    } finally {
      _isFetchingComingEvents = false;
    }
  }
}
