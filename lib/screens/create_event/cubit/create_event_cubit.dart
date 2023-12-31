import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit() : super(CreateEventInitial());
}
