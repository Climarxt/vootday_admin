import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository _userRepository;

  SearchCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchState.initial());

  void searchUsersBrand(String query) async {
    debugPrint(
        'Searching users with query: $query'); // Ajoutez ce print pour afficher la requête de recherche

    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final users = await _userRepository.searchUsersBrand(query: query);
      debugPrint(
          'Found ${users.length} users matching the query.'); // Ajoutez ce print pour afficher le nombre d'utilisateurs trouvés
      emit(state.copyWith(users: users, status: SearchStatus.loaded));
    } catch (err) {
      debugPrint(
          'Error searching users: $err'); // Ajoutez ce print pour afficher les erreurs
      state.copyWith(
        status: SearchStatus.error,
        failure:
            const Failure(message: 'Something went wrong. Please try again.'),
      );
    }
  }

  void selectUser(User user) {
    emit(state.copyWith(selectedUser: user));
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchStatus.initial));
  }

  void resetSearch() {
    emit(SearchState.initial());
  }
}
