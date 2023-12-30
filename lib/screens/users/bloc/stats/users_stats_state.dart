part of 'users_stats_bloc.dart';

enum UsersStatsStatus { initial, loading, loaded, noEvents, error }

class UsersStatsState extends Equatable {
  final int manUsersCount;
  final int womanUsersCount;
  final int allUsersCount;
  final UsersStatsStatus status;
  final Failure failure;

  const UsersStatsState({
    required this.manUsersCount,
    required this.womanUsersCount,
    required this.allUsersCount,
    required this.status,
    required this.failure,
  });

  factory UsersStatsState.initial() {
    return const UsersStatsState(
      manUsersCount: 0,
      womanUsersCount: 0,
      allUsersCount: 0,
      status: UsersStatsStatus.initial,
      failure: Failure(),
    );
  }

  factory UsersStatsState.loading() {
    return const UsersStatsState(
      manUsersCount: 0,
      womanUsersCount: 0,
      allUsersCount: 0,
      status: UsersStatsStatus.loading,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [manUsersCount, status, failure];

  UsersStatsState copyWith({
    int? manUsersCounts,
    int? womanUsersCounts,
    int? allUsersCounts,
    UsersStatsStatus? status,
    Failure? failure,
  }) {
    return UsersStatsState(
      manUsersCount: manUsersCounts ?? manUsersCount,
      womanUsersCount: womanUsersCounts ?? womanUsersCount,
      allUsersCount: allUsersCounts ?? allUsersCount,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
