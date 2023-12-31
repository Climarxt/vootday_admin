import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
    debugPrint('createEvent in Cubit called with event: ${event.id}');
    try {
      emit(state.copyWith(status: CreateEventStatus.loading));
      debugPrint('Emitting loading state');
      await _eventRepository.createEvent(event: event);
      debugPrint('Event created successfully');
      emit(state.copyWith(status: CreateEventStatus.success));
    } catch (e) {
      debugPrint('Error creating event: $e');
      emit(
          state.copyWith(status: CreateEventStatus.error, error: e.toString()));
    }
  }

  void addTag(String tag) {
    if (tag.isNotEmpty && !state.tags.contains(tag)) {
      // Avoid adding empty or duplicate tags
      final updatedTags = List<String>.from(state.tags)..add(tag);
      emit(
          state.copyWith(tags: updatedTags, status: CreateEventStatus.initial));
    }
  }

  void removeTag(String tag) {
    final updatedTags = List<String>.from(state.tags)..remove(tag);
    emit(state.copyWith(tags: updatedTags, status: CreateEventStatus.initial));
  }
}
