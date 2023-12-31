part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileFetchProfile extends ProfileEvent {
  final String userId;

  const ProfileFetchProfile({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ProfileLoadUser extends ProfileEvent {
  final String userId;

  const ProfileLoadUser({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ProfileUpdatePosts extends ProfileEvent {
  final List<Post?> posts;

  const ProfileUpdatePosts({required this.posts});

  @override
  List<Object> get props => [posts];
}

class UpdateProfile extends ProfileEvent {
  final User user;
  final String userId;

  const UpdateProfile({required this.user, required this.userId});

  @override
  List<Object> get props => [user];
}

class ProfileLoadAllUsers extends ProfileEvent {
  @override
  List<Object> get props => [];
}
