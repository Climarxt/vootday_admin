part of 'search_cubit.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final List<User> users;
  final SearchStatus status;
  final Failure failure;
  final User selectedUser; // Champ pour stocker l'utilisateur sélectionné

  const SearchState({
    required this.users,
    required this.status,
    required this.failure,
    required this.selectedUser, // Initialisez-le à null
  });

  factory SearchState.initial() {
    return const SearchState(
        users: [],
        status: SearchStatus.initial,
        failure: Failure(),
        selectedUser: User.empty);
  }

  @override
  List<Object?> get props =>
      [users, status, failure, selectedUser]; // Ajoutez selectedUser aux props

  SearchState copyWith({
    List<User>? users,
    SearchStatus? status,
    Failure? failure,
    User? selectedUser, // Incluez-le dans la méthode copyWith
  }) {
    return SearchState(
      users: users ?? this.users,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      selectedUser:
          selectedUser ?? this.selectedUser, // Copiez la valeur de selectedUser
    );
  }
}
