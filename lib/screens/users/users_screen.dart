import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/screens/users/bloc/profile/profile_bloc.dart';
import 'package:vootday_admin/screens/users/bloc/stats/users_stats_bloc.dart';
import 'package:vootday_admin/screens/users/listview_users.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';
import 'package:vootday_admin/screens/users/widgets/widgets.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<UsersStatsBloc>().add(UsersStatsManFetchEvent());
    context.read<UsersStatsBloc>().add(UsersStatsWomanFetchEvent());
    context.read<UsersStatsBloc>().add(UsersStatsAllFetchEvent());
    context.read<ProfileBloc>().add(ProfileLoadAllUsers());
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Scaffold(
        backgroundColor: white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 136.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeaderSection(context, size),
                ),
              ),
              const SliverFillRemaining(
                hasScrollBody: false,
                child: DataPage(), // Utilisation de DataPage ici
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, Size size) {
    return BlocBuilder<UsersStatsBloc, UsersStatsState>(
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          spacing: kDefaultPadding,
          runSpacing: kDefaultPadding,
          children: [
            SummaryCard(
              title: 'Nombre Utilisateurs',
              value: state.allUsersCount.toString(),
              icon: Icons.people,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            SummaryCard(
              title: 'Nombre de femmes',
              value: state.womanUsersCount.toString(),
              icon: Icons.woman,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            SummaryCard(
              title: 'Nombre d\'homme',
              value: state.manUsersCount.toString(),
              icon: Icons.man,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            UserPieChart(
              manUsersCount: state.manUsersCount,
              womanUsersCount: state.womanUsersCount,
              allUsersCount: state.allUsersCount,
            ),
            buildButtonsCard(),
          ],
        );
      },
    );
  }
}
