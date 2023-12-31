part of 'create_event_cubit.dart';

enum CreateEventStatus { initial, loading, submitting, success, error }

class CreateEventState extends Equatable {
  final Event? event;
  final List<String> tags;
  final CreateEventStatus status;
  final String error;

  const CreateEventState({
    required this.event,
    required this.tags,
    required this.status,
    required this.error,
  });

  factory CreateEventState.initial() {
    return const CreateEventState(
      event: null,
      tags: [],
      status: CreateEventStatus.initial,
      error: '',
    );
  }

  @override
  List<Object?> get props => [event, tags, status, error];

  CreateEventState copyWith({
    Event? event,
    List<String>? tags,
    CreateEventStatus? status,
    String? error,
  }) {
    return CreateEventState(
      event: event ?? this.event,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      error: error ?? this.error,
    );
  }
}
