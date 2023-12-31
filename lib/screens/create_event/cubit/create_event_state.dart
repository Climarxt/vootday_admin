part of 'create_event_cubit.dart';

enum CreateEventStatus { initial, loading, submitting, success, error }

class CreateEventState extends Equatable {
  final Event? event; // Assuming Event is a model class for your events
  final CreateEventStatus status;
  final String error;

  const CreateEventState({
    required this.event,
    required this.status,
    required this.error,
  });

  factory CreateEventState.initial() {
    return const CreateEventState(
      event: null,
      status: CreateEventStatus.initial,
      error: '',
    );
  }

  @override
  List<Object?> get props => [event, status, error];

  CreateEventState copyWith({
    Event? event,
    CreateEventStatus? status,
    String? error,
  }) {
    return CreateEventState(
      event: event ?? this.event,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
