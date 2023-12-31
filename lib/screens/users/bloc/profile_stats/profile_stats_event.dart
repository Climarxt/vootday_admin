part of 'profile_stats_bloc.dart';

abstract class ProfileStatsEvent extends Equatable {
  const ProfileStatsEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStatsPostFetchEvent extends ProfileStatsEvent {
  final String userId;

  const ProfileStatsPostFetchEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ProfileStatsCollectionFetchEvent extends ProfileStatsEvent {
  final String userId;

  const ProfileStatsCollectionFetchEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ProfileStatsLikesFetchEvent extends ProfileStatsEvent {
  final String userId;

  const ProfileStatsLikesFetchEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
