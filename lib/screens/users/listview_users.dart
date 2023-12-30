import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/screens/users/bloc/profile/profile_bloc.dart';
import '/models/models.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == ProfileStatus.error) {
          return const Center(
              child: Text('Erreur lors du chargement des utilisateurs'));
        } else if (state.status == ProfileStatus.loaded) {
          return ListView.builder(
            itemCount: state.allUsers.length,
            itemBuilder: (context, index) {
              User user = state.allUsers[index];
              return ListTile(
                leading: user.profileImageUrl.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user.profileImageUrl),
                      )
                    : const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                title: Text(user.username),
                subtitle: Text(user.bio),
              );
            },
          );
        } else {
          return const Center(child: Text('Aucun utilisateur trouvé'));
        }
      },
    );
  }
}
