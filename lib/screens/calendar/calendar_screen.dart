import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/screens/calendar/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarEndedBloc>().add(CalendarEndedFetchEvent());
    context.read<CalendarComingSoonBloc>().add(CalendarComingSoonFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: webBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Scaffold(
          floatingActionButton: _buildFloatingActionButton(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          backgroundColor: webBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Events Done
                Card(
                    child: Stack(
                  children: [
                    buildSectionTitle('Ended events'),
                    BlocBuilder<CalendarEndedBloc, CalendarEndedState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case CalendarEndedStatus.loaded:
                            return SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      buildEventsTable(state.thisWeekEvents),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          case CalendarEndedStatus.loading:
                          default:
                            return Container(color: white);
                        }
                      },
                    ),
                  ],
                )),
                const SizedBox(height: 28),
                // Coming Soon Events Section
                Card(
                  child: Stack(
                    children: [
                      buildSectionTitle('Coming soon'),
                      BlocBuilder<CalendarComingSoonBloc,
                          CalendarComingSoonState>(
                        builder: (context, state) {
                          switch (state.status) {
                            case CalendarComingSoonStatus.loaded:
                              return SizedBox(
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 18,
                                        ),
                                        buildEventsTable(
                                            state.thisComingSoonEvents),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            case CalendarComingSoonStatus.loading:
                            default:
                              return Container(color: white);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEventsTable(List<Event?> events) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Actions')),
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Brand')),
        DataColumn(label: Text('Title')),
        DataColumn(label: Text('Date Created')),
        DataColumn(label: Text('Date End')),
        DataColumn(label: Text('Date Event')),
        DataColumn(label: Text('Participants')),
        DataColumn(label: Text('Done')),
      ],
      rows: events.map((event) {
        if (event == null) return DataRow(cells: [DataCell(Text('N/A'))]);
        return DataRow(
          cells: [
            DataCell(Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () => _navigateToEventScreen(context, event.id),
                ),
              ],
            )),
            DataCell(Text(event.id)),
            DataCell(Text(event.author.author)),
            DataCell(Text(event.title)),
            DataCell(Text(DateFormat('yyyy-MM-dd').format(event.date))),
            DataCell(Text(DateFormat('yyyy-MM-dd').format(event.dateEnd))),
            DataCell(Text(DateFormat('yyyy-MM-dd').format(event.dateEvent))),
            DataCell(Text(event.participants.toString())),
            DataCell(Icon(event.done ? Icons.check : Icons.close)),
          ],
        );
      }).toList(),
    );
  }

  void _navigateToEventScreen(BuildContext context, String eventId) {
    GoRouter.of(context).go('/calendar/event/$eventId', extra: eventId);
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 5.0, top: 5.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.black),
      ),
    );
  }

  // Builds the floating action button
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: () {},
      label: Text(
        'Add Event',
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white),
      ),
    );
  }
}
