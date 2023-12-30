import 'package:bloc/bloc.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository;

  EventBloc({
    required EventRepository eventRepository,
  })  : _eventRepository = eventRepository,
        super(EventState.initial()) {
    on<EventFetchEvent>(_mapEventFetchEvent);
    on<EventUpdateFieldEvent>(_onEventUpdateFieldEvent);
  }

  Future<void> _mapEventFetchEvent(
    EventFetchEvent fetchEvent,
    Emitter<EventState> emit,
  ) async {
    try {
      print('EventBloc: Fetching event ${fetchEvent.eventId}...');
      final Event? eventDetails =
          await _eventRepository.getEventById(fetchEvent.eventId);
      if (eventDetails != null) {
        print('EventBloc: Event ${fetchEvent.eventId} fetched successfully.');
        emit(state.copyWith(event: eventDetails, status: EventStatus.loaded));
      } else {
        print('EventBloc: Event ${fetchEvent.eventId} not found.');
        emit(state.copyWith(event: null, status: EventStatus.noEvents));
      }
    } catch (err) {
      print('EventBloc: Error fetching event - $err');
      emit(state.copyWith(
        status: EventStatus.error,
        failure: Failure(message: 'Unable to load the event - $err'),
      ));
    }
  }

  Future<void> _onEventUpdateFieldEvent(
    EventUpdateFieldEvent event,
    Emitter<EventState> emit,
  ) async {
    try {
      await _eventRepository.updateEventField(
          event.eventId, event.field, event.newValue);
      final Event? updatedEvent =
          await _eventRepository.getEventById(event.eventId);
      emit(state.copyWith(event: updatedEvent, status: EventStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: EventStatus.error,
        failure:
            Failure(message: 'Unable to update the event - ${e.toString()}'),
      ));
    }
  }
}
