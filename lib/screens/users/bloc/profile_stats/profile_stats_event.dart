part of 'profile_stats_bloc.dart';

abstract class ProfileStatsEvent extends Equatable {
  const ProfileStatsEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStatsManFetchEvent extends ProfileStatsEvent {}

class ProfileStatsWomanFetchEvent extends ProfileStatsEvent {}

class ProfileStatsAllFetchEvent extends ProfileStatsEvent {}
