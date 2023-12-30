import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'calendar_stats_event.dart';
part 'calendar_stats_state.dart';

class CalendarStatsBloc extends Bloc<CalendarStatsEvent, CalendarStatsState> {
  CalendarStatsBloc() : super(CalendarStatsInitial()) {
    on<CalendarStatsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
