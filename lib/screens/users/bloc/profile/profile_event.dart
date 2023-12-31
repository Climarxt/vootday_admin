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

class ProfileUpdateFieldProfile extends ProfileEvent {
  final String userId;
  final String field;
  final dynamic newValue;

  const ProfileUpdateFieldProfile({
    required this.userId,
    required this.field,
    required this.newValue,
  });

  @override
  List<Object> get props => [userId, field, newValue];
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
