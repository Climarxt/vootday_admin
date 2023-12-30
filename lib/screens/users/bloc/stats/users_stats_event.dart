part of 'users_stats_bloc.dart';

abstract class UsersStatsEvent extends Equatable {
  const UsersStatsEvent();

  @override
  List<Object?> get props => [];
}

class UsersStatsManFetchEvent extends UsersStatsEvent {}

class UsersStatsWomanFetchEvent extends UsersStatsEvent {}

class UsersStatsAllFetchEvent extends UsersStatsEvent {}
