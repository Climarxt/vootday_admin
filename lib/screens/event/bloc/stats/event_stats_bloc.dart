import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'event_stats_event.dart';
part 'event_stats_state.dart';

class EventStatsBloc extends Bloc<EventStatsEvent, EventStatsState> {
  final EventRepository _eventRepository;

  EventStatsBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(EventStatsState.initial()) {
    on<EventStatsCountLikesFetchEvent>(_mapEventStatsCountLikesFetchEvent);
  }

  Future<void> _mapEventStatsCountLikesFetchEvent(
    EventStatsCountLikesFetchEvent event,
    Emitter<EventStatsState> emit,
  ) async {
    try {
      debugPrint(
          '_mapEventStatsCountLikesFetchEvent : Fetching count likes...');
      final int likesEventCount =
          await _eventRepository.getTotalLikesForEventPosts(event.eventId);

      if (likesEventCount > 0) {
        debugPrint(
            '_mapEventStatsCountLikesFetchEvent : This count likes fetched successfully.');
        emit(state.copyWith(
            likesEventCount: likesEventCount, status: EventStatsStatus.loaded));
      } else {
        debugPrint('_mapEventStatsCountLikesFetchEvent : No likes found');
        emit(state.copyWith(
            likesEventCount: 0, status: EventStatsStatus.noEvents));
      }
    } catch (err) {
      debugPrint(
          '_mapEventStatsCountLikesFetchEvent : Error fetching likes - $err');
      emit(state.copyWith(
        status: EventStatsStatus.error,
        failure: const Failure(
            message:
                '_mapEventStatsCountLikesFetchEvent : Unable to load the likes'),
        likesEventCount: 0,
      ));
    }
  }
}
