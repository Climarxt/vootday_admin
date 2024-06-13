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
    context.read<CalendarStatsBloc>().add(CalendarStatsCountComingFetchEvent());
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
    return BlocBuilder<CalendarStatsBloc, CalendarStatsState>(
      builder: (context, state) {
        if (state.comingEventsStatus == CalendarStatsStatus.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.comingEventsStatus == CalendarStatsStatus.error) {
          return Center(child: Text('Failed to load data'));
        } else {
          return Wrap(
            direction: Axis.horizontal,
            spacing: kDefaultPadding,
            runSpacing: kDefaultPadding,
            children: [
              const SummaryCard(
                title: 'Data 1',
                value: '**',
                icon: Icons.person,
                backgroundColor: white,
                textColor: black,
                iconColor: Colors.black12,
                width: 256,
              ),
              SummaryCard(
                title: 'Data 2',
                value: state.comingEventsCount.toString(),
                icon: Icons.calendar_month,
                backgroundColor: white,
                textColor: black,
                iconColor: Colors.black12,
                width: 256,
              ),
            ],
          );
        }
      },
    );
  }
}
