import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_stats_event.dart';
part 'calendar_stats_state.dart';

class CalendarStatsBloc extends Bloc<CalendarStatsEvent, CalendarStatsState> {
  final EventRepository _eventRepository;

  int? _endedEventsCount;
  int? _comingEventsCount;

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
    _endedEventsCount = await _eventRepository.getCountEndedEvents();
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapCalendarStatsCountComingFetchEvent(
    CalendarStatsCountComingFetchEvent event,
    Emitter<CalendarStatsState> emit,
  ) async {
    _comingEventsCount = await _eventRepository.getCountComingEvents();
    _updateStateIfDataReady(emit);
  }

  void _updateStateIfDataReady(Emitter<CalendarStatsState> emit) {
    if (_endedEventsCount != null && _comingEventsCount != null) {
      emit(CalendarStatsState(
        endedEventsCount: _endedEventsCount!,
        comingEventsCount: _comingEventsCount!,
        status: CalendarStatsStatus.loaded,
        failure: Failure(),
      ));
      // Réinitialiser les valeurs pour les prochaines utilisations
      _endedEventsCount = null;
      _comingEventsCount = null;
    }
  }
}
