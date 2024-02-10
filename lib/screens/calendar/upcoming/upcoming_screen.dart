import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/screens/calendar/bloc/blocs.dart';
import 'package:vootday_admin/screens/calendar/upcoming/listview_events.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({super.key});

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CalendarComingSoonBloc>().add(UpcomingEventsLoadAll());
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
    return const Wrap(
      direction: Axis.horizontal,
      spacing: kDefaultPadding,
      runSpacing: kDefaultPadding,
      children: [
        SummaryCard(
          title: 'Nombre **',
          value: '11',
          icon: Icons.people,
          backgroundColor: white,
          textColor: black,
          iconColor: Colors.black12,
          width: 256,
        ),
        SummaryCard(
          title: 'Nombre **',
          value: '11',
          icon: Icons.woman,
          backgroundColor: white,
          textColor: black,
          iconColor: Colors.black12,
          width: 256,
        ),
        SummaryCard(
          title: 'Nombre **',
          value: '11',
          icon: Icons.man,
          backgroundColor: white,
          textColor: black,
          iconColor: Colors.black12,
          width: 256,
        ),
        UserPieChart(
          manUsersCount: 11,
          womanUsersCount: 11,
          allUsersCount: 22,
        ),
        // buildButtonsCard(),
      ],
    );
  }
}
