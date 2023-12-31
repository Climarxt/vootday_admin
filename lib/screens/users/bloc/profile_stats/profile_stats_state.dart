part of 'profile_stats_bloc.dart';

enum ProfileStatsStatus { initial, loading, loaded, noEvents, error }

class ProfileStatsState extends Equatable {
  final int postCount;
  final int collectionCount;
  final int likesCount;
  final ProfileStatsStatus status;
  final Failure failure;

  const ProfileStatsState({
    required this.postCount,
    required this.collectionCount,
    required this.likesCount,
    required this.status,
    required this.failure,
  });

  factory ProfileStatsState.initial() {
    return const ProfileStatsState(
      postCount: 0,
      collectionCount: 0,
      likesCount: 0,
      status: ProfileStatsStatus.initial,
      failure: Failure(),
    );
  }

  factory ProfileStatsState.loading() {
    return const ProfileStatsState(
      postCount: 0,
      collectionCount: 0,
      likesCount: 0,
      status: ProfileStatsStatus.loading,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [postCount, status, failure];

  ProfileStatsState copyWith({
    int? manUsersCounts,
    int? womanUsersCounts,
    int? allUsersCounts,
    ProfileStatsStatus? status,
    Failure? failure,
  }) {
    return ProfileStatsState(
      postCount: manUsersCounts ?? postCount,
      collectionCount: womanUsersCounts ?? collectionCount,
      likesCount: allUsersCounts ?? likesCount,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
