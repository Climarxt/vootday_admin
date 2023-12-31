import 'package:bloc/bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'profile_stats_event.dart';
part 'profile_stats_state.dart';

class ProfileStatsBloc extends Bloc<ProfileStatsEvent, ProfileStatsState> {
  final UserRepository _userRepository;

  int? _postCount;
  int? _collectionCount;
  int? _likesCount;

  ProfileStatsBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        super(ProfileStatsState.initial()) {
    on<ProfileStatsPostFetchEvent>(_mapProfileStatsPostFetchEvent);
    on<ProfileStatsCollectionFetchEvent>(_mapProfileStatsCollectionFetchEvent);
    on<ProfileStatsLikesFetchEvent>(_mapProfileStatsLikesFetchEvent);
  }

  Future<void> _mapProfileStatsPostFetchEvent(
    ProfileStatsPostFetchEvent event,
    Emitter<ProfileStatsState> emit,
  ) async {
    _postCount = await _userRepository.getCountPostUser(event.userId);
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapProfileStatsCollectionFetchEvent(
    ProfileStatsCollectionFetchEvent event,
    Emitter<ProfileStatsState> emit,
  ) async {
    _collectionCount = await _userRepository.getCountPostUser(event.userId);
    _updateStateIfDataReady(emit);
  }

  Future<void> _mapProfileStatsLikesFetchEvent(
    ProfileStatsLikesFetchEvent event,
    Emitter<ProfileStatsState> emit,
  ) async {
    _likesCount = await _userRepository.getCountPostUser(event.userId);
    _updateStateIfDataReady(emit);
  }

  void _updateStateIfDataReady(Emitter<ProfileStatsState> emit) {
    if (_postCount != null && _collectionCount != null && _likesCount != null) {
      emit(ProfileStatsState(
        postCount: _postCount!,
        collectionCount: _collectionCount!,
        likesCount: _likesCount!,
        status: ProfileStatsStatus.loaded,
        failure: const Failure(),
      ));
      // Réinitialiser les valeurs pour les prochaines utilisations
      _postCount = null;
      _collectionCount = null;
      _likesCount = null;
    }
  }
}
