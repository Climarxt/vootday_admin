import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'profile_stats_event.dart';
part 'profile_stats_state.dart';

class ProfileStatsBloc extends Bloc<ProfileStatsEvent, ProfileStatsState> {
  final UserRepository _userRepository;

  int? _manUsersCount;
  int? _womanUsersCount;
  int? _allUsersCount;

  ProfileStatsBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        super(ProfileStatsState.initial()) {
    on<ProfileStatsManFetchEvent>(_mapProfileStatsManFetchEvent);
    on<ProfileStatsWomanFetchEvent>(_mapProfileStatsWomanFetchEvent);
    on<ProfileStatsAllFetchEvent>(_mapProfileStatsAllFetchEvent);
  }

  Future<void> _mapProfileStatsManFetchEvent(
    ProfileStatsManFetchEvent event,
    Emitter<ProfileStatsState> emit,
  ) async {
    _manUsersCount = await _userRepository.getCountManUsers();
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapProfileStatsWomanFetchEvent(
    ProfileStatsWomanFetchEvent event,
    Emitter<ProfileStatsState> emit,
  ) async {
    _womanUsersCount = await _userRepository.getCountWomanUsers();
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapProfileStatsAllFetchEvent(
    ProfileStatsAllFetchEvent event,
    Emitter<ProfileStatsState> emit,
  ) async {
    _allUsersCount = await _userRepository.getCountAllUsers();
    _updateStateIfDataReady(emit);
  }

  void _updateStateIfDataReady(Emitter<ProfileStatsState> emit) {
    if (_manUsersCount != null &&
        _womanUsersCount != null &&
        _allUsersCount != null) {
      emit(ProfileStatsState(
        postCount: _manUsersCount!,
        collectionCount: _womanUsersCount!,
        likesCount: _allUsersCount!,
        status: ProfileStatsStatus.loaded,
        failure: const Failure(),
      ));
      // Réinitialiser les valeurs pour les prochaines utilisations
      _manUsersCount = null;
      _womanUsersCount = null;
      _allUsersCount = null;
    }
  }
}
