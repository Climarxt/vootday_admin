import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  StreamSubscription? _authSubscription;

  StreamSubscription<List<Future<Post?>>>? _postsSubscription;

  ProfileBloc({
    required AuthBloc authBloc,
    required UserRepository userRepository,
    required PostRepository postRepository,
  })  : _authBloc = authBloc,
        _userRepository = userRepository,
        _postRepository = postRepository,
        super(ProfileState.initial()) {
    on<ProfileFetchProfile>(_mapProfileFetchProfile);
    on<ProfileLoadUser>(_onProfileLoadUser);
    on<ProfileLoadAllUsers>(_onProfileLoadAllUsers);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user is AuthUserChanged) {
        if (state.user != null) {
          add(ProfileLoadUser(userId: state.user!.uid));
        }
      }
    });
  }

  Future<void> _mapProfileFetchProfile(
    ProfileFetchProfile fetchUser,
    Emitter<ProfileState> emit,
  ) async {
    try {
      debugPrint('ProfileFetchProfile : Fetching profile ${fetchUser.userId}...');
      final User? userDetails =
          await _userRepository.getUserById(fetchUser.userId);
      if (userDetails != null) {
        debugPrint(
            'ProfileFetchProfile : Profile ${fetchUser.userId} fetched successfully.');
        emit(state.copyWith(user: userDetails, status: ProfileStatus.loaded));
      } else {
        debugPrint(
            'ProfileFetchProfile : Profile ${fetchUser.userId} not found.');
        emit(state.copyWith(user: null, status: ProfileStatus.error));
      }
    } catch (err) {
      debugPrint('ProfileFetchProfile : Error fetching profile - $err');
      emit(state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(message: 'Unable to load the profile - $err'),
      ));
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }

  void _onProfileLoadUser(
    ProfileLoadUser event,
    Emitter<ProfileState> emit,
  ) {
    _postsSubscription?.cancel();
    _postsSubscription = _postRepository
        .getUserPosts(userId: event.userId)
        .listen((posts) async {
      final allPosts = await Future.wait(posts);

      add(ProfileUpdatePosts(posts: allPosts));
    });

    _userRepository.getUser(event.userId).listen((user) {
      if (isClosed) {
        return;
      }
      add(UpdateProfile(user: user, userId: event.userId));
      state.copyWith(status: ProfileStatus.loading);
    });
  }

  void _onProfileLoadAllUsers(
    ProfileLoadAllUsers event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final List<Map<String, dynamic>> allUsers =
          await _userRepository.getAllUsers();
      emit(state.copyWith(allUsers: allUsers, status: ProfileStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(message: e.toString()),
      ));
    }
  }
}
