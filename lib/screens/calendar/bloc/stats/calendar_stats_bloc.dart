import 'package:bloc/bloc.dart';
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
    on<CalendarStatsCountEndedFetchEvent>(
        _mapCalendarStatsCountEndedFetchEvent);
    on<CalendarStatsCountComingFetchEvent>(
        _mapCalendarStatsCountComingFetchEvent);
  }

  Future<void> _mapCalendarStatsCountEndedFetchEvent(
    CalendarStatsCountEndedFetchEvent event,
    Emitter<CalendarStatsState> emit,
  ) async {
    emit(state.copyWith(endedEventsStatus: CalendarStatsStatus.loading));
    try {
      final endedEventsCount = await _eventRepository.getCountEndedEvents();
      emit(state.copyWith(
        endedEventsCount: endedEventsCount,
        endedEventsStatus: CalendarStatsStatus.loaded,
      ));
    } catch (e) {
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
    emit(state.copyWith(comingEventsStatus: CalendarStatsStatus.loading));
    try {
      final comingEventsCount = await _eventRepository.getCountComingEvents();
      emit(state.copyWith(
        comingEventsCount: comingEventsCount,
        comingEventsStatus: CalendarStatsStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        comingEventsStatus: CalendarStatsStatus.error,
        failure: Failure(message: e.toString()),
      ));
    }
  }
}
