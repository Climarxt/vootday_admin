import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'users_stats_event.dart';
part 'users_stats_state.dart';

class UsersStatsBloc extends Bloc<UsersStatsEvent, UsersStatsState> {
  final UserRepository _userRepository;

  int? _manUsersCount;
  int? _womanUsersCount;
  int? _allUsersCount;

  UsersStatsBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        super(UsersStatsState.initial()) {
    on<UsersStatsManFetchEvent>(_mapUsersStatsManFetchEvent);
    on<UsersStatsWomanFetchEvent>(_mapUsersStatsWomanFetchEvent);
    on<UsersStatsAllFetchEvent>(_mapUsersStatsAllFetchEvent);
  }

  Future<void> _mapUsersStatsManFetchEvent(
    UsersStatsManFetchEvent event,
    Emitter<UsersStatsState> emit,
  ) async {
    _manUsersCount = await _userRepository.getCountManUsers();
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapUsersStatsWomanFetchEvent(
    UsersStatsWomanFetchEvent event,
    Emitter<UsersStatsState> emit,
  ) async {
    _womanUsersCount = await _userRepository.getCountWomanUsers();
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapUsersStatsAllFetchEvent(
    UsersStatsAllFetchEvent event,
    Emitter<UsersStatsState> emit,
  ) async {
    _allUsersCount = await _userRepository.getCountAllUsers();
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
