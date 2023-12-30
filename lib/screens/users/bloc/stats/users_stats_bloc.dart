import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'users_stats_event.dart';
part 'users_stats_state.dart';

class UsersStatsBloc extends Bloc<UsersStatsEvent, UsersStatsState> {
  final EventRepository _eventRepository;

  int? _manUsersCount;
  int? _womanUsersCount;
  int? _allUsersCount;

  UsersStatsBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(UsersStatsState.initial()) {
    on<UsersStatsManFetchEvent>(_mapUsersStatsManFetchEvent);
    on<UsersStatsWomanFetchEvent>(_mapUsersStatsWomanFetchEvent);
    on<UsersStatsAllFetchEvent>(_mapUsersStatsAllFetchEvent);
  }

  Future<void> _mapUsersStatsManFetchEvent(
    UsersStatsManFetchEvent event,
    Emitter<UsersStatsState> emit,
  ) async {
    _manUsersCount = await _eventRepository.getCountEndedEvents();
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapUsersStatsWomanFetchEvent(
    UsersStatsWomanFetchEvent event,
    Emitter<UsersStatsState> emit,
  ) async {
    _womanUsersCount = await _eventRepository.getCountComingEvents();
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapUsersStatsAllFetchEvent(
    UsersStatsAllFetchEvent event,
    Emitter<UsersStatsState> emit,
  ) async {
    _allUsersCount = await _eventRepository.getCountComingEvents();
    _updateStateIfDataReady(emit);
  }

  void _updateStateIfDataReady(Emitter<UsersStatsState> emit) {
    if (_manUsersCount != null &&
        _womanUsersCount != null &&
        _allUsersCount != null) {
      emit(UsersStatsState(
        manUsersCount: _manUsersCount!,
        womanUsersCount: _womanUsersCount!,
        allUsersCount: _allUsersCount!,
        status: UsersStatsStatus.loaded,
        failure: const Failure(),
      ));
      // Réinitialiser les valeurs pour les prochaines utilisations
      _manUsersCount = null;
      _womanUsersCount = null;
      _allUsersCount = null;
    }
  }
}
