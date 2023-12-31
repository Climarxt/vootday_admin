import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';

part 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  final EventRepository _eventRepository;
  final StorageRepository _storageRepository;

  CreateEventCubit({
    required EventRepository eventRepository,
    required StorageRepository storageRepository,
  })  : _eventRepository = eventRepository,
        _storageRepository = storageRepository,
        super(CreateEventState.initial());

  Future<void> createEvent(Event event) async {
    try {
      emit(state.copyWith(status: CreateEventStatus.loading));
      await _eventRepository.createEvent(event: event);
      emit(state.copyWith(status: CreateEventStatus.success));
    } catch (e) {
      emit(
          state.copyWith(status: CreateEventStatus.error, error: e.toString()));
    }
  }
}
