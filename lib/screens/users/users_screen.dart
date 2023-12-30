import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/screens/users/bloc/profile/profile_bloc.dart';
import 'package:vootday_admin/screens/users/bloc/stats/users_stats_bloc.dart';
import 'package:vootday_admin/screens/users/listview_users.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

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
          child: ListView(
            children: [
              _buildHeaderSection(context, size),
              const SizedBox(height: kDefaultPadding),
              SizedBox(
                width: size.width,
                height: size.width / 2,
                child: const DataPage(),
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
            const SummaryCard(
              title: 'Inscriptions des 7 derniers jours',
              value: '**',
              icon: Icons.calendar_month,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            _buildButtonsCard(),
          ],
        );
      },
    );
  }

  Widget _buildButtonsCard() {
    return SizedBox(
      height: 120.0,
      width: 232,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShowFeedButton(context),
                    _buildStatsButton(context),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildImportButton(context),
                    _buildExportButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowFeedButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () {},
      child: const Text('Test1'),
    );
  }

  Widget _buildStatsButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () {},
      child: const Text('Test2'),
    );
  }

  Widget _buildImportButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () {},
      child: const Text('Test3'),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () {},
      child: const Text('Test4'),
    );
  }
}
