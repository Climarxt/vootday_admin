import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'event_stats_event.dart';
part 'event_stats_state.dart';

class EventStatsBloc extends Bloc<EventStatsEvent, EventStatsState> {
  final EventRepository _eventRepository;

  int? _likesEventCount;
  int? _remainingDaysCount;

  EventStatsBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(EventStatsState.initial()) {
    on<EventStatsCountLikesFetchEvent>(_mapEventStatsCountLikesFetchEvent);
    on<EventStatsRemainingDaysFetchEvent>(
        _mapEventStatsRemainingDaysFetchEvent);
  }

  Future<void> _mapEventStatsCountLikesFetchEvent(
    EventStatsCountLikesFetchEvent event,
    Emitter<EventStatsState> emit,
  ) async {
    // Logique pour récupérer les likes
    _likesEventCount =
        await _eventRepository.getTotalLikesForEventPosts(event.eventId);
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapEventStatsRemainingDaysFetchEvent(
    EventStatsRemainingDaysFetchEvent event,
    Emitter<EventStatsState> emit,
  ) async {
    // Logique pour récupérer les jours restants
    _remainingDaysCount =
        await _eventRepository.getRemainingDaysForEvent(event.eventId);
    _updateStateIfDataReady(emit);
  }

  void _updateStateIfDataReady(Emitter<EventStatsState> emit) {
    if (_likesEventCount != null && _remainingDaysCount != null) {
      emit(EventStatsState(
        likesEventCount: _likesEventCount!,
        remainingDaysCount: _remainingDaysCount!,
        status: EventStatsStatus.loaded,
        failure: Failure(),
      ));
      // Réinitialiser les valeurs pour les prochaines utilisations
      _likesEventCount = null;
      _remainingDaysCount = null;
    }
  }
}
