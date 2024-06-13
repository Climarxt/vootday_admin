import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/screens/calendar/bloc/blocs.dart';
import 'package:vootday_admin/screens/calendar/events/listview_events.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CalendarStatsBloc>().add(CalendarStatsCountEndedFetchEvent());
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
                expandedHeight: 96.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const  Text('Ended Events'),
                  background: _buildHeaderSection(context, size),
                ),
              ),
              const SliverFillRemaining(
                hasScrollBody: false,
                child: DataPage(),
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
              value: state.endedEventsCount.toString(),
              icon: Icons.calendar_month,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            // _buildButtonsCard(),
          ],
        );
      },
    );
  }
}
